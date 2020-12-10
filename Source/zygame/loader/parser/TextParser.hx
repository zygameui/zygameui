package zygame.loader.parser;

import zygame.utils.AssetsUtils;
@:keep
class TextParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".txt") || StringTools.endsWith(data, ".hx");
	}

	override function process() {
		AssetsUtils.loadText(getData()).onComplete(function(text) {
			this.finalAssets(TEXT, text, 1);
		}).onError(function(err) {
			this.sendError("无法加载：" + getData());
		});
	}
}
