package zygame.macro;

import haxe.macro.MacroStringTools;
import haxe.macro.ExprTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

using StringTools;

#if macro
/**
 * 拆解?a.?b的做法
 */
class NullMacro {
	/**
	 * 宏构造
	 * @return Array<Field>
	 */
	macro public static function build():Array<Field> {
		var array = Context.getBuildFields();
		for (item in array) {
			switch item.kind {
				case FVar(t, e):
				case FFun(f):
					// 处理方法
					parserFunc(f.expr);
				case FProp(get, set, t, e):
			}
		}
		return array;
	}

	/**
	 * 循环解析
	 * @param expr 
	 */
	private static function parserFunc(expr:Expr):Void {
		switch expr.expr {
			case EBlock(exprs):
				for (value in exprs) {
					parserFunc(value);
				}
			case EMeta(s, e):
				// 仅处理@null元数据
				switch (s.name) {
					case "null":
						// 空判处理
						var newexpr = parserNullFunc(e);
						expr.expr = newexpr.expr;
				}
			default:
		}
	}

	/**
	 * 处理@null元数据，仅支持a.a.a.a.b() a.a.a.a.b = 2的格式。
	 * @param expr 
	 * @return Expr
	 */
	private static function parserNullFunc(expr:Expr):Expr {
		var code = ExprTools.toString(expr);
		var keys = code.split(".");
		var endKey = keys[keys.length - 1];
		endKey = endKey.replace(" ", "");
		if (endKey.indexOf("(") != -1) {
			// 方法兼容
			keys[keys.length - 1] = endKey.substr(0, endKey.indexOf("("));
		} else {
			if (endKey.indexOf("=") != -1) {
				// 赋值不关心最后一个值
				keys.pop();
			}
		}
		var keyscode = keys.join(".");
		var params = [keys.shift()];
		var startKey = MacroStringTools.toFieldExpr(params);
		var blockExpr:Expr = {
			expr: null,
			pos: Context.currentPos()
		}
		// 改良版本
		var func:Expr = macro {
			if ($startKey != null) {
				$blockExpr;
			}
		};
		// 改良版本
		for (k in keys) {
			params.push(k);
			startKey = MacroStringTools.toFieldExpr(params);
			var nextExpr:Expr = {
				expr: null,
				pos: Context.currentPos()
			}
			var newfunc:Expr = macro {
				if ($startKey != null) {
					$nextExpr;
				}
			};
			blockExpr.expr = newfunc.expr;
			blockExpr = nextExpr;
		}
		blockExpr.expr = expr.expr;
		return {
			expr: func.expr,
			pos: Context.currentPos()
		};
	}
}
#end
