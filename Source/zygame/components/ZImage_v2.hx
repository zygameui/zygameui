package zygame.components;

// #if zimage_v2
import zygame.components.base.ImageRender;
import openfl.display.Shader;
import openfl.geom.Rectangle;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;
import zygame.utils.CacheAssets;
import zygame.utils.Align;
import zygame.components.ZBuilder;
import zygame.components.base.DataProviderBox;
import zygame.utils.load.Frame;

/**
 * 图片显示对象（v2）Bate
 * 当前显示对象，可通过`<haxedef name="zimage_v2"/>`定义开启，开启后，将不再使用`Tilemap`，默认使用`Bitmap`渲染。
 * 当前显示对象支持`Sprite`三角形渲染，但是在某些设备上，不支持非2次幂图，会呈黑色，并且会导致无法使用`Shader`，而是需要使用`GraphicsShader`，如果需要使用，定义`<haxedef name="zimage_v2_use_sprite_draw"/>`开启。
 * 当使用默认的`Bitmap`渲染时，其效果与`ZImage(v1)`版本是没有差异的。
 */
@:access(ImageRender)
@:noCompletion
class ZImage_v2 extends DataProviderBox {
	private var __render:ImageRender;

	/**
	 * 全局缓存资源，如果定义缓存资源，ZImage的异步资源会从这里读取资源
	 */
	public static var cacheAssets:CacheAssets;

	/**
	 * 默认显示数据，当发生加载失败的时候，该参数就会作为默认值进行渲染
	 */
	public var defaultDataProvider:Dynamic = null;

	/**
	 * 获得ZImage使用的显示基类对象
	 */
	public var display(get, never):ImageRender;

	private function get_display():ImageRender {
		return __render;
	}

	/**
	 * 当该参数为true时，会自动铺满背景，默认为false
	 */
	public var fill(default, set):Bool;

	private function set_fill(v:Bool):Bool {
		this.fill = v;
		this.updateComponents();
		return v;
	}

	/**
	 * 设置缩放比例宽度，只要scaleWidth或者scaleHeight任意一个值设置了比例缩放值后，在更换图片的时候，会自动按正比缩放适配图片
	 */
	public var scaleWidth(default, set):Int = 0;

	private function set_scaleWidth(v:Int):Int {
		this.scaleWidth = v;
		return v;
	}

	/**
	 * 设置缩放比例高度，只要scaleWidth或者scaleHeight任意一个值设置了比例缩放值后，在更换图片的时候，会自动按正比缩放适配图片
	 */
	public var scaleHeight(default, set):Int = 0;

	private function set_scaleHeight(v:Int):Int {
		this.scaleHeight = v;
		return v;
	}

	public function new() {
		super();
		__render = new ImageRender();
		this.addChild(__render);
		// var quad = new ZQuad(5, 5, 0xff0000);
		// this.addChild(quad);
		// quad.x = quad.y = -2;
	}

	override public function initComponents():Void {
		this.updateComponents();
	}

	override function set_dataProvider(data:Dynamic):Dynamic {
		if (data is String) {
			var bitmap = ZBuilder.getBaseBitmapData(data);
			if (bitmap != null) {
				data = bitmap;
			} else {
				// 异步加载资源
				var path:String = data;
				if (path == this.dataProvider) {
					return data;
				}
				// 当为: ${}格式时，则不会进行加载
				if ((path.indexOf("http") != 0 && path.indexOf(":") != -1) || path.indexOf("${") != -1) {
					return data;
				}
				if (path == "")
					return data;
				if (cacheAssets != null) {
					cacheAssets.loadBitmapData(path, function(bitmapData:BitmapData):Void {
						if (dataProvider != path)
							return;
						if (Std.isOfType(dataProvider, String)) {
							__drawRender(bitmapData);
						}
					});
				} else {
					// 启动异步载入
					AssetsUtils.loadBitmapData(path, false).onComplete(function(bitmapData:BitmapData):Void {
						if (dataProvider != path)
							return;
						__drawRender(bitmapData);
					}).onError(__loadError);
				}
			}
		}
		if (!Std.isOfType(data, String))
			__drawRender(data);
		return super.set_dataProvider(data);
	}

	private function __loadError(data:String):Void {
		if (defaultDataProvider != this.dataProvider) {
			super.dataProvider = defaultDataProvider;
		}
	}

	private var __currentDraw:Dynamic;

	private function __drawRender(bitmapData:Dynamic):Void {
		__currentDraw = bitmapData;
		__render.scaleX = __render.scaleY = 1;
		__render.x = __render.y = 0;
		@:privateAccess __render.draw(bitmapData, this._setWidth ? this._componentWidth : null, this._setHeight ? this._componentHeight : null);
		this.updateComponents();
		onBitmapDataUpdate();
	}

	override function set_width(value:Float):Float {
		__render.width = value;
		this.updateComponents();
		return super.set_width(value);
	}

	override function set_height(value:Float):Float {
		__render.height = value;
		this.updateComponents();
		return super.set_height(value);
	}

	private override function get_width():Float {
		if (fill) {
			return __render.width * scaleX;
		} else if (!_setWidth && @:privateAccess !this.__render.__isS9Draw) {
			var size = this.__render.getFrameSize();
			var pwidth = size.width;
			return pwidth * scaleX;
		}
		return Math.abs(_componentWidth * scaleX);
	}

	private override function get_height():Float {
		if (fill) {
			return __render.height * scaleY;
		} else if (!_setHeight && @:privateAccess !this.__render.__isS9Draw) {
			var size = this.__render.getFrameSize();
			var pheight = size.height;
			return pheight * scaleY;
		}
		return Math.abs(_componentHeight * scaleY);
	}

	override function alignPivot(v:Align = CENTER, h:Align = CENTER) {
		super.alignPivot(v, h);
		this.updateComponents();
	}

	override function updateComponents() {
		super.updateComponents();
		if (__currentDraw == null)
			return;
		var size = __render.getFrameSize();
		if (size.width == 0 || size.height == 0)
			return;
		__render.x = __render.y = 0;
		if (fill) {
			// 这是平铺的计算
			var scale1 = this.getStageWidth() / size.width;
			var scale2 = this.getStageHeight() / size.height;
			var scale = Math.max(scale1, scale2);
			__renderScale(scale, scale);
			this.x = (this.getStageWidth() - this.width) / 2;
			this.y = (this.getStageHeight() - this.height) / 2;
		} else if (scaleWidth != 0 && scaleHeight != 0) {
			// 这是等比缩放
			var scale1 = scaleWidth / size.width;
			var scale2 = scaleHeight / size.height;
			var scale = Math.min(scale1, scale2);
			__renderScale(scale, scale);
			super.width = scaleWidth;
			super.height = scaleHeight;
		} else {
			// 这是默认行为
			if (@:privateAccess !this.__render.__isS9Draw) {
				var pwidth = _setWidth ? _componentWidth : size.width;
				var pheight = _setHeight ? _componentHeight : size.height;
				var scaleX = pwidth / size.width;
				var scaleY = pheight / size.height;
				__renderScale(scaleX, scaleY);
			}
		}
		switch (vAlign) {
			case TOP:
				display.y = 0;
			case BOTTOM:
				display.y = -display.height;
			case CENTER:
				display.y = -display.height * 0.5;
			default:
		}
		switch (hAlign) {
			case LEFT:
				display.x = 0;
			case RIGHT:
				display.x = -display.width;
			case CENTER:
				display.x = -display.width * 0.5;
			default:
		}
	}

	private function __renderScale(scaleX:Float, scaleY:Float):Void {
		var size = __render.getFrameSize();
		#if false
		if (__render.isBitmapDraw) {
			__render.scaleX = scaleX;
			__render.scaleY = scaleY;
		} else {
			__render.width = size.width * scaleX;
			__render.height = size.height * scaleY;
		}
		#else
		__render.width = size.width * scaleX;
		__render.height = size.height * scaleY;
		#end
	}

	/**
	 * 设置九宫格格式
	 * @param rect 九宫格rect配置
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		// display.setScale9Grid(rect);
	}

	/**
	 * 当图片更新时发生的事件
	 */
	dynamic public function onBitmapDataUpdate():Void {}

	/**
	 * 设置图片是否平滑，当smoothing宏生效时，默认为true，否则为false
	 */
	public var smoothing(default, set):Bool;

	private function set_smoothing(bool:Bool):Bool {
		this.display.smoothing = bool;
		return bool;
	}

	private function get_smoothing():Bool {
		return this.display.smoothing;
	}

	private var _shader:Shader;

	/**
	 * 设置着色器对象
	 * @param value 着色器对象
	 * @return Shader
	 */
	override function set_shader(value:Shader):Shader {
		_shader = value;
		if (display != null)
			display.shader = value;
		this.__drawRender(__currentDraw);
		return value;
	}

	override function get_shader():Shader {
		return _shader;
	}

	override function invalidate() {
		super.invalidate();
		if(display != null)
			display.invalidate();
	}
} // #end
