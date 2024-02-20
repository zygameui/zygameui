package zygame.components;

import openfl.Vector;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.DisplayObject;
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
@:privateAccess(game.geom.Rectangle)
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

	/**
	 * 非圆角的显示对象仍然支持Bitmap
	 */
	private var display:Bitmap;
	#end

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
		this.graphics.clear();
		this.graphics.beginFill(color);
		if (ellipseWidth == null) {
			// this.graphics.drawRect(0, 0, width, height);
			this.graphics.drawQuads(new Vector<Float>([0, 0, width, height]));
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
		#if zquad_use_bitmap
		this.addChildAt(display, 0);
		#end
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

	#if !flash
	/**
	 * 重写触摸事件，用于实现在TouchImageBatchsContainer状态中，允许穿透点击
	 * @param x 
	 * @param y 
	 * @param shapeFlag 
	 * @param stack 
	 * @param interactiveOnly 
	 * @param hitObject 
	 * @return Bool
	 */
	override private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		if (!hitObject.visible || width == 0 || height == 0 || !this.mouseEnabled)
			return false;
		if (mask != null && !mask.__hitTestMask(x, y))
			return false;
		__getRenderTransform();
		var px = @:privateAccess __renderTransform.__transformInverseX(x, y);
		var py = @:privateAccess __renderTransform.__transformInverseY(x, y);
		if (px > 0 && py > 0 && px <= this.width && py <= this.height) {
			if (__scrollRect != null && !__scrollRect.contains(px, py)) {
				return false;
			}

			if (stack != null && !interactiveOnly) {
				stack.push(hitObject);
			}

			var childTouch = super.__hitTest(x, y, false, stack, interactiveOnly, hitObject);
			if (!childTouch) {
				if (stack != null)
					stack.push(this);
				return true;
			}
			return childTouch;
		}

		return false;
	}
	#end

	private static var __rect:Rectangle = new Rectangle();

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void {
		var bounds = __rect;
		bounds.setTo(0, 0, this._componentWidth, this._componentHeight);
		@:privateAccess bounds.__transform(bounds, matrix);
		@:privateAccess rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
	}
}
