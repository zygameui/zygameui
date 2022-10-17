package zygame.macro;

import haxe.macro.Expr;
import haxe.macro.Expr.Function;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

#if macro
/**
 * Debug宏，可以在指定的方法中，添加trace(1)，作为定位，在CPP中使用较为方便，有时候类型错误不会标记崩溃位置，因此可以使用该宏进行大概的定位
 */
class DebugMacro {
	macro public static function build(allDebug:Bool = false):Array<Field> {
		var array = Context.getBuildFields();
		var localClass = Context.getLocalClass();
		if (localClass == null)
			return array;
		var cname = localClass.get().name;
		if (cname.indexOf("_Fields_") != -1) {
			return array;
		}
		trace("处理", cname);
		for (item in array) {
			if (item.access.indexOf(AInline) != -1)
				continue;
			var meta = item.meta.filter((m) -> m.name == ":debug");
			if (allDebug || meta.length > 0) {
				// 植入trace(1)
				switch item.kind {
					case FFun(f):
						if (item.name.indexOf("get_") == -1 && item.name.indexOf("set_") == -1)
							addTrace1(cname + "." + item.name, f.expr);
					default:
				}
			}
		}
		return array;
	}

	public static function addTrace1(name:String, expr:Expr):Void {
		if (expr == null)
			return;
		switch expr.expr {
			case EConst(c):
			case EArray(e1, e2):
			case EBinop(op, e1, e2):
			case EField(e, field):
			case EParenthesis(e):
			case EObjectDecl(fields):
			case EArrayDecl(values):
			case ECall(e, params):
			case ENew(t, params):
			case EUnop(op, postFix, e):
			case EVars(vars):
			case EFunction(kind, f):
			case EBlock(exprs):
				var len = exprs.length;
				while (len > 0) {
					len--;
					var trace1 = macro trace($v{name} + ":" + $v{len});
					exprs.insert(len, trace1);
				}
			case EFor(it, expr):
			case EIf(econd, eif, eelse):
			case EWhile(econd, e, normalWhile):
			case ESwitch(e, cases, edef):
			case ETry(e, catches):
			case EReturn(e):
			case EBreak:
			case EContinue:
			case EUntyped(e):
			case EThrow(e):
			case ECast(e, t):
			case EDisplay(e, displayKind):
			case EDisplayNew(t):
			case ETernary(econd, eif, eelse):
			case ECheckType(e, t):
			case EMeta(s, e):
			case EIs(e, t):
		}
	}
}
#end
