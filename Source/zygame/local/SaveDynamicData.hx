package zygame.local;

/**
 * 动态类型抽象类
 */
abstract SaveDynamicData(SaveDynamicDataContent) to SaveDynamicDataContent from SaveDynamicDataContent {
	public function new() {
		this = new SaveDynamicDataContent();
	}

	@:op(a.b) public function fieldRead(name:String) {
		return this.getValue(name);
	}

	@:op(a.b) public function fieldWrite(name:String, value:Dynamic) {
		return this.setValue(name, value);
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
	@:to public function toDynamic():Dynamic {
		return this.data;
	}
}

class SaveDynamicDataContent extends SaveDynamicDataBaseContent {
	/**
	 * 发生变化的值
	 */
	public var changedValues:Map<String, Dynamic> = [];

	/**
	 * 数据储存
	 */
	public var data:Dynamic = {};

	public function getValue(key:String):Dynamic {
		return Reflect.getProperty(this.data, key);
	}

	public function setValue(key:String, value:Dynamic):Dynamic {
		this.changed = true;
		this.changedValues.set(key, value);
		Reflect.setProperty(this.data, key, value);
		return value;
	}

	override function flush(key:String, changeData:Dynamic) {
		super.flush(key, changeData);
		if (changed) {
			changed = false;
			var newdata = {};
			for (key => value in changedValues) {
				Reflect.setProperty(newdata, key, value);
			}
			Reflect.setProperty(changeData, key, newdata);
		}
	}

	override function getData(key:String, backdata:Dynamic):Void {
		var newdata = {};
		var keys = Reflect.fields(data);
		for (key in keys) {
			Reflect.setProperty(newdata, key, Reflect.getProperty(data, key));
		}
		Reflect.setProperty(backdata, key, newdata);
	}
}
