package zygame.display;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;

/**
 * 兼容ScrollRect正确的尺寸的Bitmap对象
 */
@:access(oepnfl.display.Bitmap)
@:access(openfl.geom.Rectangle)
class ZBitmap extends Bitmap {
	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void {
		var bounds = Rectangle.__pool.get();
		// zygameui 需要兼容scrollRect的宽高
		if (__scrollRect != null) {
			bounds.setTo(0, 0, __scrollRect.width, __scrollRect.height);
		} else if (__bitmapData != null) {
			bounds.setTo(0, 0, __bitmapData.width, __bitmapData.height);
		} else {
			bounds.setTo(0, 0, 0, 0);
		}

		bounds.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}

	@:noCompletion private override function set_height(value:Float):Float {
		if (__bitmapData != null) {
			if (__scrollRect != null)
				scaleY = value / __scrollRect.height;
			else
				scaleY = value / __bitmapData.height; // get_height();
		} else {
			scaleY = 0;
		}
		return value;
	}

	@:noCompletion private override function set_width(value:Float):Float {
		if (__bitmapData != null) {
			if (__scrollRect != null)
				scaleX = value / __scrollRect.width;
			else
				scaleX = value / __bitmapData.width; // get_width();
		} else {
			scaleX = 0;
		}
		return value;
	}
}
