package zygame.display.batch;

import zygame.display.batch.BDisplayObjectContainer;
import zygame.utils.load.Frame;
import zygame.utils.load.TextureLoader;
import zygame.display.batch.BImage;
import openfl.display.Tile;
import openfl.geom.Rectangle;

/**
 * 九宫格批渲染支持，需要在精灵表中进行bindScale9后的frame才能正常使用
 */
class BScale9SliceImage extends BDisplayObjectContainer {
	public var curFrame:Frame;

	public var curParent:TextureAtlas;

	private var _setWidth:Bool = false;
	private var _width:Float = 0;

	private var _setHeight:Bool = false;
	private var _height:Float = 0;

	public function new(frame:Frame = null) {
		super();
		this.width;
		this.height;
		setFrame(frame);
	}

	/**
	 * 设置新帧
	 * @param frame 
	 */
	public function setFrame(frame:Frame):Void {
		if (frame == null || frame.scale9frames == null || frame == curFrame)
			return;
		super.set_id(frame.id);
		curParent = cast frame.parent;
		curFrame = frame;
		// 清空所有tiles
		removeTiles();
		// 生成新的tiles
		for (s9frame in frame.scale9frames) {
			var img:BImage = new BImage(s9frame);
			this.addTile(img);
		}
		if (!_setWidth)
			_width = frame.width;
		if (!_setHeight)
			_height = frame.height;
		updateScale9();
	}

	override private function set_width(value:Float):Float {
		_setWidth = true;
		_width = value;
		updateScale9();
		return value;
	}

	override private function set_height(value:Float):Float {
		_setHeight = true;
		_height = value;
		updateScale9();
		return value;
	}

	/**
	 * 更新刷新9宫格
	 */
	private function updateScale9():Void {
		if (curFrame == null)
			return;
		var __width:Float = _width < curFrame.width ? curFrame.width : _width;
		var __height:Float = _height < curFrame.height ? curFrame.height : _height;
		this.scaleX = 1;
		this.scaleY = 1;
		if (_width < curFrame.width)
			this.scaleX = _width / curFrame.width;
		if (_height < curFrame.height)
			this.scaleY = _height / curFrame.height;
		for (i in 0...9) {
			var tile:Tile = this.getTileAt(i);
			var left:Float = curFrame.scale9rect.x;
			var right:Float = curFrame.width - curFrame.scale9rect.x - curFrame.scale9rect.width;
			var bottom:Float = curFrame.height - curFrame.scale9rect.y - curFrame.scale9rect.height;
			var top:Float = curFrame.scale9rect.y;
			var cwidth:Float = __width - left - right;
			var cheight:Float = __height - top - bottom;
			var pscaleX:Float = cwidth / curFrame.scale9frames[i].width;
			var pscaleY:Float = cheight / curFrame.scale9frames[i].height;

			switch (i) {
				case 0:
					// 左上
				case 1:
					// 中上
					tile.x = left;
					tile.scaleX = pscaleX;
				case 2:
					// 右上
					tile.x = __width - right;
				case 3:
					// 左中
					tile.y = top;
					tile.scaleY = pscaleY;
				case 4:
					// 居中
					tile.x = left;
					tile.y = top;
					tile.scaleX = pscaleX;
					tile.scaleY = pscaleY;
				case 5:
					// 右中
					tile.x = __width - right;
					tile.y = top;
					tile.scaleY = pscaleY;
				case 6:
					// 下左
					tile.y = __height - bottom;
				case 7:
					// 中下
					tile.x = left;
					tile.y = __height - bottom;
					tile.scaleX = pscaleX;
				case 8:
					// 右下
					tile.x = __width - right;
					tile.y = __height - bottom;
			}
		}
	}

	public function getClickBounds(tile:openfl.display.Tile):Rectangle {
		if (curFrame != null) {
			var rect:Rectangle = new Rectangle();
			rect.setTo(-this.originX, -this.originY, this._width, this._height);
			#if !flash
			@:privateAccess rect.__transform(rect, matrix);
			#end
			// if(tile != null)
			// {
			//     rect.width *= tile.scaleX;
			//     rect.height *= tile.scaleY;
			// }
			return rect;
		}
		return null;
	}

	override public function getBounds(tile:openfl.display.Tile):Rectangle {
		var rect:Rectangle = null;
		if (this.parent == tile)
			rect = getClickBounds(tile);
		if (rect == null)
			rect = super.getBounds(tile);
		return rect;
	}
}
