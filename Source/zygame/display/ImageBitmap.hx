package zygame.display;

import zygame.components.ZBuilder;
import zygame.utils.load.Frame;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;

/**
 * 轻量化的ImageBitmap显示对象
 */
class ImageBitmap extends Bitmap {
	public var mouseEnabled:Bool = false;

	private var _data:Dynamic = null;

	private var _rect:Rectangle;

	/**
	 * 为ImageBitmap设置位图或者精灵数据
	 */
	public var dataProvider(get, set):Dynamic;

	function get_dataProvider():Dynamic {
		return _data;
	}

	public function getTextureWidth():Float {
		if (_data == null)
			return 0;
		if (Std.isOfType(dataProvider, BitmapData))
			return cast(dataProvider, BitmapData).width;
		else if (Std.isOfType(dataProvider, Frame))
			return cast(dataProvider, Frame).width;
		return 0;
	}

	public function getTextureHeight():Float {
		if (_data == null)
			return 0;
		if (Std.isOfType(dataProvider, BitmapData))
			return cast(dataProvider, BitmapData).height;
		else if (Std.isOfType(dataProvider, Frame))
			return cast(dataProvider, Frame).height;
		return 0;
	}

	function set_dataProvider(value:Dynamic):Dynamic {
		if (Std.isOfType(value, String)) {
			value = ZBuilder.getBaseBitmapData(value);
		}
		_data = value;
		if (Std.isOfType(value, BitmapData)) {
			this.bitmapData = value;
		} else if (Std.isOfType(value, Frame)) {
			var frame:Frame = cast value;
			this.bitmapData = frame.parent.getRootBitmapData();
			if (_rect == null)
				_rect = new Rectangle();
			_rect.x = frame.x;
			_rect.y = frame.y;
			_rect.width = frame.width;
			_rect.height = frame.height;
			this.scrollRect = _rect;
			if (frame.scale9rect != null)
				this.scale9Grid = frame.scale9rect;
			// this.scaleX = this.bitmapData.width / frame.width;
			// this.scaleY = this.bitmapData.height / frame.height;
		}
		return _data;
	}
}
