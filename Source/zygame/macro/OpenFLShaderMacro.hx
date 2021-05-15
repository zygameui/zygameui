package zygame.macro;

import haxe.macro.ExprTools;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * 解析OpenFLShader的宏处理
 */
class OpenFLShaderMacro {
	public static var uniform:Map<String, String>;

	public static var lastType:String;

	macro public static function buildShader():Array<Field> {
		var fields = Context.getBuildFields();
		var isDebug = Context.getLocalClass().get().meta.has(":debug");
		var shader = "\n\r";
		var maps:Map<String, String> = [];
		uniform = [];
		for (field in fields) {
			// trace(field.kind.getName());
			switch (field.kind.getName()) {
				case "FVar":
					var isUniform = field.meta.filter(f -> f.name == ":uniform").length > 0;
					if (isUniform) {
						// 变量定义
						var type:ComplexType = cast field.kind.getParameters()[0];
						var value = cast field.kind.getParameters()[1];
						var c = type == null ? toExprType(value.expr) : type.getParameters()[0].name.toLowerCase();
						if (value == null) {
							uniform.set(field.name, "uniform " + c + " u_" + field.name + ";\n\r");
						} else {
							uniform.set(field.name, "uniform " + c + " u_" + field.name + "=" + toExprValue(value.expr) + ";\n\r");
						}
						shader += uniform.get(field.name);
					}
				case "FFun":
					// 方法解析
					if (field.name != "fragment")
						continue;
					maps.set(field.name, "");
					shader += "\n\rvoid " + field.name + "(){\n\r";
					var func:ExprDef = cast field.kind.getParameters()[0].expr.expr;
					var array:Array<Dynamic> = func.getParameters()[0];
					for (index => value in array) {
						var expr:ExprDef = cast value.expr;
						// trace("方法解析：", expr.getName());
						var line:String = "";
						switch (expr.getName()) {
							case "EField":
							// 已定义对象赋值
							case "EVars":
								// 定义局部变量
								var vars = expr.getParameters()[0];
								var varvalue = vars[0].expr;
								line += "  " + (vars[0].type != null ? toExprType(vars[0].type) : toExprType(varvalue.expr)) + " " + vars[0].name;
								// trace(varvalue);
								if (varvalue != null) line += "=" + toExprValue(varvalue.expr);
							case "ECall":
								// 调用方法
								var callname = toExprValue(expr.getParameters()[0].expr);
								line += "  " + callname;
							case "EBinop":
								// 赋值
								var varname = toExprValue(expr);
								line += "  " + varname;
							case "EIf":
								// If判断
								line += "  " + toExprValue(expr);
						}
						if (line != "  null") {
							maps.set(field.name, maps.get(field.name) + line + ";\n\r");
							shader += line + ";\n\r";
						}
					}
					shader += "\n\r}";
			}
		}
		// 创建new
		var pos = Context.currentPos();
		var fragment = "#pragma header \n void main(void){#pragma body\n" + maps.get("fragment") + "\n}";
		for (key => value in uniform) {
			fragment = value + fragment;
		}
		if (isDebug) {
			trace("uniform=" + uniform);
			trace("\n\rGLSL脚本：\n\r" + shader);
			trace("fragment=\n\r" + fragment);
		}
		var newField = null;
		for (f in fields) {
			if (f.name == "new") {
				newField = f;
				newField.meta = [
					{
						name: ":glFragmentSource",
						params: [macro $v{fragment}],
						pos: pos
					}
				];
				break;
			}
		}
		if (newField == null) {
			newField = {
				name: "new",
				doc: null,
				meta: [
					{
						name: ":glFragmentSource",
						params: [macro $v{fragment}],
						pos: pos
					}
				],
				access: [APublic],
				kind: FFun({
					args: [],
					ret: macro:Void,
					expr: macro {super();}
				}),
				pos: pos
			};
			fields.push(newField);
		}
		// processFields(fragment, "uniform", fields, pos);
		return fields;
	}

	/**
	 * 解析Expr的层级类型
	 * @return String
	 */
	public static function toExprType(expr:ExprDef):String {
		var ret = "#invalidType#";
		var type = expr.getName();
		lastType = null;
		switch (type) {
			case "ENew", "TPath":
				lastType = expr.getParameters()[0].name.toLowerCase();
				return lastType;
			case "EConst":
				expr = expr.getParameters()[0];
				lastType = expr.getName().substr(1).toLowerCase();
				return lastType;
			default:
				throw "无法使用" + type + "建立类型关系";
		}
		return ret;
	}

	/**
	 * 解析Expr的层级内容
	 * @param expr 
	 * @return String
	 */
	public static function toExprValue(expr:ExprDef, args:Array<Dynamic> = null):String {
		var ret = "#invalidValue#";
		var type = expr.getName();
		switch (type) {
			case "OpGt":
				return ">";
			case "OpLt":
				return "<";
			case "OpAssignOp":
				return "*=";
			case "OpAssign":
				return "=";
			case "OpAdd":
				return "+";
			case "OpDiv":
				return "/";
			case "OpMult":
				return "*";
			case "ECast":
				return toExprValue(expr.getParameters()[0].expr);
			case "EIf":
				var data = "";
				var ifcontent = toExprValue(expr.getParameters()[0].expr);
				var content = toExprValue(expr.getParameters()[1].expr);
				var elsecontent = expr.getParameters()[2];
				if (ifcontent != null) {
					data += (args != null ? args[0] : "if") + "(" + ifcontent + "){" + content + ";}";
				}
				if (elsecontent != null) {
					data += "else{" + toExprValue(elsecontent.expr, ["elseif"]) + ";}";
				}
				return data;
			case "EField":
				var value = toExprValue(expr.getParameters()[0].expr);
				if (uniform.exists(value))
					value = "u_" + value;
				if (value == "this")
					return expr.getParameters()[1];
				if (value.indexOf("gl_openfl") == 0)
					value = value.substr(3);
				var ret = value + "." + expr.getParameters()[1];
				if (ret == "super.fragment")
					return null;
				return ret;
			case "EBinop":
				var value1 = toExprValue(expr.getParameters()[1].expr);
				var value2 = toExprValue(expr.getParameters()[2].expr);
				var binop = toExprValue(expr.getParameters()[0]);
				return value1 + binop + value2;
			case "ECall":
				var callName = toExprValue(expr.getParameters()[0].expr);
				var args = expr.getParameters()[1];
				switch (callName) {
					case "asVec2", "asVec4", "asVec3":
						return toExprListValue(args);
				}
				return callName + "(" + toExprListValue(args) + ")";
			case "ENew":
				var ctype = toExprType(expr);
				return ctype + "(" + toExprListValue(expr.getParameters()[1]) + ")";
			case "EConst":
				expr = expr.getParameters()[0];
				var value:Dynamic = expr.getParameters()[0];
				if (Std.isOfType(value, String)) {
					if (uniform.exists(value))
						value = "u_" + value;
					if (value.indexOf("gl_openfl") == 0)
						value = value.substr(3);
					if(lastType == "float" && value.indexOf(".") == -1){
						value = value + ".";
					}
				}
				return value;
			default:
				throw "无法使用" + type + "建立值";
		}
		return ret;
	}

	/**
	 * [Description]
	 * @param Array<Dynamic> 
	 * @return String
	 */
	public static function toExprListValue(array:Array<Dynamic>):String {
		var ret:Array<String> = [];
		for (index => value in array) {
			ret.push(toExprValue(value.expr));
		}
		return ret.join(",");
	}
}
