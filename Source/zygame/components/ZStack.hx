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
			@:privateAccess style.onEntered = updateDisplay;
			@:privateAccess style.onExited = function() {
				style.parent.removeChild(style);
			}
			style.onEnter();
		}
		return value;
	}

	private function updateDisplay():Void {
		for (i in 0...this.numChildren) {
			var child = this.getChildAt(i);
			child.visible = child.name == currentId;
		}
	}
}

/**
 * 切换器的切换动画实现
 */
class ZStackAnimateStyle extends ZBox {
	/**
	 * 进入完成
	 */
	dynamic private function onEntered():Void {}

	/**
	 * 退出完成
	 */
	dynamic private function onExited():Void {}

	public function onEnter():Void {}
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

	override function onEnter() {
		super.onEnter();
		var time = 0;
		FrameEngine.create(function(f) {
			time++;
			if (time <= 30) {
				_quad.alpha = (time / 30).linear().lerp(0, 1);
				if (time == 30) {
					this.onEntered();
				}
			} else {
				_quad.alpha = ((time - 30) / 30).linear().lerp(1, 0);
				if (time == 60) {
					this.onExited();
					f.stop();
				}
			}
		});
	}
}
