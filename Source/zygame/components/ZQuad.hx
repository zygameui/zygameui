package zygame.components;

import openfl.events.RenderEvent;
import zygame.components.ZBox;

/**
 * 生成一个矩形可更改颜色的色块，默认允许XML中使用。
 * ```xml
 * <ZQuad width="300" height="300" color="0xff0000"/>
 * ```
 */
class ZQuad extends ZBox {
	public var ellipseWidth(default, set):Float = 0;

	private function set_ellipseWidth(e:Float):Float {
		this.ellipseWidth = e;
		__changed = true;
		return e;
	}

	public var ellipseHeight(default, set):Float = 0;

	private function set_ellipseHeight(e:Float):Float {
		this.ellipseHeight = e;
		__changed = true;
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
		this.width = width;
		this.height = height;
		this.color = color;
		this.addEventListener(RenderEvent.RENDER_OPENGL, onRenderOpenGL);
	}

	private function __draw():Void {
		this.graphics.clear();
		this.graphics.beginFill(color);
		if (ellipseWidth != 0 || ellipseHeight != 0) {
			this.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
		} else {
			this.graphics.drawRect(0, 0, width, height);
		}
		this.graphics.endFill();
	}

	private function onRenderOpenGL(e:RenderEvent):Void {
		if (__changed) {
			__changed = false;
			this.updateComponents();
		}
	}

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

	override private function set_width(value:Float):Float {
		super.width = value;
		this.__changed = true;
		return value;
	}

	override private function set_height(value:Float):Float {
		super.height = value;
		this.__changed = true;
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
