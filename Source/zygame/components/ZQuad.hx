package zygame.components;

import openfl.display.Bitmap;
import zygame.shader.ColorShader;
import openfl.display.BitmapData;
import openfl.events.RenderEvent;
import zygame.components.ZBox;

/**
 * 生成一个矩形可更改颜色的色块，默认允许XML中使用。
 * ```xml
 * <ZQuad width="300" height="300" color="0xff0000"/>
 * ```
 */
class ZQuad extends ZBox {
	#if zquad_use_bitmap
	/**
	 * 颜色着色器
	 */
	private static var __colorShader:ColorShader = new ColorShader(0x0);

	/**
	 * 图块的渲染纹理对象
	 */
	public static var quadBitmapData(get, never):BitmapData;

	private static var __quadBitmapData:BitmapData;

	private static function get_quadBitmapData():BitmapData {
		if (__quadBitmapData == null) {
			__quadBitmapData = new BitmapData(1, 1, true, 0xffffffff);
		}
		return __quadBitmapData;
	}
	#end

	/**
	 * 非圆角的显示对象仍然支持Bitmap
	 */
	private var display:Bitmap;

	/**
	 * 圆角的宽度，该参数默认为`null`，设置值后，将会渲染圆角，请注意，圆角渲染为`软件渲染`。
	 */
	public var ellipseWidth(default, set):Null<Float> = null;

	private function set_ellipseWidth(e:Float):Float {
		if (ellipseWidth != e) {
			this.ellipseWidth = e;
			__changed = true;
		}
		return e;
	}

	/**
	 * 圆角的高度，该参数默认为`null`，设置值后，将会渲染圆角，请注意，圆角渲染为`软件渲染`。当不存在`ellipseHeight`值时，则会使用`ellipseWidth`值
	 */
	public var ellipseHeight(default, set):Null<Float> = null;

	private function set_ellipseHeight(e:Float):Float {
		if (ellipseHeight != e) {
			this.ellipseHeight = e;
			__changed = true;
		}
		return e;
	}

	private var __changed:Bool = false;

	/**
	 * 构造一个色块渲染对象
	 * @param width 宽度
	 * @param height 高度
	 * @param color 颜色
	 */
	public function new(width:Int = 0, height:Int = 0, color:UInt = 0x0) {
		super();
		#if zquad_use_bitmap
		display = new Bitmap(quadBitmapData);
		display.shader = __colorShader;
		#end
		this.width = width;
		this.height = height;
		this.color = color;
		this.addEventListener(RenderEvent.RENDER_OPENGL, onRenderOpenGL);
	}

	private function __draw():Void {
		#if zquad_use_bitmap
		if (ellipseWidth == null) {
			this.addChildAt(display, 0);
			display.width = this.width == 0 ? 0 : this.width + 1;
			display.height = this.height == 0 ? 0 : this.height + 1;
		} else {
			display.parent?.removeChild(display);
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
			this.graphics.endFill();
		}
		#else
		display.parent?.removeChild(display);
		this.graphics.clear();
		this.graphics.beginFill(color);
		if (ellipseWidth == null) {
			this.graphics.drawRect(0, 0, width, height);
		} else {
			this.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
		}
		this.graphics.endFill();
		#end
	}

	private function onRenderOpenGL(e:RenderEvent):Void {
		#if zquad_use_bitmap
		if (display.parent != null)
			__colorShader.updateColor(color);
		#end
		if (__changed) {
			__changed = false;
			this.updateComponents();
		}
	}

	override public function initComponents():Void {
		super.initComponents();
		this.addChildAt(display, 0);
		updateComponents();
	}

	override public function updateComponents():Void {
		__draw();
	}

	/**
	 * 设置色块的颜色
	 */
	public var color(default, set):UInt = 0x0;

	private function set_color(value:UInt):UInt {
		if (this.color != value) {
			this.color = value;
			this.updateComponents();
		}
		return value;
	}

	private function get_color():UInt {
		return color;
	}

	override private function set_width(value:Float):Float {
		if (super.width != value) {
			super.width = value;
			this.__changed = true;
		}
		return value;
	}

	override private function set_height(value:Float):Float {
		if (super.height != value) {
			super.height = value;
			this.__changed = true;
		}
		return value;
	}

	#if (zygameui < '14.0.0')
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
	#end

	/**
	 * 是否自动铺面
	 */
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
