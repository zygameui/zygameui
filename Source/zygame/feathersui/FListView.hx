package zygame.feathersui;

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

	public function new() {
		super();
		this.scrollMode = SCROLL_RECT;
		// scrollerFactory = function() {
		// 	var scroller = new Scroller();
		// 	scroller.elasticEdges = false;
		// 	scroller.addEventListener(ScrollEvent.SCROLL_START, function(e:ScrollEvent):Void {
		// 		// 禁止不允许点击的处理
		// 		if ((@:privateAccess scroller._target is DisplayObjectContainer)) {
		// 			var container = cast(@:privateAccess scroller._target, DisplayObjectContainer);
		// 			container.mouseChildren = @:privateAccess scroller.restoreMouseChildren;
		// 			trace("恢复：", container.mouseChildren);
		// 		}
		// 	});
		// 	return scroller;
		// }
	}

	override function handleSelectionChange(item:Dynamic, index:Int, ctrlKey:Bool, shiftKey:Bool) {
		if (autoCtrlKey)
			ctrlKey = true;
		if (maxSelectCounts <= 0 || maxSelectCounts > this.selectedItems.length || this.selectedItems.indexOf(item) != -1)
			super.handleSelectionChange(item, index, ctrlKey, shiftKey);
	}
}
#end
