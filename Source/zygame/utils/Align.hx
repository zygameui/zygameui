package zygame.utils;

enum abstract Align(String) from String to String {
	public var LEFT:String = "left";
	public var RIGHT:String = "right";
	public var TOP:String = "top";
	public var BOTTOM:String = "bottom";
	public var CENTER:String = "center";
}

/**
 *  实现基本的对齐算法
 */
class AlignTools {
	/**
	 *  对齐算法
	 * @param display - 
	 * @param v - 
	 * @param h - 
	 */
	public static function alignDisplay(display:openfl.display.DisplayObject, v:Align, h:Align):Void {
		v = v == null ? CENTER : v;
		h = h == null ? CENTER : h;
		switch (v) {
			case TOP:
				display.y = 0;
			case BOTTOM:
				display.y = -display.height;
			case CENTER:
				display.y = -display.height * 0.5;
			default:
		}
		switch (h) {
			case LEFT:
				display.x = 0;
			case RIGHT:
				display.x = -display.width;
			case CENTER:
				display.x = -display.width * 0.5;
			default:
		}
	}
}
