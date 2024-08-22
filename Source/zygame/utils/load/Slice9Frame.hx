package zygame.utils.load;

import openfl.Vector;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.BaseFrame;
import openfl.geom.Rectangle;
import openfl.display.Tileset;

class Slice9Frame extends BaseFrame {
	/**
	 * 九宫格配置
	 */
	public var scale9frames(get, never):Array<Frame>;

	private var _scale9frames:Array<Frame>;

	public var scale9rect(get, set):Rectangle;

	private var _rect:Rectangle = null;

	private function get_scale9rect():Rectangle {
		return _rect;
	}

	private function set_scale9rect(rect:Rectangle):Rectangle {
		_rect = rect;
		if (_scale9frames != null) {
			_scale9frames = null;
		}
		return _rect;
	}

	private function get_scale9frames():Array<Frame> {
		if (scale9rect == null) {
			return null;
		}
		if (_scale9frames != null)
			return _scale9frames;
		scale9rect.width = Math.abs(scale9rect.width);
		scale9rect.height = Math.abs(scale9rect.height);
		var rects:Array<Rectangle> = zygame.utils.Scale9Utils.createScale9Rects(this.x, this.y, this.width, this.height, scale9rect);
		_scale9frames = [];
		for (rect in rects) {
			parent.getTileset().addRect(rect);
			// 创建批处理帧
			var frame:Frame = new Frame(parent);
			frame.id = parent.getTileset().numRects - 1;
			frame.x = rect.x;
			frame.y = rect.y;
			frame.width = rect.width;
			frame.height = rect.height;
			_scale9frames.push(frame);
		}
		return _scale9frames;
	}
}
