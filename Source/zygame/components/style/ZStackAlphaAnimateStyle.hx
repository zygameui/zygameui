package zygame.components.style;

import zygame.utils.FrameEngine;
import openfl.display.DisplayObject;
import zygame.components.ZStack.ZStackAnimateStyle;

using tweenxcore.Tools;

/**
 * 透明度渐变过渡效果
 */
class ZStackAlphaAnimateStyle extends ZStackAnimateStyle {
	override function onEnter(currentDisplay:DisplayObject, nextDislay:DisplayObject) {
		super.onEnter(currentDisplay, nextDislay);
		var nowY1 = currentDisplay.alpha;
		var endY2 = 0;
		var nowY2 = nextDislay.alpha;
		nextDislay.alpha = 0;
		var startY2 = 0;
		nextDislay.visible = true;
		var maxFrame = Std.int(time * 60);
		var maxFrame2 = Std.int(time * 60 * 0.5);
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
            if (nowFrame == maxFrame2)
                this.enterEvent();
			if (nowFrame > maxFrame2)
				nextDislay.alpha = ((nowFrame - maxFrame2) / maxFrame2).linear().lerp(startY2, nowY2);
			else
				currentDisplay.alpha = (nowFrame / maxFrame2).linear().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.alpha = nowY1;
                this.exitEvent();
			}
		});
	}
}
