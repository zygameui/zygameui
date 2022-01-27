package zygame.utils;

/**
 * 可以防止内存修改的CEFloat值
 */
class CEFloat {
	private var _value:String = null;

	private var _value2:Float = 0;

	public function new(value:Float = 0) {
		this.value = value;
	}

	public var value(get, set):Float;

	private function set_value(f:Float):Float {
		_value2 = f;
		_value = Lib.ceEncode(f);
		return f;
	}

	private function get_value():Float {
		if (_value == null)
			return 0;
		else
			return Lib.ceDecode(_value);
	}
}
