package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;
import openfl.display.DisplayObject;

/**
 *  流水布局，需要指定ZBox的宽度或者高度，默认水平布局
 */
class FlowLayout extends BaseLayout {
	public static inline var HORIZONTAL:String = "horizontal";

	public static inline var VERTICAL:String = "vertical";

	public var direction:String = HORIZONTAL;

	public var width:Float = 0;

	public var height:Float = 0;

	/**
	 * 上下左右的间隔
	 */
	public var gap:Float = 0;

	/**
	 * 左右的间隔
	 */
	public var gapX:Float = 0;

	/**
	 * 上下的间隔
	 */
	public var gapY:Float = 0;

	/**
	 * 流动布局，需要指定宽高，如果不指定，则以ZBox的宽高处理
	 * @param width 
	 * @param height 
	 */
	public function new(width:Float = 0, height:Float = 0) {
		super();
		this.width = width;
		this.height = height;
	}

	override public function layout(box:ZBox):Void {
		if (direction == HORIZONTAL)
			layoutHorizontal(box);
		else
			layoutVertical(box);
	}

	private function layoutHorizontal(box:ZBox):Void {
		var ix:Float = 0;
		var max:Float = 0;
		var iy:Float = 0;
		var child:DisplayObject;
		var targetWidth = width == 0 ? box.width : width;
		for (i in 0...box.childs.length) {
			child = box.childs[i];
			if (ix + child.width > targetWidth) {
				// 超出界限，应该将当前对象进行换行处理
				ix = 0;
				iy += max + (gap + gapY);
				max = 0;
				child.x = ix;
				child.y = iy;
			} else {
				child.x = ix;
				child.y = iy;
			}
			ix += child.width + (gap + gapX);
			if (child.height > max)
				max = child.height;
		}
	}

	private function layoutVertical(box:ZBox):Void {
		var ix:Float = 0;
		var max:Float = 0;
		var iy:Float = 0;
		var child:DisplayObject;
		var targetHeight = height == 0 ? box.height : height;
		for (i in 0...box.childs.length) {
			child = box.childs[i];
			if (iy + child.height > targetHeight) {
				iy = 0;
				ix += max + (gap + gapX);
				max = 0;
				child.x = ix;
				child.y = iy;
			} else {
				child.x = ix;
				child.y = iy;
			}
			iy += child.height + (gap + gapY);
			if (child.width > max)
				max = child.width;
		}
	}
}
