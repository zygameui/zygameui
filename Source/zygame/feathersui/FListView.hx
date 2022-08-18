package zygame.feathersui;

#if feathersui
import feathers.controls.ListView;

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
	}

	override function handleSelectionChange(item:Dynamic, index:Int, ctrlKey:Bool, shiftKey:Bool) {
		if (autoCtrlKey)
			ctrlKey = true;
		if (maxSelectCounts <= 0 || maxSelectCounts > this.selectedItems.length || this.selectedItems.indexOf(item) != -1)
			super.handleSelectionChange(item, index, ctrlKey, shiftKey);
	}
}
#end
