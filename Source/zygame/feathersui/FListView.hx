package zygame.feathersui;

import openfl.events.Event;
import feathers.data.IFlatCollection;
import openfl.geom.Point;
import openfl.events.MouseEvent;
#if feathersui
import feathers.events.ScrollEvent;
import feathers.controls.ListView;
import feathers.utils.Scroller;
import openfl.display.DisplayObjectContainer;

class FListView extends ListView {
	/**
	 * 是否一直使ctrlKey为true，当处于这种状态时，可点击多选
	 */
	public var autoCtrlKey:Bool = false;

	/**
	 * 最大可选择数量，为0时可无限选择
	 */
	public var maxSelectCounts:Int = 0;

	/**
	 * 允许滑动的时候点击ItemRenderer，默认为true
	 */
	public var allowScrollClickItemRenderer(default, set):Bool;

	private function set_allowScrollClickItemRenderer(v:Bool):Bool {
		if (v) {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onItemCheckDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onItemCheckClick);
		} else {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onItemCheckDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onItemCheckClick);
		}
		this.allowScrollClickItemRenderer = true;
		return v;
	}

	/**
	 * 是否正在滑动中
	 * @return Bool
	 */
	public function isScrolling():Bool {
		return this.listViewPort != null && !this.listViewPort.mouseChildren;
	}

	// 允许模拟触摸
	override function createScroller() {
		super.createScroller();
		@:privateAccess this.scroller.simulateTouch = true;
	}

	public function new() {
		super();
		// this.allowScrollClickItemRenderer = true;
		this.scrollMode = SCROLL_RECT;
		this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
	}

	private function onAddToStage(e:Event):Void {
		if (this.listViewPort != null) {
			listViewPort.mouseChildren = true;
		}
	}

	private var _beginTouch:Point = new Point();

	private function onItemCheckDown(e:MouseEvent):Void {
		_beginTouch.x = this.mouseX;
		_beginTouch.y = this.mouseY;
	}

	private function onItemCheckClick(e:MouseEvent):Void {
		var mx = Math.abs(_beginTouch.x - this.mouseX);
		var my = Math.abs(_beginTouch.y - this.mouseY);
		if (mx > 10 || my > 10) {
			return;
		}
		for (key => value in this.dataToItemRenderer) {
			if (value.hitTestPoint(this.mouseX, this.mouseY)) {
				this.selectedItem = key;
				return;
			}
		}
	}

	override function handleSelectionChange(item:Dynamic, index:Int, ctrlKey:Bool, shiftKey:Bool) {
		if (autoCtrlKey)
			ctrlKey = true;
		if (maxSelectCounts <= 0 || maxSelectCounts > this.selectedItems.length || this.selectedItems.indexOf(item) != -1)
			super.handleSelectionChange(item, index, ctrlKey, shiftKey);
	}
}
#end
