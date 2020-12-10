package zygame.loader.parser;

import zygame.utils.load.MapliveLoader;

@:keep class MapliveParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return true;
	}

	override function process() {
		var loader = new MapliveLoader(getData());
		loader.load(function(map) {
			this.finalAssets(MAPLIVE, map, 1);
		}, function(f) {
			if (f != 1)
				this.finalAssets(PROGRESS, null, f);
		}, sendError);
	}
}
