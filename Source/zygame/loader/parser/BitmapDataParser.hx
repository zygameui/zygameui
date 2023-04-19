package zygame.loader.parser;

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
			this.sendError("无法加载：" + getData());
		});
	}
}
