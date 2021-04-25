package zygame.particles.util;

class DynamicTools {
    public static function asDynamic(value : Dynamic) : DynamicExt {
        if (value == null) {
            return {};
        } else {
            return value;
        }
    }

    public static function asArray(value : Dynamic) : Array<DynamicExt> {
        if (Std.isOfType(value, Array)) {
            return value;
        } else {
            return new Array<Dynamic>();
        }
    }

    public static function asInt(value : Dynamic, def : Int = 0) : Int {
        if (Std.isOfType(value, Int)) {
            return value;
        } else if (Std.isOfType(value, Float)) {
            return Std.int(value);
        } else {
            return def;
        }
    }

    public static function asNullInt(value : Dynamic) : Null<Int> {
        if (Std.isOfType(value, Int)) {
            return value;
        } else if (Std.isOfType(value, Float)) {
            return Std.int(value);
        } else {
            return null;
        }
    }

    public static function asFloat(value : Dynamic, def : Float = 0.0) : Float {
        if (Std.isOfType(value, Float) || Std.isOfType(value, Int)) {
            return value;
        } else {
            return def;
        }
    }

    public static function asNullFloat(value : Dynamic) : Null<Float> {
        if (Std.isOfType(value, Float) || Std.isOfType(value, Int)) {
            return value;
        } else {
            return null;
        }
    }

    public static function asBool(value : Dynamic, def : Bool = false) : Bool {
        if (Std.isOfType(value, Bool)) {
            return value;
        } else {
            return def;
        }
    }

    public static function asString(value : Dynamic, def : String = "") : String {
        if (value == null) {
            return def;
        } else {
            return Std.string(value);
        }
    }
}
