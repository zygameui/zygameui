package zygame.commponts.v2;

import zygame.commponts.v2.ImageRender;
import openfl.display.Shader;
import openfl.geom.Rectangle;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;
import zygame.utils.CacheAssets;
import zygame.utils.Align;
import zygame.components.ZBuilder;
import zygame.components.base.DataProviderBox;

/**
 * 图片显示对象
 */
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
				// 当为: ${}格式时，则不会进行加载
				if ((path.indexOf("http") != 0 && path.indexOf(":") != -1) || path.indexOf("${") != -1) {
					return data;
				}
				if (cacheAssets != null) {
					cacheAssets.loadBitmapData(path, function(bitmapData:BitmapData):Void {
						if (dataProvider != path)
							return;
						if (Std.isOfType(dataProvider, String)) {
							__drawRender(bitmapData);
							// display.bitmapData = bitmapData;
							// updateImageScaleWidthAndHeight();
							// onBitmapDataUpdate();
							// this.shader = _shader;
						}
					});
				} else {
					// 启动异步载入
					AssetsUtils.loadBitmapData(path, false).onComplete(function(bitmapData:BitmapData):Void {
						if (dataProvider != path)
							return;
						__drawRender(bitmapData);
						// if (isDispose || !Std.isOfType(dataProvider, String)) {
						// 	ZGC.disposeBitmapData(bitmapData);
						// 	return;
						// }
						// display.bitmapData = bitmapData;
						// updateImageScaleWidthAndHeight();
						// onBitmapDataUpdate();
						// this.shader = _shader;
						// isAysn = true;
					}).onError(__loadError);
				}
			}
		}
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
		__render.draw(bitmapData, this._setWidth ? this.width : null, this._setHeight ? this.height : null);
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

	override function alignPivot(v:Align = CENTER, h:Align = CENTER) {
		super.alignPivot(v, h);
		this.updateComponents();
	}

	override function updateComponents() {
		if (fill) {
			var scale1 = this.getStageWidth() / __render.width;
			var scale2 = this.getStageHeight() / __render.height;
			var scale = Math.max(scale1, scale2);
			__render.width = __render.width * scale;
			__render.height = __render.height * scale;
			__renderScale(scale, scale);
		} else if (scaleWidth != 0 && scaleHeight != 0) {
			var scale1 = scaleWidth / __render.width;
			var scale2 = scaleHeight / __render.height;
			var scale = Math.min(scale1, scale2);
			__renderScale(scale, scale);
		}
		super.updateComponents();
		zygame.utils.Align.AlignTools.alignDisplay(__render, vAlign, hAlign);
	}

	private function __renderScale(scaleX:Float, scaleY:Float):Void {
		__render.width = __render.width * scaleX;
		__render.height = __render.height * scaleY;
		super.width = __render.width;
		super.height = __render.height;
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
}
