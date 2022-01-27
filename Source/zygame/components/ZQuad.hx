package zygame.components;

// import openfl.display.Shape;
import openfl.display.Bitmap;
import zygame.components.ZBox;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import zygame.shader.ColorShader;
import openfl.filters.ShaderFilter;

/**
 * 生成一个矩形可更改颜色的色块
 */
class ZQuad extends ZBox {
	public static var quadBitmapData:BitmapData;

	private var display:Bitmap;

	public function new() {
		super();
		display = new Bitmap(quadBitmapData);
		display.shader = new ColorShader(0x0);
	}

	override public function initComponents():Void {
		super.initComponents();
		this.addChildAt(display, 0);
		updateComponents();
	}

	override public function updateComponents():Void {
		cast(display.shader, ColorShader).updateColor(color);
		display.width = this.width == 0 ? 0 : this.width + 1;
		display.height = this.height == 0 ? 0 : this.height + 1;
	}

	private var _color:UInt = 0x0;

	/**
	 * 设置色块的颜色
	 */
	public var color(get, set):UInt;

	private function set_color(value:UInt):UInt {
		_color = value;
		this.updateComponents();
		return value;
	}

	private function get_color():UInt {
		return _color;
	}

	#if flash
	override public function set_width(value:Float):Float {
		super.width = value;
		this.updateComponents();
		return value;
	}

	override public function set_height(value:Float):Float {
		super.height = value;
		this.updateComponents();
		return value;
	}
	#else
	override private function set_width(value:Float):Float {
		super.width = value;
		this.updateComponents();
		return value;
	}

	override private function set_height(value:Float):Float {
		super.height = value;
		this.updateComponents();
		return value;
	}
	#end

	#if (qq || wechat)
	override private function __hitTestMask(x:Float, y:Float):Bool {
		if (Std.isOfType(this.parent, zygame.components.ZScroll)) {
			var point:Point = new Point(x, y);
			point = this.globalToLocal(point);
			var rect:Rectangle = this.getBounds(null);
			if (rect.x < point.x && rect.y < point.y && rect.width > point.x && rect.height > point.y) {
				return true;
			}
		}
		return super.__hitTestMask(x, y);
	}
	#end

	@:keep
	public var fill(never, set):Bool;

	private function set_fill(value:Bool):Bool {
		if (value) {
			this.width = getStageWidth();
			this.height = getStageHeight();
		}
		return value;
	}
}

#if !api
// @:bitmap("Export/html5/bin/1px.png") class PxBackgroundBMPD extends BitmapData {}
#end
