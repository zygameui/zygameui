package zygame.loader.parser;

import zygame.utils.load.AssetsZipLoader;

/**
 * ZIP包资源解析处理
 */
@:keep
class ZIPAssetsParser extends ParserBase {
    
    public static function supportType(data:Dynamic):Bool {
		return data.indexOf(".zip") != -1;
    }
    
    public var loader:AssetsZipLoader;

    public function new(data:Dynamic) {
        super(data);
        loader = new AssetsZipLoader(data);
    }

    /**
	 * 开始载入音频
	 */
	override function process() {
        loader.load(function(data){
            this.finalAssets(AssetsType.ZIP,data,1);
        },sendError);
    }

}