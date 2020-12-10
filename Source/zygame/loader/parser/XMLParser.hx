package zygame.loader.parser;

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
			this.finalAssets(XML, Xml.parse(text), 1);
		}).onError(function(err) {
			this.sendError("无法加载：" + getData());
		});
	}
}
