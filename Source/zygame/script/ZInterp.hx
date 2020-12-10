package zygame.script;

import hscript.Expr;
import zygame.script.ZHaxe.ZFloat;
import zygame.script.ZHaxe.ZInt;
import zygame.script.ZHaxe.ZBool;
import zygame.script.ZHaxe.ZString;
import zygame.script.ZHaxe.ZObject;
import zygame.mini.MiniUtils;
import zygame.mini.MiniEngineAssets;
import zygame.components.ZBuilder.Builder;
import zygame.mini.MiniExtend;
import hscript.Interp;

/**
 * Interp的扩展版本，用于实现mini内置热更新引擎框架访问实现。一般不需要主动生成，由ZHaxe主动生成使用。
 */
class ZInterp extends Interp {
	/**
	 * 通过MiniEngine创建时该值才会生效，可查找映射在资源中的类型对象。
	 */
	public var miniAssets:MiniEngineAssets;

	override function get(o:Dynamic, f:String):Dynamic {
		if (Std.is(o, MiniExtend)) {
			var c:MiniExtend = cast o;
			if (c.baseBuilder != null && c.baseBuilder.ids.exists(f))
				return Reflect.getProperty(c.baseBuilder.ids.get(f), "value");
		}
		return super.get(o, f);
	}

	override function set(o:Dynamic, f:String, v:Dynamic):Dynamic {
		#if cpp
		var item:Dynamic = v;
		if (Std.is(item, String)) {
			var utf = "";
			for (i in 0...cast(item, String).length) {
				utf += cast(item, String).charAt(i);
			}
			v = utf;
		}
		#end
		if (Std.is(o, MiniExtend)) {
			var c:MiniExtend = cast o;
			if (c.baseBuilder != null && c.baseBuilder.ids.exists(f)) {
				Reflect.setProperty(c.baseBuilder.ids.get(f), "value", v);
				return v;
			}
		}
		return super.set(o, f, v);
	}

	override function fcall(o:Dynamic, f:String, args:Array<Dynamic>):Dynamic {
		#if cpp
		for (i2 in 0...args.length) {
			var item:Dynamic = args[i2];
			if (Std.is(item, String)) {
				var utf = "";
				for (i in 0...cast(item, String).length) {
					utf += cast(item, String).charAt(i);
				}
				args[i2] = utf;
			}
		}
		#end
		if (Std.is(o, MiniExtend)) {
			var c:MiniExtend = cast o;
			if (c.baseBuilder != null && c.baseBuilder.ids.exists(f)) {
				return this.call(o, Reflect.getProperty(c.baseBuilder.ids.get(f), "value"), args);
			} else
				return super.fcall(o, f, args);
		} else if (Std.is(o, ZHaxe)) {
			return Reflect.callMethod(o, cast(o, ZHaxe).value, args);
		} else {
			return super.fcall(o, f, args);
		}
	}

	override function call(o:Dynamic, f:Dynamic, args:Array<Dynamic>):Dynamic {
		#if cpp
		for (i2 in 0...args.length) {
			var item:Dynamic = args[i2];
			if (Std.is(item, String)) {
				var utf = "";
				for (i in 0...cast(item, String).length) {
					utf += cast(item, String).charAt(i);
				}
				args[i2] = utf;
			}
		}
		#end
		return super.call(o, f, args);
	}

	override function cnew(cl:String, args:Array<Dynamic>):Dynamic {
		#if cpp
		for (i2 in 0...args.length) {
			var item:Dynamic = args[i2];
			if (Std.is(item, String)) {
				var utf = "";
				for (i in 0...cast(item, String).length) {
					utf += cast(item, String).charAt(i);
				}
				args[i2] = utf;
			}
		}
		#end
		if (miniAssets != null && miniAssets.getXml(cl) != null) {
			return MiniUtils.createTypeObject(miniAssets, cl, args);
		}
		return super.cnew(cl, args);
	}

	override public function execute(expr:Expr):Dynamic {
		return super.execute(expr);
	}
}
