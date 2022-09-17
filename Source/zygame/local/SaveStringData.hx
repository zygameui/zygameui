package zygame.local;

import zygame.utils.CEFloat;

/**
 * 动态类型抽象类
 */
abstract SaveStringData(SaveStringDataContent) to SaveStringDataContent from SaveStringDataContent {
	public function new(value:String = null) {
		this = new SaveStringDataContent();
		this.changed = true;
		this.data = value;
	}

	@:from static public function fromString(f:String):SaveStringData {
		var newValue = new SaveStringData(f);
		return newValue;
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toString():String {
		return this.data;
	}

	/**
	 * 转为String
	 * @return String
	 */
	@:to public function toDynamic():Dynamic {
		return this.data;
	}
}

class SaveStringDataContent extends SaveDynamicDataBaseContent {
	/**
	 * 数据储存
	 */
	public var data:String = "";

	override function flush(key:String, changeData:Dynamic) {
		super.flush(key, changeData);
		if (changed) {
			Reflect.setProperty(changeData, key, data);
			changed = false;
		}
	}

	override function getData(key:String, data:Dynamic) {
		Reflect.setProperty(data, key, this.data);
	}
}
