package zygame.local;

import zygame.utils.CEFloat;

/**
 * 动态类型抽象类
 */
abstract SaveFloatData(SaveFloatDataContent) to SaveFloatDataContent from SaveFloatDataContent {
	public function new(value:Float = 0) {
		this = new SaveFloatDataContent();
		this.changed = true;
		this.data = value;
	}

	@:from static public function fromFloat(f:Float):SaveFloatData {
		var newValue = new SaveFloatData(f);
		return newValue;
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toFloat():Float {
		return this.data.toFloat();
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toDynamic():Dynamic {
		return this.data;
	}

	/**
	 * 加法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A + B) public function add(value:Float):Float {
		return this.data + value;
	}

	/**
	 * 减法运算
	 * @param value 
	 * @return Float
	 */
	@:op(A - B) public function jian(value:Float):Float {
		return this.data - value;
	}

	@:commutative @:op(B - A) public function jian2(value:Float):Float {
		return value - this.data;
	}

	/**
	 * 乘法运算
	 * @param value 
	 * @return Float
	 */
	@:commutative @:op(A * B) public function mul(value:Float):Float {
		return this.data * value;
	}

	/**
	 * 除法运算
	 * @param value 
	 * @return Float
	 */
	@:op(A / B) public function div(value:Float):Float {
		return this.data / value;
	}

	@:commutative @:op(B / A) public function div2(value:Float):Float {
		return value / this.data;
	}

	@:op(++A) public function pre():Float {
		return this.data++;
	}

	@:op(A++) public function post():Float {
		return this.data++;
	}

	@:op(--A) public function pre2():Float {
		return this.data--;
	}

	@:op(A--) public function post2():Float {
		return this.data--;
	}

	@:op(A > B) static function dy(a:SaveFloatData, b:SaveFloatData):Bool {
		return a.toFloat() > b.toFloat();
	};

	@:op(A < B) static function xy(a:SaveFloatData, b:SaveFloatData):Bool {
		return a.toFloat() < b.toFloat();
	};

	@:op(A >= B) static function dydy(a:SaveFloatData, b:SaveFloatData):Bool {
		return a.toFloat() >= b.toFloat();
	};

	@:op(A <= B) static function xydy(a:SaveFloatData, b:SaveFloatData):Bool {
		return a.toFloat() <= b.toFloat();
	};

	@:op(A == B) static function xd(a:SaveFloatData, b:SaveFloatData):Bool {
		return a.toFloat() == b.toFloat();
	};
}

class SaveFloatDataContent extends SaveDynamicDataBaseContent {
	/**
	 * 数据储存
	 */
	public var data:CEFloat = 0;

	override function flush(key:String, changeData:Dynamic) {
		super.flush(key, changeData);
		if (changed) {
			Reflect.setProperty(changeData, key, data.toFloat());
			changed = false;
		}
	}

	override function getData(key:String, data:Dynamic) {
		Reflect.setProperty(data, key, this.data.toFloat());
	}
}
