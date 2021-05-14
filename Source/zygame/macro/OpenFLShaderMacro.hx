package zygame.macro;

import haxe.macro.ExprTools;
import haxe.macro.Expr;
import haxe.macro.Context;

class OpenFLShaderMacro {
	macro public static function buildShader():Array<Field> {
		var fields = Context.getBuildFields();
		var shader = "\n\r";
		for (field in fields) {
			trace(field);
			switch (field.kind.getName()) {
				case "FVar":
					// 变量定义
					var type:ComplexType = cast field.kind.getParameters()[0];
					var c = type.getParameters()[0].name;
					shader += c.toLowerCase() + " " + field.name + ";";
				case "FFun":
					// 方法解析
					shader += "\n\rvoid " + field.name + "(){\n\r";
					var func:ExprDef = cast field.kind.getParameters()[0].expr.expr;
					var array:Array<Dynamic> = func.getParameters()[0];
					for (index => value in array) {
						var expr:ExprDef = cast value.expr;
						trace("方法解析：", expr.getName());
						switch (expr.getName()) {
							case "EField":
							// 已定义对象赋值

							case "EVars":
								// 定义局部变量
								var vars:Array<Dynamic> = expr.getParameters();
								for (index => value in vars) {
									trace("属性定义", value);
									var array = cast(value, Array<Dynamic>);
									for (index2 => value2 in array) {
										shader += "  " + toGLSLType(value2.type, value2.expr.expr) + value2.name + "="
											+ toGLSLValue(value2.type, value2.expr.expr) + ";\n\r";
									}
								}
							case "ECall":
								// 调用方法
								var args:Array<Dynamic> = cast expr.getParameters()[1];
								var expr:ExprDef = cast expr.getParameters()[0].expr;
								var pos:Constant = cast expr.getParameters()[0];
								shader += "  " + pos.getParameters()[0] + "(" + toArgs(args) + ");\n\r";
							case "EBinop":
								// 赋值
								trace(expr.getParameters());
								var binop = expr.getParameters()[0];
								shader += "  " + toGLSLEBinop(binop, expr.getParameters()[1].expr, expr.getParameters()[2].expr) + ";\n\r";
						}
					}
					shader += "\n\r}";
			}
		}
		trace("\n\rGLSL脚本：\n\r" + shader);
		return fields;
	}

	public static function toGLSLEBinop(binop:Dynamic, expr:ExprDef, value:ExprDef):String {
		trace("toGLSLField", expr, "=", value);
		if (binop == OpAssign) {
			binop = "=";
		}
		if (expr.getName() == "EField") {
			var f = expr.getParameters()[1];
			expr = expr.getParameters()[0].expr;
			expr = expr.getParameters()[0];
			expr = expr.getParameters()[0];
			return expr + "." + f + binop + toGLSLValue(null, value);
		} else if (expr.getName() == "EConst") {
			expr = expr.getParameters()[0];
			expr = expr.getParameters()[0];
			return expr + binop + toGLSLValue(null, value);
		}
		return "null";
	}

	public static function toGLSLValue(ctype:ComplexType, expr:Dynamic):String {
		if (expr == null)
			return "null";
		var type:String = ctype == null ? null : ctype.getParameters()[0].name;
		var def:ExprDef = cast expr;
		var valueType = def.getName();
		trace("valueType=", valueType);
		if (valueType == "ECall") {
			var args:Array<Dynamic> = cast def.getParameters()[1];
			var def:ExprDef = cast def.getParameters()[0].expr;
			var pos:Constant = cast def.getParameters()[0];
			trace("args = ",args);
			return pos.getParameters()[0] + "(" + toArgs(args) + ")";
		} else if (valueType == "EField") {
			var f = def.getParameters()[1];
			def = def.getParameters()[0].expr;
			def = def.getParameters()[0];
			def = def.getParameters()[0];
			return def + "." + f;
		} else if (valueType == "ENew") {
			// 新建变量，一般由类型组成
			var c:String = def.getParameters()[0].name;
			var args:Array<Dynamic> = def.getParameters()[1];
			return c.toLowerCase() + "(" + toArgs(args) + ")";
		} else {
			def = def.getParameters()[0];
			var value:String = def.getParameters()[0];
			switch (type) {
				case "Float":
					if (value.indexOf(".") == -1)
						value += ".";
			}
			return value;
		}
	}

	public static function toGLSLType(ctype:ComplexType, expr:Dynamic):String {
		if (ctype != null) {
			return cast(ctype.getParameters()[0].name, String).toLowerCase() + " ";
		}
		var type = null;
		var def:ExprDef = cast expr;
		var data:Dynamic = def.getParameters()[0];
		if (Std.isOfType(data, Constant)) {
			type = cast(data, Constant).getName();
		} else {
			type = data.name;
		}

		switch (type) {
			case "CString":
				throw "GLSL中不允许使用String类型";
			case "CInt":
				type = "int";
			case "CFloat":
				type = "float";
		}
		return type + " ";
	}

	public static function toArgs(data:Array<Dynamic>):String {
		var newdata = [];
		for (index => value in data) {
			var expr:ExprDef = cast(value.expr, ExprDef).getParameters()[0];
			trace("解析参数：", expr.getName(), expr.getParameters()[0]);
			switch (expr.getName()) {
				case "CInt":
					newdata[index] = expr.getParameters()[0];
			}
		}
		return newdata.join(",");
	}
}
