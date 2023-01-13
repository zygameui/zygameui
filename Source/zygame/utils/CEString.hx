package zygame.utils;

import haxe.io.Bytes;

/**
 * 一种防止内存修改器进行修改的简易方案
 */
abstract CEString(CEStringData) to CEStringData from CEStringData {
	/**
	 * 构造函数
	 * @param value 
	 */
	inline public function new(value:String) {
		this = new CEStringData(value);
	}

	/**
	 * 接收String值
	 * @param s 
	 */
	@:from
	static public function fromString(s:String) {
		if (s == null)
			return null;
		return new CEString(s);
	}

	/**
	 * 接收String值
	 * @param s 
	 */
	@:from
	static public function fromDynamic(s:Dynamic) {
		if (s == null)
			return null;
		return new CEString(cast s);
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toString():String {
		if (this == null)
			return null;
		return this.toString();
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toDynamic():Dynamic {
		if (this == null)
			return null;
		return this.toString();
	}

	@:op(A != B) static function bdy(a:CEString, b:CEString):Bool {
		return a.toString() != b.toString();
	};

	@:op(A == B) static function xd(a:CEString, b:CEString):Bool {
		return a.toString() == b.toString();
	};
}

/**
 * 一种防止内存修改器进行修改的简易方案
 * 使用`cebytes`可使用该模式，所有的数值都需要经过加密解密得到
 */
class CEStringData {
	/**
	 * 签名值
	 */
	public var bytes:Bytes = null;

	private var random:Int = 0;

	public function new(value:String) {
		this.value = value;
	}

	public var value(get, set):String;

	public function toString():String {
		return value;
	}

	function get_value():String {
		if (bytes == null)
			return null;
		var newBytes = Bytes.alloc(bytes.length);
		for (i in 0...bytes.length) {
			newBytes.set(i, bytes.get(i) ^ random);
		}
		return newBytes.toString();
	}

	function set_value(value:String):String {
		if (value == null) {
			bytes = null;
			return value;
		}
		random = Std.random(255);
		bytes = Bytes.ofString(Std.string(value));
		for (i in 0...bytes.length) {
			bytes.set(i, bytes.get(i) ^ random);
		}
		return value;
	}
}
