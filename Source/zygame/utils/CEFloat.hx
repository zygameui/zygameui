package zygame.utils;

/**
 * 一种防止内存修改器进行修改的简易方案
 */
abstract CEFloat(CEData) to CEData from CEData {
	/**
	 * 构造函数
	 * @param value 
	 */
	inline public function new(value:Float) {
		this = new CEData(value);
	}

	/**
	 * 接收Float值
	 * @param s 
	 */
	@:from
	static public function fromFloat(s:Float) {
		return new CEFloat(s);
	}

	/**
	 * 接收String值
	 * @param s 
	 */
	@:from
	static public function fromString(s:String) {
		return new CEFloat(Std.parseFloat(s));
	}

	/**
	 * 转为Float
	 * @return Float
	 */
	@:to public function toFloat():Float {
		return this.value;
	}

	/**
	 * 转为Int
	 * @return Int
	 */
	@:to public function toInt():Int {
		return Std.int(this.value);
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toString():String {
		return this.toString();
	}

	/**
	 * 加法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A + B) public function add(value:Float):Float {
		return this.value + value;
	}

	/**
	 * 减法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A - B) public function jian(value:Float):Float {
		return this.value - value;
	}

	/**
	 * 乘法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A * B) public function mul(value:Float):Float {
		return this.value * value;
	}

	/**
	 * 除法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A / B) public function div(value:Float):Float {
		return this.value / value;
	}
}

/**
 * 一种防止内存修改器进行修改的简易方案
 */
class CEData {
	/**
	 * 签名值
	 */
	public var sign:String = null;

	public function new(value:Float) {
		this.value = value;
	}

	public var value(get, set):Float;

	public var values:Array<String> = [];

	public function toString():String {
		return Std.string(value);
	}

	function get_value():Float {
		if (sign != values.join(""))
			throw "游戏内存被修改";
		return Std.parseFloat(sign);
	}

	function set_value(value:Float):Float {
		sign = Std.string(value);
		values = sign.split("");
		return value;
	}
}
