package zygame.display.batch;

import openfl.events.Event;
import openfl.events.EventType;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import zygame.components.ZBuilder.Builder;
import openfl.display.Tile;
import zygame.core.Start;
import zygame.core.Refresher;
import openfl.display.TileContainer;
import zygame.display.batch.ITileDisplayObject;

class BDisplayObjectContainer extends TileContainer implements ITileDisplayObject implements Refresher implements zygame.mini.MiniExtend
		implements IEventDispatcher {
	/**
	 * 自定义绑定数据
	 */
	public var customData:Dynamic;

	/**
	 * 基础生成baseBuilder，该属性只有通过MiniEngine创建时生效。
	 */
	public var baseBuilder:Builder;

	public var mouseEnabled:Bool = true;

	public var name:String = null;

	/**
	 * 事件回传事件
	 */
	private var __listener:EventDispatcher;

	public function new():Void {
		super();
	}

	public function onInit():Void {
		if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onInit");
			if (call != null)
				call();
		}
	}

	public function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (__listener == null)
			__listener = new EventDispatcher(this);
		__listener.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void {
		if (__listener != null)
			__listener.removeEventListener(type, listener, useCapture);
	}

	public function dispatchEvent(event:Event):Bool {
		if (__listener != null)
			return __listener.dispatchEvent(event);
		return false;
	}

	public function hasEventListener(type:String):Bool {
		if (__listener != null)
			return __listener.hasEventListener(type);
		return false;
	}

	public function willTrigger(type:String):Bool {
		if (__listener != null)
			return __listener.willTrigger(type);
		return false;
	}

	public function onFrame() {
		if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onFrame");
			if (call != null)
				call();
		}
	}

	public function setFrameEvent(isFrame:Bool):Void {
		if (isFrame)
			Start.current.addToUpdate(this);
		else
			Start.current.removeToUpdate(this);
	}

	/**
	 * 获取实际宽度（原图尺寸，旋转不计算）
	 */
	public var curWidth(get, never):Float;

	private function get_curWidth():Float {
		return this.width;
	}

	/**
	 * 获取实际高度（原图尺寸，旋转不计算）
	 */
	public var curHeight(get, never):Float;

	private function get_curHeight():Float {
		return this.height;
	}

	public function toString():String {
		return Type.getClassName(Type.getClass(this));
	}

	/**
	 * 添加对象到最上层
	 * @param display
	 */
	public function addChild(display:Tile):Void {
		this.addChildAt(display, this.numTiles);
	}

	/**
	 * 添加对象到最上层
	 * @param display
	 */
	public function addChildAt(display:Tile, index:Int):Void {
		super.addTileAt(display, index);
		if (Std.isOfType(display, BDisplayObjectContainer)) {
			cast(display, BDisplayObjectContainer).onInit();
		} else if (Std.isOfType(display, BDisplayObject)) {
			cast(display, BDisplayObject).onInit();
		} else if (Std.isOfType(display, BSprite))
			cast(display, BSprite).onInit();
	}

	public function removeChild(display:Tile):Void {
		super.removeTile(display);
	}

	/**
	 *  经过了缩放计算的舞台宽度
	 *  @return Float
	 */
	public function getStageWidth():Float {
		return zygame.core.Start.stageWidth;
	}

	/**
	 *  经过了缩放计算的舞台高度
	 *  @return Float
	 */
	public function getStageHeight():Float {
		return zygame.core.Start.stageHeight;
	}

	/**
	 * 获取父节点
	 * @return BDisplayObjectContainer
	 */
	public function getParent():BDisplayObjectContainer {
		return cast this.parent;
	}
}
