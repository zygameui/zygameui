package zygame.display.batch;

import openfl.display.Tile;

/**
 * 批渲染的BStack对象
 */
class BStack extends BBox {
	public var stacks:Array<Tile> = [];

	override function addTileAt(display:Tile, index:Int):Tile {
		display.visible = __getName(display) == currentId;
		if (stacks.indexOf(display) == -1)
			stacks.push(display);
		if (display.visible) {
			this.removeTiles();
			currentSelect = display;
			return super.addTileAt(display, 0);
		}
		return super.addTileAt(display, index);
	}

	private function __getName(tile:Tile):String {
		if (Std.isOfType(tile, BDisplayObject))
			return cast(tile, BDisplayObject).name;
		else if (Std.isOfType(tile, BDisplayObjectContainer))
			return cast(tile, BDisplayObjectContainer).name;
		return null;
	}

	private var _id:String;

	/**
	 * 设置ID来显示对象，如果ID不存在，则不会显示任何内容
	 */
	public var currentId(get, set):String;

	/**
	 * 当前的显示对象
	 */
	public var currentSelect:Tile;

	private function get_currentId():String {
		return _id;
	}

	private function set_currentId(value:String):String {
		_id = value;
		this.updateDisplay();
		return value;
	}

	public function getChildByName(name:String):Tile {
		for (index => value in stacks) {
			if (__getName(value) == name)
				return value;
		}
		return null;
	}

	private function updateDisplay():Void {
		trace(stacks);
		for (i in 0...this.stacks.length) {
			var child = this.stacks[i];
			trace("name", __getName(child));
			child.visible = __getName(child) == currentId;
			if (child.visible) {
				this.addChild(child);
			}
		}
	}
}
