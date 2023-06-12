package zygame.utils;

import zygame.components.ZBuilder;
import haxe.Json;
import haxe.macro.Compiler;
import haxe.io.Encoding;
#if extsound
import common.media.Sound;
#else
import openfl.media.Sound;
#end
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.display.Loader;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import lime.utils.Assets;
import lime.graphics.Image;
import openfl.utils.ByteArray;
import zygame.display.ZBitmapData;
import haxe.zip.Entry;
#if cpp
import haxe.Http;
import lime.app.Future;
import lime.app.Promise;
import lime.system.ThreadPool;
#end
import haxe.io.BytesInput;
import haxe.zip.Reader in Zip;
import haxe.zip.Entry;
import haxe.io.Bytes;
import lime._internal.format.Deflate;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture;

/**
 * 载入工具
 */
@:expose
class AssetsUtils {
	/**
	 * 加载失败后尝试加载次数
	 */
	public static var failTryLoadTimes:Int = 3;

	/**
	 * 游戏主路径
	 */
	public static var nativePath:String = Compiler.getDefine("REMOTE_PATH");

	/**
	 * 将ZAssets当前加载列表资源导出
	 */
	public static function parserAssetsConfigToXml(assets:ZAssets):String {
		var parserLog:Array<Dynamic> = [];
		for (base in assets.getParsers()) {
			parserLog.push(base.getData());
		}
		return Json.stringify(parserLog);
	}

	/**
	 * 在ZIP中查找资源
	 * @return Entry
	 */
	public static function findZipData(list:List<Entry>, fileName:String):Entry {
		for (entry in list) {
			if (entry.fileName.indexOf(fileName) != -1) {
				return entry;
			}
		}
		return null;
	}

	public static function loadSound(id:String, cache:Bool = false):SoundLoader {
		return new SoundLoader(ofPath(id));
	}

	public static function loadText(id:String, cache:Bool = false):TextLoader {
		return new TextLoader(ofPath(id));
	}

	public static function loadBitmapData(id:String, cache:Bool = false, isAtf:Bool = false):BitmapDataLoader {
		return new BitmapDataLoader(ofPath(id), isAtf);
	}

	public static function loadBytes(id:String, cache:Bool = false):BytesLoader {
		return new BytesLoader(ofPath(id));
	}

	/**
	 * 清理缓存
	 * @param url 
	 */
	public static function cleanCacheId(url:String):Bool {
		#if cpp
		url = ofPath(url);
		// 将缓存清理
		var md5path:String = haxe.crypto.Md5.encode(url);
		if (sys.FileSystem.exists(lime.system.System.applicationStorageDirectory + md5path)) {
			trace("缓存异常，删除：", lime.system.System.applicationStorageDirectory + md5path);
			sys.FileSystem.deleteFile(lime.system.System.applicationStorageDirectory + md5path);
			return true;
		}
		#end
		return false;
	}

	public static function ofPath(path:String):String {
		if (path == null)
			return null;
		if (path.indexOf("://") != -1)
			return path;
		#if (web && !wechat && !qq && !minigame)
		if (path.indexOf("?") > -1) {
			path += "&" + Assets.cache.version;
		} else {
			path += "?" + Assets.cache.version;
		}
		#end
		#if (html5)
		if (nativePath == null && untyped window.webPath != null) {
			nativePath = untyped window.webPath;
		}
		var assetsVersion:Dynamic = Assets.cache.version;
		if (nativePath != null) {
			if (path.indexOf("http") == -1) {
				// 生成远程地址
				path = nativePath + "/" + path;
				if (path.indexOf('?') > -1) {
					path += '&' + assetsVersion;
				} else {
					path += '?' + assetsVersion;
				}
			}
		}
		#end
		#if ios
		if (path.indexOf("http") != 0)
			path = "assets/" + path;
		#end
		#if (oppo || vivo || xiaomi)
		var newPath = HTMLUtils.getLocalAssets(path);
		if (newPath != null)
			path = newPath;
		#end
		#if cpp
		if (nativePath != null) {
			if (path.indexOf("http") == -1) {
				var assetsVersion:Dynamic = Assets.cache.version;
				// 生成远程地址
				path = nativePath + "/" + path;
				if (path.indexOf('?') > -1) {
					path += '&' + assetsVersion;
				} else {
					path += '?' + assetsVersion;
				}
			}
		}
		#end
		#if openfl_so_load
		path = soutils.FileManager.ofPath(path);
		#end
		return path;
	}
}

class BaseLoader {
	public var loadTimes:Int = 0;

	public var path:String = null;

	public var errorCallBack:Dynamic->Void;

	public function new(path:String) {
		this.path = path;
	}

	public function onError(call:Dynamic->Void):BaseLoader {
		errorCallBack = call;
		return this;
	}

	public function callError(msg:String):Void {
		if (errorCallBack != null)
			errorCallBack(msg);
	}
}

class BytesLoader extends BaseLoader {
	#if (cpp && !ios && !use_openfl_bytes_loader)
	private static var threadPool:ThreadPool;

	private var promise:Promise<Bytes>;
	#end

	private var _onCompleteAssetsCall:String->Bytes->Void;

	private var _onCompleteCall:Bytes->Void;

	/**
	 * 回调，包含路径的回调
	 * @param call
	 * @return BitmapDataLoader
	 */
	public function onCompleteAssets(call:String->Bytes->Void):BytesLoader {
		_onCompleteAssetsCall = call;
		onComplete(function(bytes:Bytes):Void {
			_onCompleteAssetsCall(path, bytes);
		});
		return this;
	}

	public function onComplete(call:Bytes->Void):BytesLoader {
		_onCompleteCall = call;
		#if (cpp && !ios && !use_openfl_bytes_loader)
		var uri:String = #if ios path #else path #end;
		this.promise = new Promise<Bytes>();
		var md5path:String = haxe.crypto.Md5.encode(uri);
		if (uri.indexOf("http") == 0) {
			if (uri.indexOf("?") > -1) {
				uri += "&" + Assets.cache.version;
			} else {
				uri += "?" + Assets.cache.version;
			}
			// 网络加载，当缓存文件不存在时，进行本地缓存
			promise.future.onComplete(function(bytes:Bytes):Void {
				// 将bytes储存至本地作为缓存
				if (uri.indexOf("http") == 0) {
					if (lime.system.System.applicationStorageDirectory != null) {
						sys.io.File.saveBytes(lime.system.System.applicationStorageDirectory + md5path, bytes);
					}
				}
				_onCompleteCall(bytes);
				_onCompleteCall = null;
			}).onError(function(err:Dynamic):Void {
				callError("加载错误：" + err);
				_onCompleteCall = null;
			});
			if (sys.FileSystem.exists(lime.system.System.applicationStorageDirectory + md5path)) {
				uri = lime.system.System.applicationStorageDirectory + md5path;
			}
		} else {
			// 普通载入，不作缓存处理
			promise.future.onComplete(function(bytes:Bytes):Void {
				_onCompleteCall(bytes);
				_onCompleteCall = null;
			}).onError(function(err:Dynamic):Void {
				callError("加载错误：" + err);
				_onCompleteCall = null;
			});
		}
		if (threadPool == null) {
			threadPool = new ThreadPool(0, 10);
			threadPool.doWork.add(threadPool_doWork);
			threadPool.onProgress.add(threadPool_onProgress);
			threadPool.onComplete.add(threadPool_onComplete);
			threadPool.onError.add(threadPool_onError);
		}
		threadPool.queue({instance: this, uri: uri});
		#else
		var request:URLRequest = new URLRequest(#if ios path #else path #end);
		var url:URLLoader = new URLLoader();
		url.dataFormat = openfl.net.URLLoaderDataFormat.BINARY;
		url.load(request);
		url.addEventListener(Event.COMPLETE, function(e:Event):Void {
			var bytes:ByteArray = url.data;
			_onCompleteCall(bytes);
			_onCompleteCall = null;
		});
		url.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):Void {
			callError("无法加载" + path);
			_onCompleteCall = null;
		});
		#end

		return this;
	}

	#if (cpp && !ios && !use_openfl_bytes_loader)
	private static function threadPool_doWork(state:Dynamic):Void {
		var instance:BytesLoader = state.instance;
		var path:String = state.uri;

		if (state.uri.indexOf("http") == 0) {
			var req:Http = new Http(path);
			var responseBytes = new haxe.io.BytesOutput();
			var isError = false;
			req.onError = function(err) {
				// 超时会走这里
				trace("http.onError status = ", err, AssetsUtils.ofPath(path));
				if (isError)
					return;
				isError = true;
				threadPool.sendError({instance: instance, promise: instance.promise, error: "Cannot load file: " + path});
			};
			var status:Int = 0;
			req.onStatus = function(code:Int):Void {
				status = code;
			}
			req.customRequest(false, responseBytes, null, "GET");
			if (status == 200) {
				threadPool.sendComplete({
					instance: instance,
					promise: instance.promise,
					type: "haxe.Http",
					result: responseBytes
				});
			} else {
				threadPool.sendError({instance: instance, promise: instance.promise, error: "Cannot load file: " + path});
			}
		} else {
			// 本地文件走lime原生
			var bytes:Bytes = lime.utils.Bytes.fromFile(path);
			if (bytes != null) {
				threadPool.sendProgress({
					instance: instance,
					promise: instance.promise,
					bytesLoaded: bytes.length,
					bytesTotal: bytes.length
				});
				threadPool.sendComplete({
					instance: instance,
					promise: instance.promise,
					type: "lime.utils.Bytes",
					result: bytes
				});
			} else {
				if (isError)
					return;
				isError = true;
				threadPool.sendError({instance: instance, promise: instance.promise, error: "Cannot load file: " + path});
			}
		}
	}

	private static function threadPool_onComplete(state:Dynamic):Void {
		var promise:Promise<Bytes> = state.promise;
		if (promise.isError)
			return;
		if (state.type == "haxe.Http")
			promise.complete(state.result.getBytes());
		else
			promise.complete(state.result);

		var instance = state.instance;
		instance.promise = null;
	}

	private static function threadPool_onError(state:Dynamic):Void {
		var promise:Promise<Bytes> = state.promise;
		if (promise != null) {
			promise.error(state.error);
			var instance = state.instance;
			instance.promise = null;
		}
	}

	private static function threadPool_onProgress(state:Dynamic):Void {
		var promise:Promise<Bytes> = state.promise;
		if (promise.isComplete || promise.isError)
			return;
		promise.progress(state.bytesLoaded, state.bytesTotal);
	}
	#end
}

typedef BitmapDataLoaderCall = {
	onCompleteCall:BitmapData->Void
}

@:access(lime.graphics.Image)
class BitmapDataLoader extends BaseLoader {
	/**
	 * 重复任务的侦听回调支持
	 */
	private static var __listeners:Map<String, Array<BitmapDataLoaderCall>> = [];

	public var isAtf:Bool = false;

	private var _onCompleteAssetsCall:String->BitmapData->Void;

	private var _onCompleteCall:BitmapData->Void;

	public function new(path:String, isAtf:Bool) {
		super(path);
		this.isAtf = isAtf;
	}

	/**
	 * 回调，包含路径的回调
	 * @param call
	 * @return BitmapDataLoader
	 */
	public function onCompleteAssets(call:String->BitmapData->Void):BitmapDataLoader {
		_onCompleteAssetsCall = call;
		onComplete(function(bitmapData:BitmapData):Void {
			if (_onCompleteAssetsCall != null)
				_onCompleteAssetsCall(path, bitmapData);
			_onCompleteAssetsCall = null;
		});
		return this;
	}

	public function onComplete(call:BitmapData->Void):BitmapDataLoader {
		_onCompleteCall = call;
		#if atf
		AssetsUtils.loadBytes(path, false).onComplete(function(bytes:Bytes):Void {
			var h = bytes.getInt32(0);
			if (h == 0x04034B50) {
				// 属于atf.zip压缩格式，需要进行ATF解析
				var input:BytesInput = new BytesInput(bytes);
				var zip:Zip = new Zip(input);
				var list:List<Entry> = zip.read();
				var entry:Entry = list.first();
				if (entry != null) {
					// 解压
					var size = entry.fileName.split("x");
					var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
					var texture:Texture = zygame.core.Start.current.stage.context3D.createTexture(Std.parseInt(size[1]), Std.parseInt(size[0]),
						Context3DTextureFormat.COMPRESSED_ALPHA, false);
					texture.uploadCompressedTextureFromByteArray(bytes, 0);
					var bitmapData = BitmapData.fromTexture(texture);
					if (_onCompleteCall != null)
						_onCompleteCall(bitmapData);
					_onCompleteCall = null;
				} else {
					callError("没有包含atf资源");
					_onCompleteCall = null;
				}
			} else {
				// 普通的图片格式，正常载入
				Image.loadFromBytes(bytes).onComplete((img) -> {
					var bitmapData:zygame.display.ZBitmapData = zygame.display.ZBitmapData.fromImage(img);
					bitmapData.path = path;
					if (_onCompleteCall != null)
						_onCompleteCall(bitmapData);
					_onCompleteCall = null;
				});
			}
		});

		return this;
		#else
		return onComplete2(_onCompleteCall);
		#end
	}

	private function onComplete2(call:BitmapData->Void):BitmapDataLoader {
		var imgname = StringUtils.getName(path);
		var ext = StringUtils.getExtType(path);
		var zipAssets = ZBuilder.getZipAssetsByExsit(imgname, ext);
		if (zipAssets != null) {
			// 直接通过Zip资源包加载
			@:privateAccess zipAssets.loadZipBitmapData(imgname, call);
			return this;
		}
		if (isAtf) {
			// ATF载入流程分解：需要先将zip加载，然后进行解压，获取到对应imgPath的文件，然后再创建读取Texture
			AssetsUtils.loadBytes(path, false).onComplete(function(bytes:Bytes):Void {
				var input:BytesInput = new BytesInput(bytes);
				var zip:Zip = new Zip(input);
				var list:List<Entry> = zip.read();
				var entry:Entry = AssetsUtils.findZipData(list, ".atf");
				if (entry != null) {
					// 解压
					var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
					var texture:Texture = zygame.core.Start.current.stage.context3D.createTexture(2048, 2048, Context3DTextureFormat.COMPRESSED_ALPHA, false);
					texture.uploadCompressedTextureFromByteArray(bytes, 0);
					var bitmapData = BitmapData.fromTexture(cast untyped texture);
					GPUUtils.addBitmapData(bitmapData);
					if (call != null)
						call(bitmapData);
					call = null;
				} else {
					callError("没有包含atf资源");
					call = null;
				}
			});
		} else {
			#if cpp
			#if ios
			if (path.indexOf("http") == -1)
				path = path.substr(7);
			#end
			AssetsUtils.loadBytes(path).onComplete((bytes) -> {
				Image.loadFromBytes(bytes).onComplete((img) -> {
					var bitmapData:zygame.display.ZBitmapData = zygame.display.ZBitmapData.fromImage(img);
					GPUUtils.addBitmapData(bitmapData);
					if (bitmapData == null) {
						if (callError != null)
							callError("无法加载" + path);
					} else {
						bitmapData.path = path;
						if (call != null)
							call(bitmapData);
					}
					call = null;
				});
			}).onError((msg) -> {
				if (callError != null)
					callError("无法加载" + path);
				call = null;
			});
			#else
			if (__listeners.exists(path)) {
				// 已存在任务，追加列表
				__listeners.get(path).push({
					onCompleteCall: call
				});
				return this;
			}
			__listeners.set(path, [
				{
					onCompleteCall: call
				}
			]);
			var img:Image = new Image();
			img.__fromFile(path, function(loadedImage:Image):Void {
				var bitmapData:zygame.display.ZBitmapData = zygame.display.ZBitmapData.fromImage(loadedImage);
				if (bitmapData == null) {
					if (callError != null)
						callError("无法加载" + path);
				} else {
					bitmapData.path = path;
					GPUUtils.addBitmapData(bitmapData);
					// if (call != null)
					// 	call(bitmapData);
					for (c in __listeners.get(path)) {
						if (c != null) {
							c.onCompleteCall(bitmapData.clone());
						}
					}
				}
				__listeners.remove(path);
				call = null;
			}, function():Void {
				// 加载失败，应该移除所有回调，并且重新载入
				if (loadTimes < AssetsUtils.failTryLoadTimes) {
					// 重试
					trace("重载：" + path + "," + loadTimes);
					loadTimes++;
					onComplete2(call);
				} else if (callError != null)
					callError("无法加载" + path);
				__listeners.remove(path);
				call = null;
			});
			#end
		}
		return this;
	}
}

class TextLoader extends BaseLoader {
	/**
	 * 解码处理回调：文件名->数据->解码数据
	 */
	public static var decodeCallback:String->String->String;

	public var _onCompleteAssetsCall:String->String->Void;

	public var _onCompleteCall:String->Void;

	public function onCompleteAssets(call:String->String->Void):TextLoader {
		_onCompleteAssetsCall = call;
		onComplete(function(text:String):Void {
			if (_onCompleteAssetsCall != null)
				_onCompleteAssetsCall(path, text);
			_onCompleteAssetsCall = null;
		});
		return this;
	}

	public function onComplete(call:String->Void):TextLoader {
		var filename = StringUtils.getName(path);
		var ext = StringUtils.getExtType(path);
		var zipAssets = ZBuilder.getZipAssetsByExsit(filename, ext);
		if (zipAssets != null) {
			// 直接通过Zip资源包加载
			var text = @:privateAccess zipAssets.getZipString(filename + "." + ext);
			call(text);
			return this;
		}
		_onCompleteCall = call;
		var url:URLRequest = new URLRequest(path);
		var data:URLLoader = new URLLoader();
		data.addEventListener(Event.COMPLETE, function(_):Void {
			// 特殊解码处理
			if (decodeCallback != null)
				data.data = decodeCallback(path, data.data);
			if (_onCompleteCall != null)
				_onCompleteCall(data.data);
			_onCompleteCall = null;
		});
		data.addEventListener(IOErrorEvent.IO_ERROR, function(e):Void {
			if (loadTimes < AssetsUtils.failTryLoadTimes) {
				// 重试
				trace("重载：" + path + "," + loadTimes);
				loadTimes++;
				onComplete(_onCompleteCall);
			} else
				callError("无法加载" + path);
		});
		data.load(url);
		return this;
	}
}

class SoundLoader extends BaseLoader {
	private var _onCompleteCall:Sound->Void;
	private var _onCompleteAssetsCall:String->Sound->Void;

	public function onCompleteAssets(call:String->Sound->Void):BaseLoader {
		_onCompleteAssetsCall = call;
		onComplete(function(sound:Sound):Void {
			if (_onCompleteAssetsCall != null)
				_onCompleteAssetsCall(path, sound);
			_onCompleteAssetsCall = null;
		});
		return this;
	}

	public function onComplete(call:Sound->Void):BaseLoader {
		_onCompleteCall = call;
		var url:URLRequest = new URLRequest(path);
		var sound:Sound = new Sound();
		sound.addEventListener(Event.COMPLETE, function(_):Void {
			if (_onCompleteCall != null)
				_onCompleteCall(sound);
			_onCompleteCall = null;
		});
		sound.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):Void {
			if (loadTimes < AssetsUtils.failTryLoadTimes) {
				// 重试
				trace("重载：" + path + "," + loadTimes);
				loadTimes++;
				onComplete(_onCompleteCall);
			} else
				callError("无法加载" + path);
		});
		sound.load(url);
		return this;
	}
}

class BytesSoundLoader extends BaseLoader {
	public var bytes:ByteArray;

	private var _onCompleteAssetsCall:String->Sound->Void;

	private var _onCompleteCall:Sound->Void;

	public function new(path:String, bytes:ByteArray) {
		super(path);
		this.bytes = bytes;
	}

	public function onCompleteAssets(call:String->Sound->Void):BaseLoader {
		_onCompleteAssetsCall = call;
		onComplete(function(sound:Sound):Void {
			if (_onCompleteAssetsCall != null)
				_onCompleteAssetsCall(path, sound);
		});
		return this;
	}

	public function onComplete(call:Sound->Void):BaseLoader {
		_onCompleteCall = call;
		var url:URLRequest = new URLRequest(path);
		var sound:Sound = new Sound();
		sound.addEventListener(Event.COMPLETE, function(_):Void {
			if (_onCompleteCall != null)
				_onCompleteCall(sound);
			_onCompleteCall = null;
		});
		sound.addEventListener(IOErrorEvent.IO_ERROR, function(_):Void {
			callError("无法加载" + path);
		});
		sound.loadCompressedDataFromByteArray(this.bytes, this.bytes.bytesAvailable);
		return this;
	}
}
