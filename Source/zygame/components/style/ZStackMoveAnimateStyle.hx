package zygame.components.style;

import zygame.utils.FrameEngine;
import openfl.display.DisplayObject;
import zygame.components.ZStack.ZStackAnimateStyle;

using tweenxcore.Tools;

/**
 * 页面切换器，屏幕式上下滑动、左右滑动切换效果。
 */
class ZStackMoveAnimateStyle extends ZStackAnimateStyle {
    
	/**
	 * 持续时间，单位：毫秒
	 */
	public var time:Float = 0.5;

	override function onEnter(currentDisplay:DisplayObject, nextDislay:DisplayObject) {
		super.onEnter(currentDisplay, nextDislay);
        if(currentDisplay == null || nextDislay == null)
        {
            this.onEntered();
            return;
        }
		moveBottomYtoUp(currentDisplay, nextDislay);
	}

	/**
	 * 由底部上升
	 */
	public function moveBottomYtoUp(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {
		var nowY1 = currentDisplay.y;
		var endY2 = currentDisplay.y - getStageHeight();
		var nowY2 = nextDislay.y;
		nextDislay.y += getStageHeight();
		var startY2 = nextDislay.y;
		nextDislay.visible = true;
		var maxFrame = time * 60;
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
			nextDislay.y = (nowFrame / maxFrame).linear().lerp(startY2, nowY2);
			currentDisplay.y = (nowFrame / maxFrame).linear().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.y = nowY1;
                this.onEntered();
			}
		});
	}
}
