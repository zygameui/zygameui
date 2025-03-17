package zygame.utils;

import haxe.io.Path;
#if sys
import sys.FileSystem;
import openfl.filesystem.File;
#end
#if sxk_game_sdk
import v4.NativeApi;
#end
import zygame.utils.load.AssetsZipLoader.Zip;
import openfl.utils.ByteArray;
import zygame.zip.ZipReader;
import haxe.zip.Entry;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.Event;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLLoader;

/**
 * 资源捆绑（测试性功能）
 * 在C++目标，会将所有资源解压到本地储存进行读取使用
 * 在HTML5目标，则会将资源储存到内存中进行读取使用
 * 注意：当前暂仅支持C++目标
 */
class AssetsBundle {
	private static var __bundle:AssetsBundle;

	public static function getInstance() {
		if (__bundle == null) {
			__bundle = new AssetsBundle();
		}
		return __bundle;
	}

	public function new() {}

	#if sys
	private function deleteDir(path:String):Void {
		if (FileSystem.exists(path)) {
			if (FileSystem.isDirectory(path)) {
				var files = FileSystem.readDirectory(path);
				for (file in files) {
					deleteDir(Path.join([path, file]));
				}
				FileSystem.deleteDirectory(path);
			} else {
				FileSystem.deleteFile(path);
			}
		}
	}
	#end

	/**
	 * 安装资源包
	 * @param url 
	 * @param cb 
	 */
	public function install(url:String, cb:AssetsBundleData->Void):Void {
		// 需要检查一下安装的资源是否已经准备好，避免重复安装
		#if sys
		var installedUrl = Lib.getData("assets_bundle_installed");
		if (installedUrl == url) {
			cb({
				code: OK,
				progress: 1
			});
			return;
		}
		var assetsPath = Path.join([File.applicationStorageDirectory.nativePath, "assets_bundle"]);
		var loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, (e) -> {
			// 加载完成
			#if sxk_game_sdk
			trace("File.applicationStorageDirectory.nativePath=", File.applicationStorageDirectory.nativePath);
			var savePath = Path.join([File.applicationStorageDirectory.nativePath, "assets_bundle.zip"]);
			if (!FileSystem.exists(savePath)) {
				FileSystem.createDirectory(Path.directory(savePath));
			}
			// 先将zip包储存起来
			sys.io.File.saveBytes(savePath, loader.data);
			// 删除已经存在的资源包
			deleteDir(assetsPath);
			// 然后再进行解压处理
			NativeApi.unzip(savePath, assetsPath, (code) -> {
				if (code == 0) {
					// 解压完成，应标记成功
					Lib.setData("assets_bundle_installed", url);
					trace("install success.");
					cb({
						code: OK,
						progress: 1
					});
				} else {
					// 解压失败
					cb({
						code: FAIL,
						progress: 0
					});
				}
			});
			#end
		});
		loader.addEventListener(ProgressEvent.PROGRESS, (e) -> {
			// 加载中
			trace("load progress", Math.round(e.bytesLoaded / e.bytesTotal * 100) + "%");
			cb({
				code: PROGRESS,
				progress: e.bytesLoaded / e.bytesTotal
			});
		});
		loader.addEventListener(IOErrorEvent.IO_ERROR, (e) -> {
			// 加载失败
			trace("load fail");
			cb({
				code: FAIL,
				progress: 0
			});
		});
		loader.load(new URLRequest(url));
		#else
		cb({
			code: FAIL,
			progress: 0
		});
		#end
	}

	/**
	 * 获得资源路径，如果存在则返回路径，如果不存在，则返回`null`
	 * @param file 
	 * @return Bool
	 */
	public function ofPath(file:String):String {
		#if sys
		var filePath = Path.join([File.applicationStorageDirectory.nativePath, "assets_bundle", file]);
		return FileSystem.exists(filePath) ? filePath : null;
		#else
		return null;
		#end
	}
}

typedef AssetsBundleData = {
	code:AssetsBundleCode,
	progress:Float
}

enum abstract AssetsBundleCode(Int) {
	var OK;
	var FAIL;
	var PROGRESS;
}
