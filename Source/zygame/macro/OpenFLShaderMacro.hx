package zygame.macro;

import haxe.macro.ExprTools;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * 解析OpenFLShader的宏处理
 */
class OpenFLShaderMacro {
	macro public static function buildShader():Array<Field> {
		var fields = Context.getBuildFields();
		var shader = "\n\r";
		var maps:Map<String, String> = [];
		for (field in fields) {
			trace(field.kind.getName());
			switch (field.kind.getName()) {
				case "FVar":
					// 变量定义
					var type:ComplexType = cast field.kind.getParameters()[0];
					var value = cast field.kind.getParameters()[1];
					var c = type == null ? toExprType(value.expr) : type.getParameters()[0].name.toLowerCase();
					if (value == null) {
						shader += c + " " + field.name + ";\n\r";
					} else {
						shader += c + " " + field.name + "=" + toExprValue(value.expr) + ";\n\r";
					}
				case "FFun":
					// 方法解析
					maps.set(field.name, "");
					shader += "\n\rvoid " + field.name + "(){\n\r";
					var func:ExprDef = cast field.kind.getParameters()[0].expr.expr;
					var array:Array<Dynamic> = func.getParameters()[0];
					for (index => value in array) {
						var expr:ExprDef = cast value.expr;
						trace("方法解析：", expr.getName());
						var line:String = "";
						switch (expr.getName()) {
							case "EField":
							// 已定义对象赋值
							case "EVars":
								// 定义局部变量
								var vars = expr.getParameters()[0];
								var varvalue = vars[0].expr;
								line += "  " + (vars[0].type != null ? toExprType(vars[0].type) : "???") + " " + vars[0].name;
								trace(varvalue);
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
		trace("\n\rGLSL脚本：\n\r" + shader);
		// 创建new
		var pos = Context.currentPos();
		var fragment = "\n #pragma header \n void main(void){#pragma body\n" + maps.get("fragment") + "\n}";
		trace("fragment=", fragment);
		var newField = {
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
		return fields;
	}

	/**
	 * 解析Expr的层级类型
	 * @return String
	 */
	public static function toExprType(expr:ExprDef):String {
		var ret = "#invalidType#";
		var type = expr.getName();
		switch (type) {
			case "ENew", "TPath":
				return expr.getParameters()[0].name.toLowerCase();
			case "EConst":
				expr = expr.getParameters()[0];
				return expr.getName().substr(1).toLowerCase();
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
				return callName + "(" + toExprListValue(args) + ")";
			case "ENew":
				var ctype = toExprType(expr);
				return ctype + "(" + toExprListValue(expr.getParameters()[1]) + ")";
			case "EConst":
				expr = expr.getParameters()[0];
				var value:Dynamic = expr.getParameters()[0];
				if (Std.isOfType(value, String)) {
					if (value.indexOf("gl_openfl") == 0)
						value = value.substr(3);
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
			trace(value.expr);
			ret.push(toExprValue(value.expr));
		}
		return ret.join(",");
	}
}
