package zygame.macro;

import haxe.macro.Compiler;
import haxe.macro.Context;

/**
 * 垃圾代码
 */
class RubbishCode {
	public static var random:String = "QWERTYUIOPLKJHGFDSAZXCVBNM";

	macro public static function build(codeCount:Int, tag:String = null):Dynamic {
		for (i in 0...codeCount) {
			var name = random.charAt(Std.random(random.length))
				+ random.charAt(Std.random(random.length))
				+ random.charAt(Std.random(random.length))
				+ i;
			if (tag != null)
				name = tag + name;
			Compiler.keep(name);
			var c = macro class $name {
				public var value:Int;
				public var value1:Int;
				public var value2:Int;
				public var value3:Int;
				public var value4:Int;
				public var value5:Int;
				public var value6:Int;

				public function new() {
					value = $v{Std.random(999999)};
					value1 = $v{Std.random(999999)};
					value2 = $v{Std.random(999999)};
					value3 = $v{Std.random(999999)};
					value4 = $v{Std.random(999999)};
					value5 = $v{Std.random(999999)};
					value6 = $v{Std.random(999999)};
				}
			};
			Context.defineType(c);
		}
		return macro 0;
	}
}
