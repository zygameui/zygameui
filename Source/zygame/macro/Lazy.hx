package zygame.macro;

import haxe.macro.ExprTools;
import haxe.macro.Expr.FieldType;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

class Lazy {
	macro public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		var len = fields.length;
		while (len-- > 0) {
			var item = fields[len];
			var array = item.meta.filter((data) -> data.name == ":lazy");
			if (array.length > 0) {
				// 改造成异步调用
				switch (item.kind) {
					case FVar(t, e):
						// fields.remove(item);
						// 构造一个get/set变量
						var prop:FieldType = FieldType.FProp("get", "never", t);
						item.kind = prop;
                        // trace(ExprTools.toString(e));
						var getfunc:Field = {
							name: "get_" + item.name,
							meta: [],
							access: [APrivate, AStatic],
							kind: FFun({
								args: [],
								ret: t,
								expr: macro return ${e}
							}),
							pos: Context.currentPos()
						};
						fields.push(getfunc);
					default:
						// 其他类型忽略
				}
			}
		}
		return fields;
	}
}
