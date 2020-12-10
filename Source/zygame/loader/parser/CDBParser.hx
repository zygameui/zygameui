package zygame.loader.parser;

import zygame.utils.load.CDBLoader;

@:keep class CDBParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".cdb");
	}

	override function process() {
		var cdbLoader:CDBLoader = new CDBLoader(getData());
		cdbLoader.load(function(path, data) {
			this.finalAssets(CDB, data, 1);
		}, sendError);
	}
}
