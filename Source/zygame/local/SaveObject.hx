package zygame.local;

import zygame.local.SaveArrayData.SaveArrayDataContent;
import zygame.utils.CEFloat;
#if js
import js.Browser;
#end
import haxe.Json;
#if sys
import sys.io.File;
#end
import zygame.local.SaveDynamicData;
import zygame.local.SaveFloatData;
import zygame.local.SaveStringData;
import haxe.Constraints;

class SaveObject<T:SaveObjectData> {
	/**
	 * 本地实时储存的数据，它会对每个储存的key做分离处理：
	 * - data.data=xxx
	 */
	private var _localSaveData:Dynamic = {};

	/**
	 * 储存代理，如存在远程储存服务器时，请使用该接口实现储存实现
	 */
	public var saveAgent:ISave;

	/**
	 * 已更改的实时数据，每次存档的时候，会把数据上报
	 */
	private var _changedData:Dynamic = {};

	private var _id:String;

	private var _isReadData:Bool = false;

	public function new(id:String) {
		this._id = id;
	}

	@:generic public function make<K:SaveObjectData>(c:Class<SaveObjectData>):SaveObject<T> {
		this.data = cast Type.createInstance(c, []);
		// 读取本地的数据进行写入
		#if js
		var storage = Browser.getLocalStorage();
		if (storage != null) {
			var keys = Reflect.fields(data);
			var localData = {};
			for (k in keys) {
				var id = _id + "." + k;
				var value = storage.getItem(id);
				if (value != null) {
					Reflect.setProperty(localData, k, value);
				}
			}
			this.updateUserData(localData);
		}
		#end
		return this;
	}

	private var _cb:Bool->Void;

	/**
	 * 同步网络数据
	 * @param cb 
	 */
	public function async(cb:Bool->Void = null):Void {
		_cb = cb;
		this.flush();
		if (!_isReadData) {
			if (saveAgent != null) {
				saveAgent.readData(function(data, err) {
					if (err == null) {
						_isReadData = true;
						// trace("用户数据读取成功：", data);
						var onlineVersion = data != null ? data.version : 0;
						var localVersion:Float = this.data.version;
						trace("同步线上数据：onlineVersion=", onlineVersion, "lacalVersion=", localVersion);
						if (onlineVersion > this.data.version) {
							updateUserData(data);
						} else {
							// 不同步本地的时候，直接同步
							this.data.updateUserData(data);
						}
						// todo 这里的_changedData可能要做线上数据比对
						this.flush();
						_changedData = {};
						cb(true);
					}
				});
			} else {
				_cbFunc(true);
			}
		} else {
			if (saveAgent != null) {
				saveAgent.saveData(_changedData, _onSaveData);
			} else {
				_cbFunc(true);
			}
		}
	}

	/**
	 * 更新用户数据
	 * @param userData 
	 */
	public function updateUserData(userData:Dynamic):Void {
		#if test
		trace("updateUserData", userData);
		#end
		var keys = Reflect.fields(userData);
		for (k in keys) {
			var current:Dynamic = Reflect.getProperty(data, k);
			if (current == null)
				continue;
			var value = Reflect.getProperty(userData, k);
			#if test
			trace("写入：", k, value);
			#end
			if (current is SaveArrayDataContent) {
				// 数组写入
				var obj = Reflect.isObject(value) ? value : Json.parse(value);
				var keys = Reflect.fields(obj);
				for (k2 in keys) {
					var v = Reflect.getProperty(obj, k2);
					if (data.ce.exists(k)) {
						var setValue:Float = v;
						var cedata:SaveArrayDataContent<CEFloat> = current;
						cedata.setValue(Std.parseInt(k2), setValue);
					} else
						cast(current, SaveArrayDataContent<Dynamic>).setValue(Std.parseInt(k2), v);
				}
			} else if (current is SaveFloatDataContent) {
				// 浮点写入
				var value = Std.parseFloat(value);
				cast(current, SaveFloatDataContent).data = Math.isNaN(value) ? 0 : value;
				cast(current, SaveFloatDataContent).changed = true;
			} else if (current is SaveStringDataContent) {
				// 字符串写入
				cast(current, SaveStringDataContent).data = value;
				cast(current, SaveStringDataContent).changed = true;
			} else if (current is SaveDynamicDataContent) {
				// 动态对象写入
				var obj = Reflect.isObject(value) ? value : Json.parse(value);
				var keys = Reflect.fields(obj);
				for (k2 in keys) {
					var v = Reflect.getProperty(obj, k2);
					if (data.ce.exists(k)) {
						var setValue:Float = v;
						var cedata:SaveDynamicDataContent<CEFloat> = current;
						cedata.setValue(k2, setValue);
					} else
						cast(current, SaveDynamicDataContent<Dynamic>).setValue(k2, v);
				}
			}
		}
		this.data.updateUserData(userData);
	}

	private function _cbFunc(bool:Bool):Void {
		if (_cb != null) {
			_cb(bool);
			_cb = null;
		}
	}

	private function _onSaveData(data:Dynamic):Void {
		// todo 这里要处理变更的数据，同步
		if (data != null) {
			_changedData = {};
		}
		_cbFunc(data != null);
	}

	/**
	 * 只读的数据，全部数据请写入到这里
	 */
	public var data(default, null):T = null;

	/**
	 * 写入本地，请注意，调用该接口不会发生上报网络请求
	 * @param clearChangedData 是否清空`changedData`数据，这意味着网络存档不会知道修改了什么内容
	 */
	public function flush(clearChangedData:Bool = false):Void {
		var changed = {};
		this.data.flush(changed);
		_flush(changed, _id);
		if (clearChangedData) {
			_changedData = {};
		}
		// trace("最后更改的数据：", changed);
	}

	private function _flush(data:Dynamic, key:String):Void {
		var keys = Reflect.fields(data);
		if (keys.length == 0) {
			return;
		}
		// 开始写入
		for (index => value in keys) {
			var v = Reflect.getProperty(data, value);
			_setLocal(value, v);
		}
		#if sys
		File.saveContent("save.test", Json.stringify(_localSaveData));
		#end
		// trace("应该上报到网络服务器的数据：", _changedData);
	}

	private function _setLocal(key:String, value:Dynamic):Void {
		if (!(value is Float || value is String)) {
			// 属于Object
			var keys = Reflect.fields(value);
			var data = Reflect.getProperty(_localSaveData, key);
			if (data == null)
				data = {};
			var changedData = Reflect.getProperty(_changedData, key);
			if (changedData == null)
				changedData = {};
			for (k in keys) {
				var v = Reflect.getProperty(value, k);
				Reflect.setProperty(data, k, v);
				Reflect.setProperty(changedData, k, v);
			}
			Reflect.setProperty(_localSaveData, key, data);
			Reflect.setProperty(_changedData, key, changedData);
		} else {
			// 属于Float
			Reflect.setProperty(_localSaveData, key, value);
			Reflect.setProperty(_changedData, key, value);
		}
		// trace("保存数据", key, value);
		#if js
		var storage = Browser.getLocalStorage();
		if (storage != null) {
			var saveid = _id + "." + key;
			var v = Reflect.getProperty(_localSaveData, key);
			if (v is Float || v is String) {
				storage.setItem(saveid, v);
			} else
				storage.setItem(saveid, Json.stringify(v));
		}
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

@:autoBuild(zygame.local.SaveObjectMacro.build())
class SaveObjectData {
	/**
	 * 版本号
	 */
	public var version:SaveFloatData = 0.;

	/**
	 * 最后上传时间
	 */
	public var lastUploadTime:SaveFloatData = 0.;

	/**
	 * CE对象
	 */
	public var ce:Map<String, Bool> = [];

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
		if (Reflect.fields(data).length > 0) {
			version = version.toFloat() + 1;
			lastUploadTime = Std.int(Date.now().getTime() / 1000);
			Reflect.setProperty(data, "version", version.toFloat());
			Reflect.setProperty(data, "lastUploadTime", lastUploadTime.toFloat());
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

	public function updateUserData(userData:Dynamic):Void {}
}
