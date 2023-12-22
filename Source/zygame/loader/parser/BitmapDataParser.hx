package zygame.loader.parser;

import openfl.display3D.Context3DTextureFormat;
import openfl.Lib;
import openfl.display3D.textures.Texture;
import openfl.display.BitmapData;
import zygame.utils.StringUtils;
import zygame.utils.AssetsUtils;

@:keep class BitmapDataParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".jpg") || StringTools.endsWith(data, ".jpeg") || StringTools.endsWith(data, ".png");
	}

	override function process() {
		AssetsUtils.loadBitmapData(getData()).onComplete(function(data) {
			this.finalAssets(BITMAP, data, 1);
		}).onError(function(err) {
			if (AssetsUtils.cleanCacheId(getData())) {
				// 可重试
				process();
			} else {
				this.sendError("无法加载：" + getData());
			}
		});
	}
}
