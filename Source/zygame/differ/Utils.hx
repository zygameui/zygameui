package zygame.differ;

import differ.shapes.Shape;
import differ.shapes.Polygon;
import openfl.geom.Rectangle;

/**
 * Differ工具集合
 */
class Utils {
	/**
	 * 计算Shape的宽高Rect
	 * @param shape 图形
	 * @return Rectangle
	 */
	public static function getRect(shape:Shape):Rectangle {
		if (shape == null)
			return null;
		if (Std.isOfType(shape, Polygon)) {
			var polygon:Polygon = cast shape;
			var minX:Float = 9999;
			var minY:Float = 9999;
			var maxX:Float = -9999;
			var maxY:Float = -9999;
			if (polygon.transformedVertices != null) {
				for (index => value in polygon.transformedVertices) {
					minX = Math.min(minX, value.x);
					minY = Math.min(minY, value.y);
					maxX = Math.max(maxX, value.x);
					maxY = Math.max(maxY, value.y);
				}
			} else
				return null;
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		return null;
	}
}
