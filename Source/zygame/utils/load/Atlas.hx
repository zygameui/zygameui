package zygame.utils.load;

import openfl.display.Tileset;
import openfl.display.BitmapData;

/**
 * 精灵图渲染基类，提供给ImageBatchs获取Tileset使用
 */
class Atlas {
	/**
	 * 是否为文本缓存精灵表
	 */
	public var isTextAtlas:Bool = false;

	private var __tileset:Tileset;

	public var rootBitmapData(get, set):BitmapData;

	private function get_rootBitmapData():BitmapData {
		return getRootBitmapData();
	}

	private function set_rootBitmapData(bitmapData:BitmapData):BitmapData {
		if (__tileset != null) {
			__tileset.bitmapData = bitmapData;
		}
		return bitmapData;
	}

	public function new(tileset:Tileset) {
		this.__tileset = tileset;
	}

	public function getTileset():openfl.display.Tileset {
		return __tileset;
	}

	public function getRootBitmapData():BitmapData {
		return __tileset.bitmapData;
	}
}
