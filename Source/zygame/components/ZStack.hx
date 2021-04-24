package zygame.components;

import openfl.events.Event;
import tweenxcore.Tools.Easing;
import zygame.utils.FrameEngine;
import openfl.display.DisplayObject;

using tweenxcore.Tools;

/**
 * 切换器
 */
class ZStack extends ZBox {
	public var stacks:Array<DisplayObject> = [];

	override function addChildAt(display:DisplayObject, index:Int):DisplayObject {
		display.visible = display.name == currentId;
		if (stacks.indexOf(display) == -1)
			stacks.push(display);
		if (display.visible) {
			this.removeChildren();
			currentSelect = display;
			return super.addChildAt(display, 0);
		}
		return display;
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
			this.dispatchEvent(new ZStackEvent(ZStackEvent.START));
			@:privateAccess style._onEntered = function() {
				updateDisplay();
				this.dispatchEvent(new ZStackEvent(ZStackEvent.ENTER));
			}
			@:privateAccess style._onExited = function() {
				if (style.parent != null)
					style.parent.removeChild(style);
				this.dispatchEvent(new ZStackEvent(ZStackEvent.EXITED));
			}
			var nextSelect = this.getChildByName(value);
			super.addChildAt(nextSelect, 0);
			if (nextSelect == null || currentSelect == nextSelect) {
				@:privateAccess style.enterEvent();
				@:privateAccess style.exitEvent();
			} else
				style.onEnter(currentSelect == null ? nextSelect : currentSelect, nextSelect);
		}
		return value;
	}

	override function getChildByName(name:String):DisplayObject {
		for (index => value in stacks) {
			if (value.name == name)
				return value;
		}
		return super.getChildByName(name);
	}

	private function updateDisplay():Void {
		for (i in 0...this.stacks.length) {
			var child = this.stacks[i];
			child.visible = child.name == currentId;
			if (child.visible) {
				this.addChild(child);
			}
		}
	}
}

/**
 * 切换器的切换动画实现
 */
class ZStackAnimateStyle extends ZBox {
	/**
	 * 持续时间，单位：秒
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
		_quad.alpha = 0;
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

class ZStackEvent extends Event {
	public static var EXITED:String = "exited";
	public static var ENTER:String = "enter";
	public static var START:String = "start";
}
