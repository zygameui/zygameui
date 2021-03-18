package zygame.components;

import tweenxcore.Tools.Easing;
import zygame.utils.FrameEngine;
import openfl.display.DisplayObject;

using tweenxcore.Tools;

/**
 * 切换器
 */
class ZStack extends ZBox {
	override function addChildAt(display:DisplayObject, index:Int):DisplayObject {
		display.visible = display.name == currentId;
		if (display.visible)
			currentSelect = display;
		return super.addChildAt(display, index);
	}

	private var _id:String;

	/**
	 * 切换动画的样式实现
	 */
	public var style:ZStackAnimateStyle;

	/**
	 * 设置ID来显示对象，如果ID不存在，则不会显示任何内容
	 */
	public var currentId(get, set):String;

	/**
	 * 当前的显示对象
	 */
	public var currentSelect:DisplayObject;

	private function get_currentId():String {
		return _id;
	}

	private function set_currentId(value:String):String {
		_id = value;
		if (style == null)
			this.updateDisplay();
		else {
			// 使用过渡动画
			this.getTopView().addChild(style);
			@:privateAccess style._onEntered = updateDisplay;
			@:privateAccess style._onExited = function() {
				style.parent.removeChild(style);
			}
			var nextSelect = this.getChildByName(value);
			if (currentSelect == null || nextSelect == null || currentSelect == nextSelect) {
				@:privateAccess style.enterEvent();
				@:privateAccess style.exitEvent();
			} else
				style.onEnter(currentSelect, nextSelect);
		}
		return value;
	}

	private function updateDisplay():Void {
		for (i in 0...this.numChildren) {
			var child = this.getChildAt(i);
			child.visible = child.name == currentId;
			if (child.visible) {
				currentSelect = child;
			}
		}
	}
}

/**
 * 切换器的切换动画实现
 */
class ZStackAnimateStyle extends ZBox {
	/**
	 * 持续时间，单位：毫秒
	 */
	public var time:Float = 0.5;

	/**
	 * 内部方法：进入完成
	 */
	dynamic private function _onEntered():Void {}

	/**
	 * 内部方法：退出完成
	 */
	dynamic private function _onExited():Void {}

	/**
	 * 进入完成
	 */
	dynamic public function onEntered():Void {}

	/**
	 * 退出完成
	 */
	dynamic public function onExited():Void {}

	/**
	 * 进入动画
	 * @param currentDisplay 当前显示的对象
	 * @param nextDislay 下一个显示的对象
	 */
	public function onEnter(currentDisplay:DisplayObject, nextDislay:DisplayObject):Void {}

	private function enterEvent():Void {
		this.onEntered();
		this._onEntered();
	}

	private function exitEvent():Void {
		this.onExited();
		this._onExited();
	}
}

class DefalutZStackAnimateStyle extends ZStackAnimateStyle {
	private var _quad:ZQuad = new ZQuad();

	public function new() {
		super();
		this.width = this.getStageWidth();
		this.height = this.getStageHeight();
		this.addChild(_quad);
		_quad.width = this.width;
		_quad.height = this.height;
	}

	override function onEnter(currentDisplay:DisplayObject, nextDislay:DisplayObject) {
		super.onEnter(currentDisplay, nextDislay);
		var time = 0;
		FrameEngine.create(function(f) {
			time++;
			if (time <= 30) {
				_quad.alpha = (time / 30).linear().lerp(0, 1);
				if (time == 30) {
					this.enterEvent();
				}
			} else {
				_quad.alpha = ((time - 30) / 30).linear().lerp(1, 0);
				if (time == 60) {
					this.exitEvent();
					f.stop();
				}
			}
		});
	}
}
