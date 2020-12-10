package zygame.loader.parser;

import haxe.Json;
import zygame.utils.AssetsUtils;

@:keep
class JSONParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".json");
	}

	override function process() {
		if (getAssets().existZipAssets(getName(), "json")) {
			this.finalAssets(JSON, @:privateAccess getAssets().getZipJson(getName()), 1);
			return;
		}
		AssetsUtils.loadText(getData()).onComplete(function(text) {
			this.finalAssets(JSON, Json.parse(text), 1);
		}).onError(function(err) {
			this.sendError("无法加载：" + getData());
		});
	}
}
