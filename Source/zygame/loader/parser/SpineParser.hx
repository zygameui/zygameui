package zygame.loader.parser;

import zygame.utils.load.SpineTextureAtalsLoader.SpineTextureAtals;
import openfl.utils.Assets;
import zygame.utils.StringUtils;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;

/**
 * Spine资源载入器
 * {
 * imgs:[png,png,png], //支持Base64
 * atlas:纹理数据,
 * path:路径识别,
 * base64: false //如果为Base64，该值应为true
 * }
 */
@:keep
class SpineParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return true;
	}

	public var map:Map<String, BitmapData> = [];

	public var loadindex:Int = 0;

	override function process() {
		var array:Array<Dynamic> = getData().imgs;
		if (array.length > loadindex) {
			// 载入位图
			var img = array[loadindex];
			if (Std.is(img, String)) {
				// 路径载入
				AssetsUtils.loadBitmapData(img).onComplete(function(data):Void {
					map.set(StringUtils.getName(img), data);
					loadindex++;
					this.finalAssets(PROGRESS, null, loadindex / array.length * 0.9);
					this.contiune();
				}).onError(function(err) {
					sendError("Spine 无法加载：" + getData().path);
				});
			} else {
				// Base64位载入
				var base64:{path:String, base64data:String} = cast img;
				BitmapData.loadFromBase64(base64.base64data, "imgae/png").onComplete(function(data):Void {
					map.set(StringUtils.getName(base64.path), data);
					loadindex++;
					this.finalAssets(PROGRESS, null, loadindex / array.length * 0.9);
					this.contiune();
				}).onError(function(err) {
					sendError("Spine 无法加载Base64：" + getData().path);
				});
			}
		} else {
			// 开始载入纹理数据
			if (getData().base64) {
				var spine:SpineTextureAtals = new SpineTextureAtals(map, getData().atlas);
				spine.path = getData().path;
				this.finalAssets(SPINE, spine, 1);
				map = null;
			} else {
				Assets.loadText(getData().atlas).onComplete(function(data:String):Void {
					var spine:SpineTextureAtals = new SpineTextureAtals(map, data);
					spine.path = getData().path;
					this.finalAssets(SPINE, spine, 1);
					map = null;
				}).onError(sendError);
			}
		}
	}
}
