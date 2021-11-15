package zygame.display;

import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;

class ImageBitmap extends Bitmap {
	/**
	 * 当不允许使用getBounds时，则使用noBoundsRect
	 */
	// private static var noBoundsRect:Rectangle = new Rectangle();

	/**
	 * 如果设置boundsEnabled为false时，则getBounds永远获得0，0，0，0的值，默认为true
	 */
	// public var boundsEnabled:Bool = true;

	// @:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void {
	// 	if (!boundsEnabled) {
	// 		var bounds = @:privateAccess Rectangle.__pool.get();
	// 		bounds.setTo(0, 0, 0, 0);
	// 		@:privateAccess bounds.__transform(bounds, matrix);
	// 		@:privateAccess rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
	// 		@:privateAccess Rectangle.__pool.release(bounds);
	// 	} else
	// 		super.__getBounds(rect, matrix);
	// }
}
