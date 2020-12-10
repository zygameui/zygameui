package zygame.mini;

import zygame.script.ZHaxe;
import zygame.mini.MiniEvent;

/**
 * 内置迷你引擎，可用于开发内置小游戏、动态页面等。
 * 并通过loadHaxeApp来加载内置小游戏程序，自动解析Haxe为可运行的脚本。
 */
class MiniEngine {

	/**
	 * 加载HaxeApp内置应用
	 * @param url 内置小游戏zip包路径
	 */
	public static function loadHaxeApp(url:String, call:MiniEngineAssets->Void):Void {
		var assets:MiniEngineAssets = new MiniEngineAssets();
		assets.path = url;
		assets.loadAssetsZip(url);
		assets.start(function(f) {
			if (f == 1) {
				call(assets);
			}
		});
	}

	/**
	 * 解析haxe代码为XML（ZBuilder）格式
	 * @param haxeCode
	 * @return Xml
	 */
	public static function parseMiniHaxe(haxeCode:String):MiniEngineHaxe {
		var miniHaxe = new MiniEngineHaxe(haxeCode);
		var xml:Xml = Xml.createDocument();
		miniHaxe.xml = xml;
		var className:String = haxeCode.substr(haxeCode.indexOf("extends ") + 8);
		className = className.substr(0, className.indexOf("{"));
		className = StringTools.replace(className, " ", "");
		var root:Xml = Xml.createElement(className);
		xml.insertChild(root, 0);
		var index:Int = 0;
		// 定义变量
		for (item in miniHaxe.vars) {
			if (!item.isStatic) {
				var xmlItem = null;
				switch (item.type) {
					case ZInt:
						xmlItem = Xml.createElement("ZInt");
					case ZFloat:
						xmlItem = Xml.createElement("ZFloat");
					case ZBool:
						xmlItem = Xml.createElement("ZBool");
					case ZString:
						xmlItem = Xml.createElement("ZString");
					case ZObject:
						xmlItem = Xml.createElement("ZObject");
				}
				xmlItem.set("id", item.name);
				if (item.data != null)
					xmlItem.set("value", Std.string(item.data));
				root.insertChild(xmlItem, index);
				index++;
			}
		}
		// 定义方法
		for (item in miniHaxe.functions) {
			if (!item.isStatic) {
				var xmlItem = Xml.createElement("ZHaxe");
				xmlItem.insertChild(Xml.createPCData(item.hscript), 0);
				xmlItem.set("id", item.name);
				if (item.args != "")
					xmlItem.set("args", item.args);
				root.insertChild(xmlItem, index);
				index++;
			}
		}
		return miniHaxe;
	}
}

/**
 * Haxe引擎头部内容
 */
class MiniEngineHaxe {
	public static var IGONEATTR:Array<String> = ["x", "y", "alpha", "width", "height", "scaleX", "scaleY", "dataProvider"];

	public static var VARATTR:Array<String> = ["1","2","3","4","5","6","7","8","9","0","-"];

	public var xml:Xml = null;

	public var imports:Map<String, String> = [];

	public var functions:Map<String, Func> = [];

	public var vars:Map<String, Var> = [];

	public function new(haxeCode:String) {
		var code = haxeCode.split("\n");
		var isFunc:Bool = false;
		var funcCount:Int = -1;
		var func:Func = null;
		for (item in code) {
			if (isFunc) {
				if (item.indexOf("var") != -1) {
					// 局部变量实现
					func.pushVar(item);
					continue;
				} else if (item.indexOf("super") != -1) {
					// 忽略
					continue;
				}
				if (item.indexOf("{") != -1) {
					funcCount++;
					if (funcCount == 0)
						item = StringTools.replace(item, "{", "");
				}
				if (item.indexOf("}") != -1) {
					funcCount--;
					if (funcCount == -1)
						isFunc = false;
					if (!isFunc)
						item = StringTools.replace(item, "}", "");
				}
				func.pushScript(item);
				if (!isFunc) {
					functions.set(func.name, func);
					func = null;
				}
			} else if (item.indexOf("var ") != -1) {
				var value = new Var(item);
				vars.set(value.name, value);
			} else if (item.indexOf("import ") != -1) {
				var typeName:String = StringTools.replace(StringTools.replace(item, "import ", ""), ";", "");
				imports.set(typeName.substr(typeName.lastIndexOf(".") + 1), typeName);
			} else if (item.indexOf("function ") != -1 && item.indexOf("}") == -1) {
				if (item.indexOf("{") != -1)
					funcCount = 0;
				else
					funcCount = -1;
				isFunc = true;
				func = new Func(item);
			}
		}
		for (func in functions) {
			var hasNew:Bool = false;
			var lastAtt:String = "";
			var hasThis:Bool = false;
			for (att in func.attNames) {
				if (att.name == "new") {
					func.hscript = StringTools.replace(func.hscript, att.target, "");
					hasNew = true;
					lastAtt = att.name;
					continue;
				}
				if (att.name == "this") {
					if (func.hscript.indexOf(att.target + "$") == -1) {
						func.hscript = StringTools.replace(func.hscript, att.target, "this");
						lastAtt = "";
					} else {
						hasThis = true;
						func.hscript = StringTools.replace(func.hscript, att.target, "");
						lastAtt = att.name;
					}
					continue;
				}
				if (hasNew) {
					hasNew = false;
					func.hscript = StringTools.replace(func.hscript, att.target, "new " + att.name);
					lastAtt = att.name;
					continue;
				}
				if (functions.exists(att.name)) {
					// if(func.hscript.indexOf("this." + att.target) != -1 || func.hscript.indexOf("." + att.target) == -1)
					// 	func.hscript = StringTools.replace(func.hscript, att.target, att.name + ".value");
					// else
						func.hscript = StringTools.replace(func.hscript, att.target, att.name);
				} else if (vars.exists(att.name) && !vars.get(att.name).isStatic) {
					if(func.hscript.indexOf("this." + att.target) != -1 || func.hscript.indexOf("." + att.target) == -1
						|| func.hscript.indexOf(att.target + ".") != -1 || func.hscript.indexOf(att.target + "[") != -1)
					{
						func.hscript = StringTools.replace(func.hscript, att.target, att.name + ".value");
					}
					else
					{
						func.hscript = StringTools.replace(func.hscript, att.target, att.name);
					}
				} else {
					var attName:String = att.name;
					if (attName.indexOf(":") != -1 && attName.length > 1){
						var mhend:String = attName.substr(attName.indexOf(":") + 1);
						var start = mhend.charAt(0);
						if(Func.NAMEPIX.indexOf(start) == -1 && VARATTR.indexOf(start) == -1 && start == start.toUpperCase())
						{
							attName = attName.substr(0, attName.lastIndexOf(":"));
						}
					}
					func.hscript = StringTools.replace(func.hscript, att.target, (hasThis ? "this." : "") + attName);
				}
				hasThis = false;
				lastAtt = att.name;
			}
		}
	}
}

/**
 * 方法内容
 */
class Func {
	public static var NAMEPIX:String = "!{}/*%+-<>=;(),.\"[]'  		";

	public var hscript:String = "";

	public var name:String;

	public var attNames:Array<Dynamic> = [];

	// 局部变量
	public var vars:Map<String, Var> = [];

	private var attIndex:Int = 0;

	/**
	 * 传参名称列表
	 */
	public var args:String;

	/**
	 * 是否静态方法
	 */
	public var isStatic:Bool = false;

	public function new(funcScript:String) {
		var funcName = funcScript;
		isStatic = funcName.indexOf("static") != -1;
		funcName = funcName.substr(funcName.indexOf("function ") + 8);
		funcName = funcName.substr(0, funcName.lastIndexOf("("));
		funcName = StringTools.replace(funcName, " ", "");

		// if (funcName == "new")
		// 	funcName = "super";
		name = funcName;

		// 解析传参参数
		args = funcScript.substr(funcScript.indexOf("(") + 1);
		args = args.substr(0, args.lastIndexOf(")"));
		var arr = args.split(",");
		for (i in 0...arr.length) {
			var att = arr[i];
			if (att.indexOf(":") != -1)
				att = att.substr(0, att.lastIndexOf(":"));
			arr[i] = att;
			arr[i] = StringTools.replace(arr[i], " ", "");
		}
		args = arr.join(",");
	}

	/**
	 * 追加变量属性
	 * @param varValue
	 */
	public function pushVar(item:String):Void {
		var varValue = new Var(item);
		vars.set(varValue.name, varValue);
		pushScript(item);
	}

	/**
	 * 追加脚本解析
	 * @param str
	 */
	public function pushScript(str:String):Void {
		if(str.indexOf("case ") != -1)
		{
			hscript += str + "\n";
			return;
		}
		str = StringTools.replace(str, "MiniUtils.getAssets()", "assets");
		str = StringTools.replace(str, "MiniUtils.getApp()", "app");
		var newstr = "";
		var attName:String = "";
		var hasThis:Bool = false;
		var hasString:String = "";
		for (i in 0...str.length) {
			var n = str.charAt(i);
			if (NAMEPIX.indexOf(n) != -1 || i == str.length - 1) {
				// 字符串解析
				if (hasString != "") {
					if (hasString == n) {
						// 结束
						hasString = "";
					}
					newstr += n;
					continue;
				}
				if ((n == "\"" || n == "'")) {
					// 字符串
					hasString = n;
				}
				if (attName != "") {
					hasThis = attName == "this";
					newstr += "${" + attIndex + "}";
					attNames.push({name: attName, target: "${" + attIndex + "}"});
					attName = "";
					attIndex++;
				}
				if (!hasThis || n != ".") {
					newstr += n;
				}
				hasThis = false;
			} else {
				if (hasString != "")
					newstr += n;
				else
					attName += n;
			}
		}
		hscript += newstr + "\n";
	}
}

/**
 * 变量定义
 */
class Var {
	public var name:String = null;

	public var data:Dynamic = null;

	public var type:Class<Dynamic> = null;

	public var isStatic:Bool = false;

	public function new(value:String) {
		if (value.indexOf("static") != -1)
			isStatic = true;
		var ptype:String = "Dynamic";
		if (value.indexOf(":") != -1) {
			name = value.substr(value.indexOf("var ") + 4);
			name = name.substr(0, name.indexOf(":"));
		} else if (value.indexOf("=") != -1) {
			name = value.substr(value.indexOf("var ") + 4);
			name = name.substr(0, name.indexOf("="));
		}
		name = StringTools.replace(name, " ", "");
		if (value.indexOf(":") != -1)
			ptype = value.substr(value.indexOf(":") + 1);
		ptype = ptype.substr(0, ptype.indexOf("="));
		ptype = StringTools.replace(ptype, " ", "");
		var pvalue:String = value.substr(value.indexOf("=") + 1);
		pvalue = pvalue.substr(0, pvalue.indexOf(";"));
		pvalue = StringTools.replace(pvalue, " ", "");
		if (pvalue.length == 0)
			pvalue = null;
		switch (ptype) {
			case "Int":
				type = ZInt;
				if (pvalue != null)
					data = Std.parseInt(pvalue);
			case "Bool":
				type = ZBool;
				if (pvalue != null)
					data = pvalue == "true";
			case "Float":
				type = ZFloat;
				if (pvalue != null)
					data = Std.parseFloat(pvalue);
			case "String":
				type = ZString;
				if (pvalue != null) {
					pvalue = pvalue.substr(1);
					pvalue = pvalue.substr(0, pvalue.length - 1);
					data = pvalue;
				}
			default:
				type = ZObject;
				data = null;
		}
	}
}
