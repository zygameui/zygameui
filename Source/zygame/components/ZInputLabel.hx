package zygame.components;

import openfl.geom.Rectangle;
import openfl.display.DisplayObject;
import zygame.components.ZLabel;

/**
 * 输入组件
 */
class ZInputLabel extends ZLabel {
	/**
	 * 输入背景
	 */
	private var zquadbg:ZQuad;

	override function set_width(value:Float):Float {
		if (zquadbg != null)
			zquadbg.width = value;
		return super.set_width(value);
	}

	override function set_height(value:Float):Float {
		if (zquadbg != null)
			zquadbg.height = value;
		return super.set_height(value);
	}

	override public function onInit():Void {
		super.onInit();
		this.setWordWrap(false);
		this.setIsInput(true);
		zquadbg = new ZQuad();
		this.addChildAt(zquadbg, 0);
		zquadbg.width = this.width;
		zquadbg.height = this.height;
		zquadbg.alpha = 0;
	}

	#if !cpp
	/**
	 * 重构触摸事件，无法触发触摸的问题
	 * @param x
	 * @param y
	 * @param shapeFlag
	 * @param stack
	 * @param interactiveOnly
	 * @param hitObject
	 * @return Bool
	 */
	override private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		if (this.mouseEnabled == false || this.visible == false)
			return false;
		__point.x = 0;
		__point.y = 0;
		__point = this.localToGlobal(__point);
		var rect:Rectangle = new Rectangle(__point.x, __point.y);
		__point.x = this._width;
		__point.y = this._height;
		__point = this.localToGlobal(__point);
		rect.width = __point.x - rect.x;
		rect.height = __point.y - rect.y;
		if (rect.contains(x, y)) {
			if (stack != null) {
				stack.push(this._display);
				stack.push(this);
			}
			return true;
		}
		return false;
	}
	#end
}
