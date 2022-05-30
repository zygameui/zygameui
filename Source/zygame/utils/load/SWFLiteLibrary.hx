package zygame.utils.load;

#if (openfl_swf && swf)

import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import haxe.zip.Entry;
#if (openfl >= '9.0.0')
// import openfl._internal.symbols.BitmapSymbol;
// import openfl._internal.symbols.TextSymbol;
// import openfl._internal.symbols.SpriteSymbol;
// import openfl._internal.symbols.StaticTextSymbol;
// import openfl._internal.formats.swf.SWFLite;
// import openfl._internal.formats.swf.SWFLiteLibrary;
// import openfl._internal.formats.swf.FilterType;
// import openfl._internal.formats.swf.ShapeCommand;
// import openfl._internal.formats.swf.SWFLibrary;
// import openfl._internal.symbols.SWFSymbol;
// import openfl._internal.symbols.FontSymbol;
// import openfl._internal.symbols.ShapeSymbol;
// import openfl._internal.symbols.ButtonSymbol;
// import openfl._internal.symbols.DynamicTextSymbol;
// import openfl._internal.symbols.BitmapSymbol;
import swf.exporters.swflite.BitmapSymbol;
import swf.exporters.swflite.SWFLite;
// import openfl._internal.symbols.timeline.Frame;
// import openfl._internal.symbols.timeline.FrameObject;
// import openfl._internal.symbols.timeline.FrameObjectType;
// import openfl._internal.symbols.timeline.SymbolTimeline;
#else
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.formats.swf.SWFLite;
#end
import openfl.utils.Assets;
import zygame.utils.AssetsUtils;
import haxe.io.Bytes;
import lime._internal.format.Deflate;

#if (openfl > '9.0.0')
class SWFLiteLibrary extends swf.exporters.swflite.SWFLiteLibrary{

}
#else
@:keep
class SWFLiteLibrary extends #if (openfl <= '8.3.0') openfl._internal.swf.SWFLiteLibrary #elseif (openfl >= '9.0.0') swf.exporters.swflite.SWFLiteLibrary #else openfl._internal.formats.swf.SWFLiteLibrary #end {
	/**
	 * SWF文件名
	 */
	public var name:String;

	/**
	 * 已经解析好的ZIPList列表
	 */
	public var zipList:List<Entry>;

	override public function load():Future<lime.utils.AssetLibrary> {
		if (zipList == null) {
			return super.load();
		}

		if (id != null) {
			preload.set(id, true);
		}

		var promise = new Promise<lime.utils.AssetLibrary>();
		preloading = true;
	
		var onComplete = function(data) {
			cachedText.set(id, data);

			swf = SWFLite.unserialize(data);
			swf.library = this;

			var bitmapSymbol:BitmapSymbol;

			for (symbol in swf.symbols) {
				if (Std.isOfType(symbol, BitmapSymbol)) {
					bitmapSymbol = cast symbol;

					if (bitmapSymbol.className != null) {
						imageClassNames.set(bitmapSymbol.className, bitmapSymbol.path);
					}
				}
			}

			SWFLite.instances.set(instanceID, swf);

			__load().onProgress(promise.progress).onError(promise.error).onComplete(function(_) {
				preloading = false;
				promise.complete(this);
			});
		}

		if (Assets.exists(id)) {
			#if (js && html5)
			for (id in paths.keys()) {
				preload.set(id, true);
			}
			#end

			loadText(id).onError(promise.error).onComplete(onComplete);
		} else {
			for (id in paths.keys()) {
				preload.set(id, true);
			}

			var path = null;

			if (paths.exists(id)) {
				path = paths.get(id);
			} else {
				path = (rootPath != null && rootPath != "") ? rootPath + "/" + id : id;
			}

			var binPath:String = StringUtils.getName(path);
			var entry:Entry = AssetsUtils.findZipData(zipList, binPath);
			var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
			onComplete(bytes.toString());
		}

		return promise.future;
	}

	override public function loadText(id:String):Future<String> {
		if (zipList == null) {
			return super.loadText(id);
		}
		var entry:Entry = AssetsUtils.findZipData(zipList, id);
		var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
		return Future.withValue(bytes.toString());
	}

	override public function loadImage(id:String):Future<Image> {
		if (zipList == null) {
			return super.loadImage(id);
		}
		var entry:Entry = AssetsUtils.findZipData(zipList, id);
		var bytes:Bytes = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
		return Image.loadFromBytes(bytes);
	}

	/**
	 * 载入逻辑重写
	 * @param id 图片ID
	 * @return Future<Image>
	 */
	override private function __loadImage(id:String):Future<Image> {
		if (zipList == null) {
			return super.__loadImage(id);
		}
		return super.loadImage(id);
	}

	/**
	 * 释放ZIP资源
	 */
	public function releaseZip():Void {
		if (zipList != null) {
			zipList.clear();
			zipList = null;
		}
	}

	/**
	 * 释放unload
	 */
	override public function unload():Void {
		super.unload();
		var images:Map<String, Image> = cachedImages;
		var iter:Iterator<String> = images.keys();
		while (iter.hasNext()) {
			var key:String = iter.next();
			var img:Image = images.get(key);
			images.remove(key);
		}
		cachedImages = null;
	}
}

#end
#end