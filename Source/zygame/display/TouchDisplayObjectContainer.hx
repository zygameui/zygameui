package zygame.display;

import zygame.core.Start;
import zygame.utils.Lib;
import zygame.display.DisplayObjectContainer;
import openfl.events.TouchEvent;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import openfl.events.MouseEvent;
import openfl.events.Event;

@:access(openfl.events.TouchEvent)
class TouchDisplayObjectContainer extends DisplayObjectContainer {
	public var isTouch:Bool = false;

	/**
	 * 默认触摸为鼠标触摸
	 */
	public var mouseEvent:Bool = true;

	public function new() {
		super();
	}

	/**
	 *  设置触摸事件
	 * @param listen - 是否侦听，false则清理所有事件
	 */
	public function setTouchEvent(listen:Bool, userCapture:Bool = false, priority:Int = 0, stageMove:Bool = false):Void {
		if (isTouch == listen)
			return;
		isTouch = listen;
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		if (listen) {
			#if (mac || window || ios)
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, userCapture, priority);
			// openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (stageMove)
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, userCapture, priority);
			else
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, userCapture, priority);
			this.addEventListener(MouseEvent.MOUSE_OUT, onTouchOut, userCapture, priority);
			this.addEventListener(MouseEvent.MOUSE_OVER, onTouchOver, userCapture, priority);
			#else
			if (mouseEvent) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, userCapture, priority);
				// openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				if (stageMove)
					openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, userCapture, priority);
				else
					this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, userCapture, priority);
				this.addEventListener(MouseEvent.MOUSE_OUT, onTouchOut, userCapture, priority);
				this.addEventListener(MouseEvent.MOUSE_OVER, onTouchOver, userCapture, priority);
			} else {
				this.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				// openfl.Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				this.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			}
			#end
			Start.current.addToMouseTouchEvents(this);
		} else {
			#if (mac || window || ios)
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			// openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (stageMove)
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			else
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onTouchOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onTouchOver);
			#else
			if (mouseEvent) {
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				// openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				if (stageMove)
					openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				else
					this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onTouchOut);
				this.removeEventListener(MouseEvent.MOUSE_OVER, onTouchOver);
			} else {
				this.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				// openfl.Lib.current.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				this.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			}
			#end
			Start.current.removeToMouseTouchEvents(this);
		}
	}

	public function onMouseDown(e:MouseEvent):Void {
		var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN, false, false, 0, false, e.localX, e.localY, 0, 0, 0);
		event.stageX = e.stageX;
		event.stageY = e.stageY;
		#if (html5 || cpp || hl)
		event.target = e.target;
		event.currentTarget = e.currentTarget;
		#end
		onTouchBegin(event);
	}

	public function onMouseMove(e:MouseEvent):Void {
		var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, false, false, 0, false, e.localX, e.localY, 0, 0, 0);
		event.stageX = e.stageX;
		event.stageY = e.stageY;
		#if (html5 || cpp || hl)
		event.target = e.target;
		event.currentTarget = e.currentTarget;
		#end
		onTouchMove(event);
	}

	public function onMouseUp(e:MouseEvent):Void {
		var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_END, false, false, 0, false, e.localX, e.localY, 0, 0, 0);
		event.stageX = e.stageX;
		event.stageY = e.stageY;
		#if (html5 || cpp || hl)
		event.target = e.target;
		event.currentTarget = e.currentTarget;
		#end
		onTouchEnd(event);
	}

	public function onTouchBegin(e:TouchEvent):Void {
		if (baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onTouchBegin");
			if (call != null)
				call([e]);
		}
	}

	public function onTouchEnd(e:TouchEvent):Void {
		if (baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onTouchEnd");
			if (call != null)
				call([e]);
		}
	}

	public function onTouchMove(e:TouchEvent):Void {
		if (baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onTouchMove");
			if (call != null)
				call([e]);
		}
	}

	public function onTouchOut(e:MouseEvent):Void {}

	public function onTouchOver(e:MouseEvent):Void {}

	override public function onInitEvent(e:Event):Void {
		super.onInitEvent(e);
	}

	private var __lastTouch:Bool = false;

	override function onAddToStage() {
		super.onAddToStage();
		setTouchEvent(__lastTouch);
	}

	override public function onRemoveEvent(e:Event):Void {
		super.onRemoveEvent(e);
		__lastTouch = isTouch;
		setTouchEvent(false);
	}
}
