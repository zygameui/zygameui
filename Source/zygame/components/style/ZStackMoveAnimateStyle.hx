package zygame.components.style;

import openfl.geom.Rectangle;
import zygame.utils.FrameEngine;
import openfl.display.DisplayObject;
import zygame.components.ZStack.ZStackAnimateStyle;

using tweenxcore.Tools;

enum ZStackMoveAnimateStyleType {
	BOTTOM_UP;
	RIGHT_LEFT;
	LEFT_RIGHT;
	DOWN;
}

/**
 * 页面切换器，屏幕式上下滑动、左右滑动切换效果。
 */
class ZStackMoveAnimateStyle extends ZStackAnimateStyle {
	public var type:ZStackMoveAnimateStyleType = ZStackMoveAnimateStyleType.BOTTOM_UP;

	public function new(type:ZStackMoveAnimateStyleType = null) {
		super();
		if (type != null)
			this.type = type;
	}

	override function onEnter(currentDisplay:DisplayObject, nextDislay:DisplayObject) {
		super.onEnter(currentDisplay, nextDislay);
		switch (type) {
			case DOWN:
				moveDown(currentDisplay, nextDislay);
			case ZStackMoveAnimateStyleType.BOTTOM_UP:
				moveBottomYtoUp(currentDisplay, nextDislay);
			case ZStackMoveAnimateStyleType.RIGHT_LEFT:
				moveRightToLeft(currentDisplay, nextDislay);
			case ZStackMoveAnimateStyleType.LEFT_RIGHT:
				moveLeftToRight(currentDisplay, nextDislay);
		}
	}

	/**
	 * 由右边往左边
	 */
	 public function moveLeftToRight(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {
		currentDisplay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		nextDislay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		var nowY1 = currentDisplay.x;
		var endY2 = currentDisplay.x + getStageWidth();
		var nowY2 = nextDislay.x;
		nextDislay.x -= getStageWidth();
		var startY2 = nextDislay.x;
		nextDislay.visible = true;
		var maxFrame = Std.int(time * 60);
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
			nextDislay.x = (nowFrame / maxFrame).quintInOut().lerp(startY2, nowY2);
			currentDisplay.x = (nowFrame / maxFrame).quintInOut().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.x = nowY1;
				this.enterEvent();
				this.exitEvent();
				currentDisplay.scrollRect = null;
				nextDislay.scrollRect = null;
			}
		});
	}

	/**
	 * 由右边往左边
	 */
	public function moveRightToLeft(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {
		currentDisplay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		nextDislay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		var nowY1 = currentDisplay.x;
		var endY2 = currentDisplay.x - getStageWidth();
		var nowY2 = nextDislay.x;
		nextDislay.x += getStageWidth();
		var startY2 = nextDislay.x;
		nextDislay.visible = true;
		var maxFrame = Std.int(time * 60);
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
			nextDislay.x = (nowFrame / maxFrame).quintInOut().lerp(startY2, nowY2);
			currentDisplay.x = (nowFrame / maxFrame).quintInOut().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.x = nowY1;
				this.enterEvent();
				this.exitEvent();
				currentDisplay.scrollRect = null;
				nextDislay.scrollRect = null;
			}
		});
	}

	/**
	 * 由底部上升
	 */
	public function moveBottomYtoUp(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {
		currentDisplay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		nextDislay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		var nowY1 = currentDisplay.y;
		var endY2 = currentDisplay.y - getStageHeight();
		var nowY2 = nextDislay.y;
		nextDislay.y += getStageHeight();
		var startY2 = nextDislay.y;
		nextDislay.visible = true;
		var maxFrame = Std.int(time * 60);
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
			nextDislay.y = (nowFrame / maxFrame).quintInOut().lerp(startY2, nowY2);
			currentDisplay.y = (nowFrame / maxFrame).quintInOut().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.y = nowY1;
				this.enterEvent();
				this.exitEvent();
				currentDisplay.scrollRect = null;
				nextDislay.scrollRect = null;
			}
		});
	}

	/**
	 * 下移
	 */
	public function moveDown(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {
		currentDisplay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		nextDislay.scrollRect = new Rectangle(0, 0, getStageWidth(), getStageHeight());
		var nowY1 = currentDisplay.y;
		var endY2 = currentDisplay.y + getStageHeight();
		var nowY2 = nextDislay.y;
		nextDislay.y += 0;
		var startY2 = nextDislay.y;
		nextDislay.visible = true;
		var maxFrame = Std.int(time * 60);
		var nowFrame = 0;
		FrameEngine.create(function(f) {
			nowFrame++;
			nextDislay.y = (nowFrame / maxFrame).quintInOut().lerp(startY2, nowY2);
			currentDisplay.y = (nowFrame / maxFrame).quintInOut().lerp(nowY1, endY2);
			if (nowFrame == maxFrame) {
				f.stop();
				currentDisplay.visible = false;
				currentDisplay.y = nowY1;
				this.enterEvent();
				this.exitEvent();
				currentDisplay.scrollRect = null;
				nextDislay.scrollRect = null;
			}
		});
	}
}
