package zygame.display;

import openfl.Vector;
import glsl.OpenFLGraphicsShader;
import openfl.display.Shape;
import zygame.components.ZBuilder;
import zygame.utils.load.Frame;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;

class BaseGraphicsShader extends OpenFLGraphicsShader {}

/**
 * 轻量化的ImageShape显示对象（Shape版本）
 */
@:access(openfl.geom.Rectangle)
class ImageShape extends Shape {
	private static var __renderShader:BaseGraphicsShader = new BaseGraphicsShader();

	public var mouseEnabled:Bool = false;

	private var _data:Dynamic = null;

	public var bitmapData(default, set):BitmapData;

	private function set_bitmapData(data:BitmapData):BitmapData {
		this.bitmapData = data;
		__drawBitmapData(data);
		return data;
	}

	private var _rect:Rectangle;

	private var _width:Float = 0;

	private var _height:Float = 0;

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
			__drawBitmapData(value);
		} else if (Std.isOfType(value, Frame)) {
			var frame:Frame = cast value;
			this.bitmapData = frame.parent.getRootBitmapData();
			__drawFrameData(frame);
		}
		return _data;
	}

	private function __drawBitmapData(value:BitmapData):Void {
		_width = value.width;
		_height = value.height;
		this.graphics.clear();
		__renderShader.bitmap.input = bitmapData;
		this.graphics.beginShaderFill(__renderShader);
		var m = new Matrix();
		var v:Vector<Float> = new Vector(4, false, [0., 0, value.width, value.height]);
		var t:Vector<Float> = new Vector(6, false, [m.a, m.b, m.c, m.d, 0, 0]);
		this.graphics.drawQuads(v, null, t);
		this.graphics.endFill();
	}

	private function __drawFrameData(value:Frame):Void {
		_width = value.width;
		_height = value.height;
		this.graphics.clear();
		__renderShader.bitmap.input = bitmapData;
		this.graphics.beginShaderFill(__renderShader);
		var m = new Matrix();
		var v:Vector<Float> = new Vector(4, false, [value.x, value.y, value.width, value.height]);
		var t:Vector<Float> = new Vector(6, false, [m.a, m.b, m.c, m.d, 0, 0]);
		this.graphics.drawQuads(v, null, t);
		this.graphics.endFill();
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void {
		var bounds = Rectangle.__pool.get();
		if (_data == null && bitmapData != null) {
			bounds.setTo(0, 0, bitmapData.width, bitmapData.height);
		} else {
			bounds.setTo(0, 0, _width, _height);
		}
		bounds.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}
}
