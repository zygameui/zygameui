package zygame.local;

import zygame.utils.CEFloat.CEData;

/**
 * 数组抽象类
 */
@:runtimeValue abstract SaveArrayData<T>(SaveArrayDataContent<T>) to SaveArrayDataContent<T> from SaveArrayDataContent<T> {
	public var length(get, never):Int;

	private function get_length():Int {
		return this.data.length;
	}

	public function new(data:Array<Dynamic> = null) {
		this = new SaveArrayDataContent();
		for (index => value in data) {
			this.setValue(index, value);
		}
	}

	@:arrayAccess
	public inline function get(key:Int):T {
		return this.getValue(key);
	}

	@:arrayAccess
	public inline function arrayWrite(k:Int, v:T):T {
		this.setValue(k, v);
		return v;
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toString():String {
		return Std.string(this.data);
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toDynamic():Array<T> {
		return this.data;
	}

	public function keyValueIterator(){
		return this.data.keyValueIterator();
	}

	@:from public static function fromDynamic<T>(data:Array<T>):SaveArrayData<T> {
		var data = new SaveArrayData(data);
		return data;
	}

	public function push(value:T):Void {
		var len = this.data.length;
		this.setValue(len, value);
	}
}

class SaveArrayDataContent<T> extends SaveDynamicDataBaseContent {
	/**
	 * 发生变化的值
	 */
	public var changedValues:Map<Int, T> = [];

	/**
	 * 数据储存
	 */
	public var data:Array<T> = [];

	public function getValue(key:Int):T {
		return this.data[key];
	}

	public function setValue(key:Int, value:T):T {
		this.changed = true;
		this.changedValues.set(key, value);
		this.data[key] = value;
		return value;
	}

	override function flush(key:String, changeData:Dynamic) {
		super.flush(key, changeData);
		if (changed) {
			changed = false;
			var newdata:Dynamic = {};
			for (key => value in changedValues) {
				if (value is CEData) {
					Reflect.setProperty(newdata, Std.string(key), cast(value, CEData).value);
				} else
					Reflect.setProperty(newdata, Std.string(key), value);
			}
			Reflect.setProperty(changeData, key, newdata);
			changedValues = [];
		}
	}

	override function getData(key:String, backdata:Dynamic):Void {
		var newdata = [];
		for (index => value in data) {
			newdata[index] = value;
		}
		Reflect.setProperty(backdata, key, newdata);
	}
}
