package zygame.loader.parser;

import zygame.utils.ZLog;
import haxe.Exception;
import zygame.utils.AssetsUtils;

@:keep
class XMLParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".xml");
	}

	override function process() {
		if (getAssets().existZipAssets(getName(), "xml")) {
			this.finalAssets(XML, @:privateAccess getAssets().getZipXml(getName()), 1);
			return;
		}
		AssetsUtils.loadText(getData()).onComplete(function(text) {
			try {
				this.finalAssets(XML, Xml.parse(text), 1);
			} catch (e:Exception) {
				// 无效XML配置
				ZLog.exception(e);
				this.sendError("无法加载：" + getData());
			}
		}).onError(function(err) {
			this.sendError("无法加载：" + getData());
		});
	}
}
