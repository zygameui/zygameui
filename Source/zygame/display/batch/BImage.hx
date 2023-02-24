package zygame.display.batch;

import zygame.components.ZBuilder;
import openfl.display.Tile;
import zygame.utils.load.Frame;
import zygame.utils.load.TextureLoader;
import openfl.geom.Rectangle;
import zygame.display.batch.BDisplayObject;
import zygame.display.batch.ITileDisplayObject;

/**
 * 使用Tilemap实现的图片显示基类，可使用精灵图功能显示
 */
@:access(openfl.geom.Rectangle)
class BImage extends BDisplayObject {
	public var curFrame:Frame;

	public var curParent:TextureAtlas;

	public function new(data:Dynamic = null) {
		var frame:Frame = null;
		if (data is String) {
			frame = ZBuilder.getBaseBitmapData(data);
		} else {
			frame = data;
		}
		super(frame != null ? frame.id : -1, 0, 0, 1, 1);
		setFrame(frame);
	}

	/**
	 * 获取实际宽度（原图尺寸，旋转不计算）
	 */
	private function getCurWidth():Float {
		if (curFrame != null) {
			if (curFrame.frameWidth > curFrame.width)
				return curFrame.frameWidth;
			return curFrame.width;
		}
		return 0;
	}

	/**
	 * 获取实际高度（原图尺寸，旋转不计算）
	 */
	private function getCurHeight():Float {
		if (curFrame != null) {
			if (curFrame.frameHeight > curFrame.height)
				return curFrame.frameHeight;
			return curFrame.height;
		}
		return 0;
	}

	override private function __findTileRect(result:Rectangle):Void {
		super.__findTileRect(result);
		if (result.width < this.getCurWidth())
			result.width = this.getCurWidth();
		if (result.height < this.getCurHeight())
			result.height = this.getCurHeight();
	}

	/**
	 * 设置ID时，更改当前的Frame
	 * @param id 
	 * @return Int
	 */
	override public function set_id(id:Int):Int {
		// 更新当前帧信息
		var newFrame:Frame = curParent.getBitmapDataFrameAt(id);
		setFrame(newFrame);
		return id;
	}

	/**
	 *  设置新的帧，可以通过精灵图名字设置，或者`Frame`数据直接设置
	 * @param frame 可以是String以及`Frame`对象
	 */
	public function setFrame(data:Dynamic):Void {
		if (data is String) {
			setFrame(ZBuilder.getBaseBitmapData(data));
			return;
		}
		var frame:Frame = data;
		if (frame == null) {
			super.set_id(-1);
			curFrame = null;
			return;
		}
		super.set_id(frame.id);
		curParent = frame.parent;
		curFrame = frame;
		this.originX = -frame.frameX;
		this.originY = -frame.frameY;
	}

	public function getClickBounds(tile:openfl.display.Tile):Rectangle {
		if (curFrame != null) {
			var rect:Rectangle = new Rectangle();
			__findTileRect(rect);
			// rect.setTo(-this.originX,-this.originY,curFrame.width,curFrame.height);
			#if !flash
			rect.__transform(rect, matrix);
			#end
			return rect;
		}
		return null;
	}

	override public function getBounds(tile:openfl.display.Tile):Rectangle {
		var rect = null;
		if (tile == this.parent)
			rect = getClickBounds(tile);
		if (rect == null)
			rect = super.getBounds(tile);
		return rect;
	}
}
