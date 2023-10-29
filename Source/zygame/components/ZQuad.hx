package zygame.components;

// import openfl.display.Shape;
import openfl.events.RenderEvent;
import openfl.display.Bitmap;
import zygame.components.ZBox;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import zygame.shader.ColorShader;
import openfl.filters.ShaderFilter;

/**
 * 生成一个矩形可更改颜色的色块，默认允许XML中使用。
 * ```xml
 * <ZQuad width="300" height="300" color="0xff0000"/>
 * ```
 */
class ZQuad extends ZBox {
	public var ellipseWidth:Float = 0;

	public var ellipseHeight:Float = 0;

	/**
	 * 构造一个色块渲染对象
	 * @param width 宽度
	 * @param height 高度
	 * @param color 颜色
	 */
	public function new(width:Int = 0, height:Int = 0, color:UInt = 0x0) {
		super();
		this.width = width;
		this.height = height;
		this.color = color;
		this.addEventListener(RenderEvent.RENDER_OPENGL, onRenderOpenGL);
	}

	private function __draw():Void {
		this.graphics.beginFill(color);
		this.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
	}

	private function onRenderOpenGL(e:RenderEvent):Void {}

	override public function initComponents():Void {
		super.initComponents();
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
		this.color = value;
		this.updateComponents();
		return value;
	}

	private function get_color():UInt {
		return color;
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
