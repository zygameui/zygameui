package zygame.loader.parser;

import zygame.utils.load.DynamicTextureLoader;

/**
 * 动态文本解析器
 */
 @:keep class DynamicTextureAtlasParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return true;
	}

	public function new(data:Dynamic) {
		super(data);
		loader = new DynamicTextureLoader(data);
	}

	/**
	 * 基础动态文本载入器
	 */
	public var loader:DynamicTextureLoader;

	override function process() {
		loader.updateProgress = function(f) {
			if (f != -1)
				this.finalAssets(AssetsType.PROGRESS, null, f);
		};
		loader.load(function(data) {
			this.finalAssets(AssetsType.DYNAMICTEXTUREATLAS, data, 1);
		}, sendError);
	}
}
