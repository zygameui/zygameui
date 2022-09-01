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
