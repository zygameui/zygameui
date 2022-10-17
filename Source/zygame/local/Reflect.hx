package zygame.local;

import zygame.local.SaveDynamicData.SaveDynamicDataContent;
import Reflect in R;

class Reflect {
	public inline static function hasField(o:Dynamic, field:String):Bool {
		if (o is SaveDynamicDataContent) {
			return R.hasField(cast(o, SaveDynamicDataContent<Dynamic>).data, field);
		}
		return R.hasField(o, field);
	}

	public static function field(o:Dynamic, field:String):Dynamic {
		if (o is SaveDynamicDataContent) {
			return R.field(cast(o, SaveDynamicDataContent<Dynamic>).data, field);
		}
		return R.field(o, field);
	}

	public inline static function setField(o:Dynamic, field:String, value:Dynamic):Void {
		if (o is SaveDynamicDataContent) {
			return R.setField(cast(o, SaveDynamicDataContent<Dynamic>).data, field, value);
		}
		return R.setField(o, field, value);
	}

	public static function getProperty(o:Dynamic, field:String):Dynamic {
		if (field == null)
			return null;
		if (o is SaveDynamicDataContent) {
			return R.getProperty(cast(o, SaveDynamicDataContent<Dynamic>).data, field);
		}
		return R.getProperty(o, field);
	}

	public static function setProperty(o:Dynamic, field:String, value:Dynamic):Void {
		if (field == null)
			return;
		if (o is SaveDynamicDataContent) {
			cast(o, SaveDynamicDataContent<Dynamic>).setValue(field, value);
			return;
		}
		return R.setProperty(o, field, value);
	}

	public inline static function callMethod(o:Dynamic, func:haxe.Constraints.Function, args:Array<Dynamic>):Dynamic {
		return R.callMethod(o, func, args);
	}

	public static function fields(o:Dynamic):Array<String> {
		if (o is SaveDynamicDataContent) {
			return R.fields(cast(o, SaveDynamicDataContent<Dynamic>).data);
		}
		return R.fields(o);
	}

	public static function isFunction(f:Dynamic):Bool {
		return R.isFunction(f);
	}

	public static function compare<T>(a:T, b:T):Int {
		return R.compare(a, b);
	}

	public static function compareMethods(f1:Dynamic, f2:Dynamic):Bool {
		return R.compareMethods(f1, f2);
	}

	public static function isObject(v:Dynamic):Bool {
		return !(v is String || v is Float);
	}

	public static function isEnumValue(v:Dynamic):Bool {
		return R.isEnumValue(v);
	}

	public static function deleteField(o:Dynamic, field:String):Bool {
		if (o is SaveDynamicDataContent) {
			return R.deleteField(cast(o, SaveDynamicDataContent<Dynamic>).data, field);
		}
		return R.deleteField(o, field);
	}
}
