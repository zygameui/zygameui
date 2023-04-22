package zygame.local;

import haxe.Exception;
import haxe.io.Error;
import zygame.utils.Lib;
import haxe.Timer;
import zygame.local.SaveArrayData.SaveArrayDataContent;
import zygame.utils.CEFloat;
#if js
import js.html.Console;
import js.Browser;
#end
import haxe.Json;
#if sys
import sys.io.File;
import lime.system.ThreadPool;
#end
import zygame.local.SaveDynamicData;
import zygame.local.SaveFloatData;
import zygame.local.SaveStringData;
import haxe.Constraints;

class SaveObject<T:SaveObjectData> {
	#if cpp
	private static var threadPool:ThreadPool;
	#end

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

	/**
	 * 存档的间隔，默认为0，即立即存档
	 */
	public var saveInterval:Int = 0;

	/**
	 * 上一次上报的时间
	 */
	private var _lastTime:Float = 0;

	private var _id:String;

	private var _isReadData:Bool = false;

	/**
	 * 丢失的存档key，当发生丢失的存档key，则从线上存档中读取
	 */
	private var lossKey:Array<String> = [];

	public function new(id:String) {
		this._id = id;
	}

	@:generic public function make<T:SaveObjectData>(c:Class<SaveObjectData>):SaveObject<T> {
		#if cpp
		threadPool = new ThreadPool(0, 1);
		threadPool.doWork.add(threadPool_doWork);
		// threadPool.onProgress.add(threadPool_onProgress);
		// threadPool.onComplete.add(threadPool_onComplete);
		// threadPool.onError.add(threadPool_onError);
		#end
		this.data = cast Type.createInstance(c, []);
		try {
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
						value = Encryption.decode(value);
						Reflect.setProperty(localData, k, value);
					} else {
						// Key丢失
						// trace("存档key丢失：", id);
						lossKey.push(k);
					}
				}
				this.updateUserData(localData);
			}
			#elseif cpp
			var keys = Reflect.fields(data);
			var localData = {};
			for (k in keys) {
				var id = _id + "." + k;
				var shared = openfl.net.SharedObject.getLocal(id);
				var value = shared.data.data;
				if (value != null) {
					Reflect.setProperty(localData, k, value);
				} else {
					// Key丢失
					// trace("存档key丢失：", id);
					lossKey.push(k);
				}
			}
			this.updateUserData(localData);
			#end
		} catch (e:Exception) {
			var msg = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
			trace(msg);
		}
		return cast this;
	}

	#if cpp
	private static function threadPool_doWork(state:Dynamic):Void {
		// var saveid = _id + "." + key;
		var saveid = state.saveid;
		var key = state.key;
		var _localSaveData = state._localSaveData;
		var shared = openfl.net.SharedObject.getLocal(saveid);
		try {
			var v = Reflect.getProperty(_localSaveData, key);
			if (v is Float || v is String) {
				shared.data.data = v;
			} else {
				shared.data.data = Json.stringify(v);
			}
		} catch (e:haxe.Exception) {
			trace("storage.setItem, Key is [" + saveid + "] Error:" + e.message);
		}
		shared.flush();
		threadPool.sendComplete({});
	}
	#end

	/**
	 * 无效间隔操作
	 */
	public function invalidInterval():Void {
		_lastTime = -saveInterval;
	}

	public var isNewVersion:Bool = false;

	/**
	 * 同步网络数据
	 * @param cb 
	 */
	public function async(cb:Bool->Void = null):Void {
		data.version = data.version.toFloat() + 1;
		this.flush(false);
		if (!_isReadData) {
			if (saveAgent != null) {
				saveAgent.readData(function(data, err) {
					if (err == null) {
						var onlineVersion = data != null ? data.version : 0;
						var localVersion:Float = this.data.version;
						trace("同步线上数据：onlineVersion=", onlineVersion, "localVersion=", localVersion);
						var onlineDevice = data != null ? data.deviceid : "";
						var localDevice = this.data.deviceid.toString();
						trace("同步设备比较", onlineDevice, localDevice);
						isNewVersion = onlineVersion > this.data.version;
						if (!isNewVersion) {
							if (onlineDevice != localDevice) {
								trace("### 同步因设备不一致，需要强制更新线上数据 ###");
								isNewVersion = true;
							}
						}
						if (onlineVersion == 0) {
							isNewVersion = true;
						}
						// 更新设备
						this.data.deviceid = Lib.getUUID();
						// 新版本处理
						if (isNewVersion) {
							updateUserData(data);
							this.flush();
							// 这里需要进行数据比对
							_changedData = {};
							lossKey = [];
							_cbFunc(cb, true);
						} else {
							// 不同步本地的时候，直接同步
							this.data.updateUserData(data);
							this.flush();
							// 这里需要进行数据比对
							_changedData = {};
							this.checkOnlineUserData(data);
							// 这里做立即上报处理
							this.invalidInterval();
							this.flush(false);
							#if test
							trace("立即同步版本数据", _changedData);
							#end
							this.saveSaveAgent(cb);
						}
						_isReadData = true;
					} else {
						_cbFunc(cb, false);
					}
				});
			} else {
				_cbFunc(cb, true);
			}
		} else {
			saveSaveAgent(cb);
		}
	}

	private function saveSaveAgent(cb:Bool->Void):Void {
		if (saveAgent != null) {
			var now = Timer.stamp();
			if (now - _lastTime >= saveInterval) {
				_lastTime = now;
				_changedData.version = data.version.toFloat();
				Lib.nextFrameCall(() -> {
					saveAgent.saveData(_changedData, (data) -> {
						if (data != null)
							_cbFunc(cb, true);
						else {
							_cbFunc(cb, false);
						}
						_onSaveData(data);
					});
				});
			} else {
				_cbFunc(cb, false);
			}
		} else {
			_cbFunc(cb, true);
		}
	}

	/**
	 * 检查线上数据比对
	 * @param data 
	 */
	public function checkOnlineUserData(data:Dynamic):Void {
		// trace("开始处理lossKey:", lossKey);
		var keys = Reflect.fields(this.data);
		for (key in keys) {
			// trace("比对", key);
			var content:Dynamic = Reflect.getProperty(this.data, key);
			var compareContent:Dynamic = Reflect.getProperty(data, key);
			if (content == null) {
				continue;
			}
			if (lossKey.indexOf(key) != -1) {
				// 丢失key还原
				var obj = {};
				Reflect.setProperty(obj, key, compareContent);
				// trace("key还原：", key, obj);
				this.updateUserData(obj);
			}
			var allin = false;
			if (compareContent == null) {
				// 全部上报
				allin = true;
			}
			if (content is SaveArrayDataContent) {
				// 数组写入
				var array:SaveArrayDataContent<Dynamic> = content;
				// trace("数组比对：", compareContent, "\n本地储存：", array.data);
				for (index => dataB in array.data) {
					var id = Std.string(index);
					var dataA = allin ? null : Reflect.getProperty(compareContent, id);
					if (this.data.ce.exists(key)) {
						var cedata:SaveArrayDataContent<CEFloat> = content;
						var dataC = cedata.getValue(index).toFloat();
						if (allin || compare(dataA, dataC)) {
							// trace("比对不一致，更新");
							cedata.setValue(index, dataC);
						}
					} else {
						// 比对不一致时，刷新
						if (allin || compare(dataA, dataB)) {
							// trace("比对不一致，更新");
							array.setValue(index, dataB);
						}
					}
				}
			} else if (content is SaveFloatDataContent) {
				// 浮点写入
				var contentData:SaveFloatDataContent = content;
				#if cpp
				// trace("比对：", key, contentData.data.toFloat(), compareContent);
				#end
				if (allin || compare(contentData.data.toFloat(), compareContent)) {
					contentData.changed = true;
				}
			} else if (content is SaveStringDataContent) {
				// 字符串写入
				var contentData:SaveStringDataContent = content;
				if (allin || compare(contentData.data, compareContent)) {
					contentData.changed = true;
				}
			} else if (content is SaveDynamicDataContent) {
				// 动态类型写入
				var contentData:SaveDynamicDataContent<Dynamic> = content;
				var dataKeys = Reflect.fields(contentData.data);
				for (k in dataKeys) {
					// trace("开始比对：", key, k);
					if (this.data.ce.exists(key)) {
						var contentData2:SaveDynamicDataContent<CEFloat> = content;
						var dataA = contentData2.getValue(k).toFloat();
						var dataB = allin ? null : Reflect.getProperty(compareContent, k);
						if (allin || compare(dataA, dataB)) {
							// trace("比对不一致，更新", k, dataA, dataB);
							contentData2.setValue(k, dataA);
						}
					} else {
						var dataA = Reflect.getProperty(contentData, k);
						var dataB = allin ? null : Reflect.getProperty(compareContent, k);
						if (allin || compare(dataA, dataB)) {
							// trace("比对不一致，更新", k, dataA, dataB);
							contentData.setValue(k, dataA);
						}
					}
				}
			}
		}
		lossKey = [];
	}

	/**
	 * 通用比对
	 * @param dataA 
	 * @param dataB 
	 * @return Bool
	 */
	private function compare(dataA:Dynamic, dataB:Dynamic):Bool {
		if (dataA == null && dataB != null) {
			return true;
		}
		if (dataB == null && dataA != null) {
			return true;
		}
		if (dataA == null && dataB == null) {
			return false;
		}
		try {
			return Json.stringify(dataA) != Json.stringify(dataB);
		} catch (e:Error) {
			return false;
		}
	}

	/**
	 * 更新用户数据
	 * @param userData 
	 */
	public function updateUserData(userData:Dynamic):Void {
		var keys = Reflect.fields(userData);
		for (k in keys) {
			var current:Dynamic = Reflect.getProperty(data, k);
			if (current == null)
				continue;
			var value:Dynamic = Reflect.getProperty(userData, k);
			if (current is SaveArrayDataContent) {
				// 数组写入
				var obj = Reflect.isObject(value) ? value : Json.parse(value);
				var keys = Reflect.fields(obj);
				for (k2 in keys) {
					var v:Dynamic = Reflect.getProperty(obj, k2);
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
				var obj:Dynamic = Reflect.isObject(value) ? value : Json.parse(value);
				var keys = Reflect.fields(obj);
				for (k2 in keys) {
					var v:Dynamic = Reflect.getProperty(obj, k2);
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

	private function _cbFunc(cb:Bool->Void, bool:Bool):Void {
		if (cb != null) {
			cb(bool);
		}
	}

	private function _onSaveData(data:Dynamic):Void {
		// todo 这里要处理变更的数据，同步
		#if test
		trace("存档成功：", data, _changedData);
		#end
		if (data != null) {
			#if false
			// 回退版本
			_changedData = {};
			#else
			// 这里要做存档比对，然后将已上报的内容删除
			var keys = Reflect.fields(data);
			var checkKeys = [];
			for (key in keys) {
				var p = key.indexOf(".");
				if (p != -1) {
					// 复合key
					var arr = key.split(".");
					var setData = Reflect.getProperty(_changedData, arr[0]);
					if (setData != null) {
						if (checkKeys.indexOf(arr[0]) == -1) {
							checkKeys.push(arr[0]);
						}
						Reflect.deleteField(setData, arr[1]);
					}
				} else {
					// 单key
					Reflect.deleteField(_changedData, key);
				}
			}
			// 删除已空的复合key
			for (key in checkKeys) {
				var data = Reflect.getProperty(_changedData, key);
				if (data != null && Reflect.fields(data).length == 0) {
					Reflect.deleteField(_changedData, key);
				}
			}
			#end
		}
	}

	/**
	 * 只读的数据，全部数据请写入到这里
	 */
	public var data(default, null):T = null;

	/**
	 * 锁定不允许写入
	 */
	public var lockFlush:Bool = false;

	/**
	 * 写入本地，请注意，调用该接口不会发生上报网络请求
	 * @param clearChangedData 是否清空`changedData`数据，这意味着网络存档不会知道修改了什么内容
	 */
	public function flush(clearChangedData:Bool = false):Void {
		if (lockFlush)
			return;
		var changed:Dynamic = {};
		this.data.flush(changed);
		_flush(changed, _id);
		if (clearChangedData) {
			_changedData = {};
		}
	}

	/**
	 * 清空用户数据
	 */
	public function clear():Void {
		#if v3apisave
		zygame.cmnt.v3.V3Api.setData({}, function(data) {
			if (data.code == 0) {
				trace("重置成功");
			} else {
				trace("重置失败");
			}
		});
		#end
		var retdata = this.getData();
		var keys = Reflect.fields(retdata);
		for (key in keys) {
			_setLocal(key, "");
		}
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
			try {
				var v = Reflect.getProperty(_localSaveData, key);
				if (v is Float || v is String) {
					storage.setItem(saveid, Encryption.encode(Std.string(v)));
				} else
					storage.setItem(saveid, Encryption.encode(Json.stringify(v)));
			} catch (e:haxe.Exception) {
				trace("storage.setItem, Key is [" + saveid + "] Error:" + e.message);
			}
		}
		#elseif cpp
		var saveid = _id + "." + key;

		// 异步存档似乎有问题，暂不使用
		threadPool.queue({saveid: saveid, key: key, _localSaveData: _localSaveData});

		// var shared = openfl.net.SharedObject.getLocal(saveid);
		// try {
		// 	var v = Reflect.getProperty(_localSaveData, key);
		// 	if (v is Float || v is String) {
		// 		shared.data.data = v;
		// 	} else {
		// 		shared.data.data = Json.stringify(v);
		// 	}
		// } catch (e:haxe.Exception) {
		// 	trace("storage.setItem, Key is [" + saveid + "] Error:" + e.message);
		// }
		// shared.flush();
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
	 * 最后登陆的设备
	 */
	public var deviceid:SaveStringData = "";

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
			lastUploadTime = Std.int(Date.now().getTime() / 1000);
			Reflect.setProperty(data, "version", version.toFloat());
			Reflect.setProperty(data, "deviceid", deviceid.toString());
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
