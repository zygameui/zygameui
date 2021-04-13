package zygame.loader.parser;

import zygame.utils.load.SWFLiteLoader;

#if (openfl_swf)

/**
 * SWF载入解析器
 */
@:keep
class SWFParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return data.indexOf(".zip") != -1 || data.indexOf(".bundle") != -1;
	}

	override function process() {
		var swf = new SWFLiteLoader(getData().path, null, getData().zip);
		swf.load(function(swflite) {
			finalAssets(AssetsType.SWF, swflite, 1);
		}, sendError);
	}
}

#end