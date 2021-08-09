package zygame.utils;

import openfl.display.DisplayObjectContainer;

/**
 * 剔除渲染工具，检测屏幕外的对象不进行渲染
 */
@:access(openfl.display.DisplayObject)
class CullingRenderUtils {
	/**
	 * 屏幕外进行剔除处理
	 * @param display 
	 */
	public static function culling(display:DisplayObjectContainer):Void {
		// for (i in 0...display.numChildren) {
		// 	var child = display.getChildAt(i);
		// 	if (child.x > 100)
		// 		child.visible = false;
		// }
	}
}
