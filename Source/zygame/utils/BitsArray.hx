package zygame.utils;

import haxe.io.Bytes;

/**
 * 仅存在0和1的二进制数组，000101010101001010
 */
class BitsArray {
	public var bytes:Bytes;

	public function new(length:Int) {
		bytes = Bytes.alloc(length);
	}

	public function set(pos:Int, b:Bool):Void {
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
	 * @param x 坐标x
	 * @param y 坐标y
	 * @return Bool 布尔值
	 */
	public function get(pos:Int):Bool {
		var offest = pos % 8;
		pos = Math.floor(pos / 8);
		var v = (bytes.get(pos) >> offest & 1);
		return v == 1;
	}
}
