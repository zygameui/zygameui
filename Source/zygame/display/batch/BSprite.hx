package zygame.display.batch;

import openfl.display.Tile;
import openfl.geom.Rectangle;
import zygame.display.batch.BImage;
import openfl.events.TouchEvent;
import zygame.display.batch.BScale9Image;
import zygame.display.batch.BTouchSprite;
import zygame.display.batch.BDisplayObjectContainer;
import zygame.display.batch.BLabel;

/**
 * BSprite容器
 */
class BSprite extends BDisplayObjectContainer {
	/**
	 * 是否可以触摸到子集
	 */
	public var mouseChildren:Bool = true;

	public function new() {
		super();
	}

	/**
	 * 通过坐标获取指定tile
	 * @param posx
	 * @param posy
	 * @return Tile
	 */
	public function getTileAtPos(posx:Float, posy:Float):Tile {
		// 隐藏状态不可点击
		if (this.visible == false)
			return null;

		posx -= this.x;
		posy -= this.y;

		// 角度计算
		var r:Float = -(Math.PI / 180 * this.rotation);
		var rx:Float = 0 + (posx) * Math.cos(r) - (posy) * Math.sin(r);
		var ry:Float = 0 + (posx) * Math.sin(r) + (posy) * Math.cos(r);
		posx = rx;
		posy = ry;
		posx /= scaleX;
		posy /= scaleY;

		var tile:Tile = null;

		var num:Int = this.numTiles - 1;
		while (num >= 0) {
			tile = this.getTileAt(num);
			if (Std.isOfType(tile, BSprite)) {
				var tile2:Tile = cast(tile, BSprite).getTileAtPos(posx, posy);
				if (tile2 != null && cast(tile, BSprite).mouseEnabled && tile.visible)
					return mouseChildren ? tile2 : this;
			} else if (Std.isOfType(tile, BImage)) {
				var img:BImage = cast tile;
				var rect:Rectangle = img.getClickBounds(this);
				if (img.mouseEnabled && tile.visible && rect != null && rect.contains(posx, posy)) {
					return mouseChildren ? tile : this;
				}
			} else if (Std.isOfType(tile, BScale9Image)) {
				var img:BScale9Image = cast tile;
				var rect:Rectangle = img.getClickBounds(this);
				if (img.mouseEnabled && tile.visible && rect != null && rect.contains(posx, posy)) {
					return mouseChildren ? tile : this;
				}
			} else if (Std.isOfType(tile, BLabel)) {
				var img:BLabel = cast tile;
				var rect:Rectangle = img.getBounds(this);
				if (img.mouseEnabled && tile.visible && rect != null && rect.contains(posx, posy)) {
					return mouseChildren ? tile : this;
				}
			} else if (Std.isOfType(tile, Tile)) {
				var img:Tile = cast tile;
				var rect:Rectangle = img.getBounds(this);
				if (tile.visible && rect != null && rect.contains(posx, posy)) {
					return mouseChildren ? tile : this;
				}
			}
			num--;
		}
		return null;
	}

	/**
	 * 统一调用触摸事件
	 * @param e
	 */
	public function dispatchTouchEvent(e:TouchEvent):Void {
		var tile:Tile = null;
		var num:Int = this.numTiles - 1;
		while (num >= 0) {
			tile = this.getTileAt(num);
			if (Std.isOfType(tile, BSprite)) {
				if (Std.isOfType(tile, BTouchSprite)) {
					switch (e.type) {
						case TouchEvent.TOUCH_BEGIN:
							cast(tile, BTouchSprite).onTouchBegin(e);
						case TouchEvent.TOUCH_END:
							cast(tile, BTouchSprite).onTouchEnd(e);
						case TouchEvent.TOUCH_MOVE:
							cast(tile, BTouchSprite).onTouchMove(e);
					}
				}
				cast(tile, BSprite).dispatchTouchEvent(e);
			}
			num--;
		}
	}
}
