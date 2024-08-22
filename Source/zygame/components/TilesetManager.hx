package zygame.components;

import zygame.utils.load.TextureLoader.TextureAtlas;
import openfl.display.BitmapData;

/**
 * 位图Tileset管理器
 */
class TilesetManager {
	private static var __tilesets:Map<BitmapData, TextureAtlas> = [];

	/**
	 * 根据BitmapData获得Tileset
	 * @param bitmapData 
	 * @return Tileset
	 */
	public static function getTextureAtlasByBitmapData(bitmapData:BitmapData):TextureAtlas {
		if (__tilesets.exists(bitmapData)) {
			return __tilesets.get(bitmapData);
		}
		var tileset = TextureAtlas.createTextureAtlasByOne(bitmapData);
		__tilesets.set(bitmapData, tileset);
		return tileset;
	}

	/**
	 * 根据BitmapData销毁Tileset
	 * @param bitmapData 
	 */
	public static function diposeBitmapData(bitmapData:BitmapData):Void {
		if (__tilesets.exists(bitmapData)) {
			__tilesets.remove(bitmapData);
		}
	}
}
