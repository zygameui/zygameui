package zygame.local;

import haxe.macro.Context;
import haxe.macro.Expr.Field;

#if macro
class SaveObjectMacro {
	macro public static function build():Array<Field> {
		// 这是CEFloat类型兼容处理
		var fields = Context.getBuildFields();
		var cenames:Map<String, Bool> = [];
		var newfunc:Field;
		for (item in fields) {
			if (item.name == "new") {
				newfunc = item;
				continue;
			}
			switch item.kind {
				case FVar(t, e):
					switch t {
						case TPath(p):
							if (p.params.length > 0) switch p.params[0] {
								case TPType(t2):
									switch t2 {
										case TPath(p2):
											if (p2.name == "CEFloat") {
												cenames.set(item.name, true);
											}
										default:
									}
								default:
							}
						default:
					}
				default:
			}
		}
		if (newfunc != null) {
			switch newfunc.kind {
				case FFun(f):
					switch f.expr.expr {
						case EBlock(exprs):
							exprs.push(macro ce = $v{cenames});
						default:
					}
				default:
			}
		} else {
			// 需要一个新的new
			newfunc = {
				name: "new",
				kind: FFun({
					args: [],
					expr: macro {
						super();
						ce = $v{cenames};
					}
				}),
				pos: Context.currentPos()
			}
			fields.push(newfunc);
		}

		// 兼容setXXXValue、getXXXValue的接口
		for (item in fields) {
			switch item.kind {
				case FVar(t, e):
					switch t {
						case TPath(p):
							if (p.name == "SaveDynamicData") {
								var funcName = item.name.charAt(0).toUpperCase() + item.name.substr(1) + "Value";
								var retType = macro :Dynamic;
								if (p.params.length > 0) {
									switch p.params[0] {
										case TPType(t):
											retType = t;
										default:
									}
								}
								var attName = item.name;
								var getName = "get" + funcName;
								var setFunc:Field = {
									name: "set" + funcName,
									pos: Context.currentPos(),
									access: [APublic],
									kind: FFun({
										args: [
											{
												name: "key",
												type: macro :String
											},
											{
												name: "value",
												type: retType
											}
										],
										expr: macro {
											// var cur = this.$getName(key);
											// if(cur != value){
											this.$attName.fieldWrite(key, value);
											// }
										}
									})
								};
								var getFunc:Field = {
									name: "get" + funcName,
									pos: Context.currentPos(),
									access: [APublic],
									kind: FFun({
										args: [
											{
												name: "key",
												type: macro :String
											},
											{
												name: "defaultValue",
												type: retType,
												opt: true
											}
										],
										ret: retType,
										expr: macro {
											var value:Any = this.$attName.fieldRead(key);
											return value == null ? defaultValue : value;
										}
									})
								};
								fields.push(setFunc);
								fields.push(getFunc);
							}
						default:
					}
				default:
			}
		}

		return fields;
	}
}
#end
