package zygame.utils.load;

/**
 * 基础帧
 */
@:keep
class BaseFrame {
	/**
	 * 瓦片ID
	 */
	public var id:Int = -1;

	public var width:Float;

	public var height:Float;

	public var x:Float = 0;

	public var y:Float = 0;

	public var parent:Atlas;

	public function new(parent:Atlas) {
		this.parent = parent;
	}

	public function toString():String {
		return "BaseFrame[id=" + id + ", x=" + x + ", y=" + y + ", width=" + width + ", height=" + height + "]";
	}
}
