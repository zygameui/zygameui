package zygame.utils.load;

import zygame.utils.load.SWFLiteLibrary;
import openfl.utils.AssetLibrary;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.utils.ByteArray;
import haxe.io.BytesInput;
import haxe.zip.Reader in Zip;
import haxe.zip.Entry;
import zygame.utils.load.SWFLiteLibrary;
import lime.utils.AssetManifest;
import zygame.utils.AssetsUtils;
import haxe.io.Bytes;
import lime._internal.format.Deflate;
import lime.net.HTTPRequest;
import haxe.Http;
import lime.utils.Assets;
#if cpp
import lime.app.Future;
import lime.app.Promise;
import lime.system.ThreadPool;
#end

#if (openfl_swf)

#if (openfl >= '9.0.0')
typedef SWFLiteLoader = SWFLiteLoaderOpenFL9;
#else

/**
 * SWFLite加载器，用于加载zip压缩格式的SWF资源
 */
@:access(zygame.utils.load.SWFLiteLibrary)
class SWFLiteLoader {
	#if cpp
	/**
	 * 线程库
	 */
	private static var threadPool:ThreadPool;

	private var promise:Promise<Bytes>;
	#end

	private var _path:String;

	private var _rootPath:String;

	private var _isZip:Bool = true;

	public function new(path:String, rootPath:String = null, isZip:Bool = true):Void {
		_isZip = isZip;
		_path = path;
		_rootPath = rootPath;
	}

	/**
	 * SwfliteParse
	 */
	private function onSwfliteParse(bytes:Bytes, call:SWFLiteLibrary->Void, errorCall:String->Void):Void {
		var input:BytesInput = new BytesInput(bytes);
		var zip:Zip = new Zip(input);
		var list:List<Entry> = zip.read();
		var entry:Entry = AssetsUtils.findZipData(list, "library.json");
		if (entry != null) {
			// 解压
			var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
			AssetManifest.loadFromBytes(bytes, _rootPath).onComplete(function(manifest:AssetManifest):Void {
				manifest.libraryType = "zygame.utils.load.SWFLiteLibrary";
				var swf:SWFLiteLibrary = fromManifest(manifest, list);
				swf.name = zygame.utils.StringUtils.getName(_path);
				swf.load().onComplete(function(_):Void {
					swf.releaseZip();
					call(swf);
				}).onError(function(_):Void {
					errorCall("加载SWFLite文件失败");
				});
			}).onError(function(err:Dynamic):Void {
				errorCall("加载SWFLite文件失败");
			});
		} else {
			errorCall("非SWFLite文件");
		}
	}

	/**
	 * 加载，并返回AssetLibrary实例
	 * @param call
	 */
	public function load(call:SWFLiteLibrary->Void, errorCall:String->Void) {
		if (_isZip) {
			// 加载二进制文件
			AssetsUtils.loadBytes(_path, false).onComplete(function(bytes:Bytes):Void {
				onSwfliteParse(bytes, call, errorCall);
			}).onError(function(data:Dynamic):Void {
				errorCall(data);
			});
		} else {
			// 普通的bundle载入
			openfl.utils.AssetLibrary.loadFromFile(AssetsUtils.ofPath(_path), "").onComplete(function(library):Void {
				if (Std.isOfType(library, SWFLiteLibrary)) {
					cast(library, SWFLiteLibrary).name = zygame.utils.StringUtils.getName(_path);
					call(cast library);
				} else
					throw "SWF is not zygame.utils.load.SWFLiteLibrary classes!";
			}).onError(function(msg):Void {
				errorCall(msg);
			});
		}
	}

	/**
	 * 加载SWFLiteLibrary
	 * @param manifest
	 * @param list
	 * @return SWFLiteLibrary
	 */
	private function fromManifest(manifest:AssetManifest, list:List<Entry>):SWFLiteLibrary {
		if (manifest == null)
			return null;

		var library:SWFLiteLibrary = null;

		var libraryClass = Type.resolveClass(manifest.libraryType);

		if (libraryClass != null) {
			library = Type.createInstance(libraryClass, manifest.libraryArgs);
			library.zipList = list;
		} else {
			// trace ("[ZYGAME]SWFLiteLoader:Could not find library type: " + manifest.libraryType);
			return null;
		}

		library.__fromManifest(manifest);

		return library;
	}
}

#end
#end