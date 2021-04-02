package zygame.script;

import zygame.components.ZBuilder;
import zygame.components.ZBuilder.Builder;
#if hscript
import hscript.Expr;
import hscript.Parser;
#end
import zygame.utils.Lib;

/**
 * 脚本解析器
 */
@:keep
class ZHaxe {
	private var _script:String;

	#if hscript
	private var parser:Parser;
	private var program:Expr;

	public var interp:ZInterp;
	#end

	/**
	 * 传参参数名列表，可以在调用call方法将传输传入，最大参数名目前支持5位。
	 */
	public var argsName:Array<String> = [];

	/**
	 * 返回一个能够直接访问的参数，最大支持5位参数。
	 */
	public var value(get, never):Dynamic;

	private function get_value():Dynamic {
		switch (argsName.length) {
			case 0:
				return call;
			case 1:
				return (a) -> call([a]);
			case 2:
				return (a, b) -> call([a, b]);
			case 3:
				return (a, b, c) -> call([a, b, c]);
			case 4:
				return (a, b, c, d) -> call([a, b, c, d]);
			case 5:
				return (a, b, c, d, e) -> call([a, b, c, d, e]);
		}
		throw "ZHaxe传参仅支持5位参数以内。";
	}

	/**
	 * Builder脚本解析器
	 * @param script hscript脚本
	 */
	public function new(script:String):Void {
		_script = parserScript(script);
		#if hscript
		parser = new Parser();
		program = parser.parseString(_script);
		interp = new ZInterp();
		interp.variables.set("Std", Std);
		interp.variables.set("Lib", Lib);
		#else
		throw "You need include `hscript` haxelib.";
		#end
	}

	/**
	 * 解析映射，部分文件使用xml编写时，可使用qt(>)、egt(>=)、lt(<)、elt(<=)、and(&&)、or(||)来代替。
	 * @param script
	 * @return String
	 */
	private function parserScript(script:String):String {
		script = StringTools.replace(script, " gt ", " > ");
		script = StringTools.replace(script, " egt ", " >= ");
		script = StringTools.replace(script, " lt ", " < ");
		script = StringTools.replace(script, " elt ", " <= ");
		script = StringTools.replace(script, " and ", " && ");
		script = StringTools.replace(script, " or ", " || ");
		return script;
	}

	/**
	 * 绑定创建器的对象
	 * @param build 构造器
	 */
	public function bindBuilder(builder:Builder):Void {
		#if hscript
		for (key => value in builder.ids) {
			if (Std.is(value, ZHaxe))
				interp.variables.set(key, cast(value, ZHaxe).value);
			else
				interp.variables.set(key, value);
		}
		interp.variables.set("this", builder.display);
		// 绑定全局对象
		for (key => value in ZBuilder.builderDefine) {
			#if hscript
			interp.variables.set(key, value);
			#end
		}
		#end
	}

	/**
	 * 调用ZHaxe命令
	 */
	public function call(args:Array<Dynamic> = null):Dynamic {
		if ((args == null && argsName.length > 0) || (args != null && args.length != argsName.length)) {
			throw "ZHaxe args count is not match:"
				+ argsName
				+ " not match "
				+ args
				+ "\nSource:\n"
				+ _script
				+ ("\nargs.length=" + (args != null ? args.length : 0) + "  argsName.length=" + argsName.length);
		}
		#if hscript
		// 传参定义
		for (i in 0...argsName.length) {
			interp.variables.set(argsName[i], args[i]);
		}
		return interp.execute(program);
		#else
		return null;
		#end
	}
}

/**
 * 整数
 */
@:keep
class ZInt {
	public function new(v2:Int) {
		trace("ZInt",v2);
		this.value = v2;
	}

	public var value:Int = 0;
}

/**
 * 浮点
 */
@:keep
class ZFloat {
	public var value:Float = 0;

	public function new(value:Float) {
		this.value = value;
	}
}

/**
 * 布尔值
 */
@:keep
class ZBool {
	public var value:Bool = false;

	public function new(value:Bool) {
		this.value = value;
	}
}

/**
 * 字符串
 */
@:keep
class ZString {
	public var value:String = null;

	public function new(value:String) {
		this.value = value;
	}
}

/**
 * 数组
 */
@:keep
class ZArray {
	public var value:Array<Dynamic> = [];

	public function new() {}
}

@:keep
class ZObject {
	public var value:Dynamic = null;

	public function new(value:Dynamic) {
		this.value = value;
	}
}
