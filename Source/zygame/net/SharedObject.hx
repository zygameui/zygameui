package zygame.net;

import haxe.Timer;
import zygame.worker.Worker;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
#if lime
import lime.app.Application;
import lime.system.System;
#end
#if (js && html5)
import js.Browser;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import openfl.net.SharedObjectFlushStatus;

/**
 * 这是一个改进的SharedObject，在微信小游戏上，储存序列改进
 */
@:access(openfl.net.SharedObject)
class SharedObject extends openfl.net.SharedObject {
	public static var worker:Worker;

	private static var __zygameui_save_name:String = null;

	/**
	 * 获取一个数据共享对象
	 * @param name 
	 * @return SharedObject
	 */
	public static function getLocal(name:String, localPath:String = null, secure:Bool = false /* note: unsupported**/):openfl.net.SharedObject {
		__zygameui_save_name = name;
		#if weixin
		#if weixin_worker
		if (Worker.isSupport() && worker == null) {
			worker = new Worker("workers/worker.js");
			worker.onMessage = function(data) {
				switch (data.type) {
					case "serialize":
						// 序列化储存
						var time = Timer.stamp();
						cast(getLocal(__zygameui_save_name), SharedObject)._flush(data.data);
						var now = Timer.stamp();
				}
			};
		}
		#end
		// 微信小游戏改进
		var illegalValues = [" ", "~", "%", "&", "\\", ";", ":", "\"", "'", ",", "<", ">", "?", "#"];
		var allowed = true;
		if (name == null || name == "") {
			allowed = false;
		} else {
			for (value in illegalValues) {
				if (name.indexOf(value) > -1) {
					allowed = false;
					break;
				}
			}
		}
		if (!allowed) {
			throw new Error("Error #2134: Cannot create SharedObject.");
			return null;
		}
		if (@:privateAccess openfl.net.SharedObject.__sharedObjects == null) {
			@:privateAccess openfl.net.SharedObject.__sharedObjects = new Map();
			// Lib.application.onExit.add (application_onExit);
			#if lime
			if (Application.current != null) {
				Application.current.onExit.add(@:privateAccess openfl.net.SharedObject.application_onExit);
			}
			#end
		}
		var id = localPath + "/" + name;
		if (! @:privateAccess openfl.net.SharedObject.__sharedObjects.exists(id)) {
			var encodedData = null;
			try {
				#if (js && html5)
				var storage = Browser.getLocalStorage();
				if (localPath == null) {
					// Check old default path, first
					if (storage != null) {
						encodedData = storage.getItem(Browser.window.location.href + ":" + name);
						storage.removeItem(Browser.window.location.href + ":" + name);
					}
					localPath = Browser.window.location.pathname;
				}
				if (storage != null && encodedData == null) {
					encodedData = storage.getItem(localPath + ":" + name);
				}
				#else
				if (localPath == null)
					localPath = "";
				var path = __getPath(localPath, name);
				if (FileSystem.exists(path)) {
					encodedData = File.getContent(path);
				}
				#end
			} catch (e:Dynamic) {}
			var sharedObject = new SharedObject();
			sharedObject.data = {};
			sharedObject.__localPath = localPath;
			sharedObject.__name = name;
			if (encodedData != null && encodedData != "") {
				try {
					if (encodedData is String) {
						var unserializer = new Unserializer(encodedData);
						unserializer.setResolver(cast {resolveEnum: Type.resolveEnum, resolveClass: @:privateAccess openfl.net.SharedObject.__resolveClass});
						sharedObject.data = unserializer.unserialize();
					} else {
						// 这是微信小游戏的改进，不再使用Haxe的序列处理，直接使用Json序列
						sharedObject.data = encodedData;
					}
				} catch (e:Dynamic) {}
			}
			@:privateAccess openfl.net.SharedObject.__sharedObjects.set(id, sharedObject);
		}
		return @:privateAccess openfl.net.SharedObject.__sharedObjects.get(id);
		#else
		return openfl.net.SharedObject.getLocal(name);
		#end
	}

	private function _flush(encodedData:String):SharedObjectFlushStatus {
		try {
			#if (js && html5)
			var storage = Browser.getLocalStorage();
			if (storage != null) {
				storage.removeItem(__localPath + ":" + __name);
				storage.setItem(__localPath + ":" + __name, encodedData);
			}
			#else
			var path = openfl.net.SharedObject.__getPath(__localPath, __name);
			var directory = Path.directory(path);

			if (!FileSystem.exists(directory)) {
				openfl.net.SharedObject.__mkdir(directory);
			}

			var output = File.write(path, false);
			output.writeString(encodedData);
			output.close();
			#end
			return SharedObjectFlushStatus.FLUSHED;
		} catch (e:Dynamic) {
			return SharedObjectFlushStatus.PENDING;
		}
	}

	override function flush(minDiskSpace:Int = 0):SharedObjectFlushStatus {
		#if weixin
		if (Reflect.fields(data).length == 0) {
			return SharedObjectFlushStatus.FLUSHED;
		}
		// 微信小游戏改进，这里不做Haxe序列化，直接通过Json序列化
		var encodedData = data;
		if (worker != null) {
			// worker异步处理
			worker.postMessage({
				type: "serialize",
				data: data
			});
			return SharedObjectFlushStatus.FLUSHED;
		}
		try {
			#if (js && html5)
			var storage = Browser.getLocalStorage();
			if (storage != null) {
				storage.removeItem(__localPath + ":" + __name);
				storage.setItem(__localPath + ":" + __name, encodedData);
			}
			#else
			var path = __getPath(__localPath, __name);
			var directory = Path.directory(path);

			if (!FileSystem.exists(directory)) {
				__mkdir(directory);
			}

			var output = File.write(path, false);
			output.writeString(encodedData);
			output.close();
			#end
		} catch (e:Dynamic) {
			return SharedObjectFlushStatus.PENDING;
		}
		return SharedObjectFlushStatus.FLUSHED;
		#else
		return super.flush(minDiskSpace);
		#end
	}
}
