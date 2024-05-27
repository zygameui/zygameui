package zygame.components.data;

import openfl.geom.Matrix;
import openfl.display.DisplayObject;
import openfl.display.Tile;

/**
 * 构造UI时，会对UI的位置信息，进行换成，以便下一次构造UI时，直接使用缓存的数据
 * BATE 测试版本，该功能仍然存在许多不稳定性，暂不推荐使用
 */
class CacheBuilderData {
	/**
	 * 录制行为，当该值为`true`时，则在创建UI时，会记录UI的位置信息
	 */
	public var record:Bool = true;

	public function new() {}

	private var __matrix:Array<Matrix> = [];

	private var __index:Int = 0;

	/**
	 * 追加Matrix
	 * @param data 
	 */
	public function addMatrix(data:Dynamic):Void {
		if (data is DisplayObject) {
			var display:DisplayObject = cast data;
			__matrix.push(display.transform.matrix);
		} else if (data is Tile) {
			var tile:Tile = cast data;
			__matrix.push(tile.matrix);
		}
	}

	/**
	 * 应用Matrix
	 * @param display 
	 */
	public function applyMatrix(data:Dynamic):Void {
		var m = __matrix[__index];
		if (data is DisplayObject) {
			var display:DisplayObject = cast data;
			display.transform.matrix = m;
		} else if (data is Tile) {
			var tile:Tile = cast data;
			tile.matrix = m;
		}
		__index++;
	}

	/**
	 * 复制当前缓存数据
	 * @return CacheBuilderData
	 */
	public function copy():CacheBuilderData {
		var data = new CacheBuilderData();
		data.__matrix = this.__matrix.copy();
		data.__index = 0;
		data.record = this.record;
		return data;
	}
}
