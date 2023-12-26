package zygame.utils;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
 * 二进制地图数据，每个点位仅使用0/1表示，可以非常节约性能和内存
 */
class BitsMap {
	/**
	 * 二进制
	 */
	public var bytes:Bytes;

	/**
	 * 宽度
	 */
	public var width:Int = 0;

	/**
	 * 高度
	 */
	public var height:Int = 0;

	/**
	 * 构造一个二进制地图数据，具有宽度和高度
	 * @param width 宽度
	 * @param height 高度
	 */
	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		var size = width * height;
		bytes = Bytes.alloc(Std.int(size / 8));
	}

	/**
	 * 设置坐标数据
	 * @param x 坐标x
	 * @param y 坐标y
	 * @param b 布尔值
	 */
	public function set(x:Int, y:Int, b:Bool):Void {
		var pos = x + y * width;
		var offest = pos % 8;
		pos = Math.floor(pos / 8);
		var c = bytes.get(pos);
		if (b) {
			c = c | 1 << offest;
		} else {
			c = c & 0 << offest;
		}
		bytes.set(pos, c);
	}

	/**
	 * 获得坐标数据
	 * @param x 坐标x
	 * @param y 坐标y
	 * @return Bool 布尔值
	 */
	public function get(x:Int, y:Int):Bool {
		var pos = x + y * width;
		var offest = pos % 8;
		pos = Math.floor(pos / 8);
		var v = (bytes.get(pos) >> offest & 1);
		return v == 1;
	}
}
