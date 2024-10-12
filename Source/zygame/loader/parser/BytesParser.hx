package zygame.loader.parser;

import zygame.utils.AssetsUtils;

/**
 * 二进制数据加载
 */
class BytesParser extends ParserBase {
	/**
	 * 支持格式
	 * @param data 
	 * @return Bool
	 */
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".skel");
	}

	override function process() {
		AssetsUtils.loadBytes(getData()).onComplete(bytes -> {
			this.finalAssets(AssetsType.BYTES, bytes, 1);
		}).onError(sendError);
	}
}
