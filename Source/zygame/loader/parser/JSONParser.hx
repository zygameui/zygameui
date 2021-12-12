package zygame.loader.parser;

import haxe.Exception;
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
			try {
				this.finalAssets(JSON, Json.parse(text), 1);
			} catch (e:Exception) {
				trace("错误信息：", e.message);
				trace("错误内容：", text);
				throw "无法正常解析" + getName() + ".json";
			}
		}).onError(function(err) {
			this.sendError("无法加载：" + getData());
		});
	}
}
