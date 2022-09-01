package zygame.local;

import haxe.Json;
#if sys
import sys.io.File;
#end
import zygame.local.SaveDynamicData;
import haxe.Constraints;

class SaveObject<T:SaveObjectData> {
	/**
	 * 本地实时储存的数据，它会对每个储存的key做分离处理：
	 * - data.data=xxx
	 */
	private var _localSaveData:Dynamic = {};

	private var _id:String;

	public function new(id:String) {
		this._id = id;
	}

	@:generic public function make<K:SaveObjectData>(c:Class<SaveObjectData>):SaveObject<T> {
		this.data = cast Type.createInstance(c, []);
		// 读取本地的数据进行写入

		return this;
	}

	/**
	 * 只读的数据，全部数据请写入到这里
	 */
	public var data(default, null):T = null;

	public function flush():Void {
		var changed = {};
		this.data.flush(changed);
		_flush(changed, _id);
	}

	private function _flush(data:Dynamic, key:String):Void {
		var keys = Reflect.fields(data);
		if (keys.length == 0) {
			return;
		}
		// 开始写入
		for (index => value in keys) {
			var v = Reflect.getProperty(data, value);
			_setLocal(key + "." + value, v);
		}
	}

	private function _setLocal(key:String, value:String):Void {
		Reflect.setProperty(_localSaveData, key, value);
		#if js
		#elseif sys
		File.saveContent("save.test", Json.stringify(_localSaveData));
		#end
	}

	/**
	 * 获取数据
	 * @return Dynamic
	 */
	public function getData(data:Dynamic = null):Dynamic {
		data = data == null ? {} : data;
		this.data.getData(data);
		return data;
	}
}

class SaveObjectData {
	public function new() {}

	public function flush(data:Dynamic):Void {
		var keys = Reflect.fields(this);
		for (index => value in keys) {
			var content = Reflect.getProperty(this, value);
			if (content is SaveDynamicDataBaseContent) {
				// 特殊储存
				cast(content, SaveDynamicDataBaseContent).flush(value, data);
			}
		}
	}

	public function getData(data:Dynamic):Void {
		var keys = Reflect.fields(this);
		for (index => value in keys) {
			var content = Reflect.getProperty(this, value);
			if (content is SaveDynamicDataBaseContent) {
				// 特殊储存
				cast(content, SaveDynamicDataBaseContent).getData(value, data);
			}
		}
	}
}
