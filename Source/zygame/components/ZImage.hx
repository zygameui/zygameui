package zygame.components;

import zygame.utils.Align;
import zygame.utils.CacheAssets;
import zygame.utils.ZGC;
import openfl.display.Shader;
import zygame.components.base.DataProviderComponent;
import zygame.display.Image;
import openfl.display.BitmapData;
import zygame.utils.AssetsUtils in Assets;
import zygame.utils.load.Frame;
import openfl.geom.Rectangle;

/**
 * 支持使用图片路径、以及位图设置内容，默认允许XML中使用。
 * ```xml
 * <ZImage src="img_png"/>
 * ```
 */
class ZImage extends DataProviderComponent {
	private var isDispose:Bool = false;

	private var isAysn:Bool = false;

	private var _shader:Shader;

	/**
	 * ZImage的显示所使用的显示基类对象
	 */
	public var display:Image;

	/**
	 * 当该参数为true时，会自动铺满背景，默认为false
	 */
	public var fill(get, set):Bool;

	private var _fill:Bool = false;

	/**
	 * 设置缩放比例宽度，只要scaleWidth或者scaleHeight任意一个值设置了比例缩放值后，在更换图片的时候，会自动按正比缩放适配图片
	 */
	public var scaleWidth:Int = 0;

	/**
	 * 设置缩放比例高度，只要scaleWidth或者scaleHeight任意一个值设置了比例缩放值后，在更换图片的时候，会自动按正比缩放适配图片
	 */
	public var scaleHeight:Int = 0;

	private function set_fill(value:Bool):Bool {
		_fill = value;
		this.updateComponents();
		return value;
	}

	private function get_fill():Bool {
		return _fill;
	}

	/**
	 * 缓存资源，如果定义缓存资源，ZImage的异步资源会从这里读取资源
	 */
	public var cacheAssets:CacheAssets;

	/**
	 * 构造一个图像显示对象，允许使用图片、精灵图对象进行设置
	 */
	public function new() {
		super();
		display = new Image(null);
		this.addChild(display);
	}

	override public function initComponents():Void {
		this.updateComponents();
	}

	/**
	 * 自动缩放比例
	 */
	private function updateImageScaleWidthAndHeight():Void {
		if (scaleWidth == 0 && scaleHeight == 0)
			return;
		var w = (scaleWidth == 0 ? this.width : scaleWidth) / this.display.width;
		var h = (scaleHeight == 0 ? this.height : scaleHeight) / this.display.height;
		this.scale(Math.min(w, h));
	}

	override public function updateComponents():Void {
		if (display != null) {
			var data:Dynamic = super.dataProvider;
			if (data != null && data != "") {
				if (Std.isOfType(data, String)) {
					// 新增ZBuilder缓存确认
					var buildBitmapData = ZBuilder.getBaseBitmapData(data);
					if (buildBitmapData != null) {
						display.bitmapData = buildBitmapData;
						updateImageScaleWidthAndHeight();
						onBitmapDataUpdate();
						this.shader = _shader;
					} else {
						var path:String = data;
						// 当为: ${}格式时，则不会进行加载
						if ((path.indexOf("http") != 0 && path.indexOf(":") != -1) || path.indexOf("${") != -1) {
							return;
						}
						if (cacheAssets != null) {
							cacheAssets.loadBitmapData(path, function(bitmapData:BitmapData):Void {
								if (dataProvider != path)
									return;
								if (Std.isOfType(dataProvider, String)) {
									display.bitmapData = bitmapData;
									updateImageScaleWidthAndHeight();
									onBitmapDataUpdate();
									this.shader = _shader;
								}
							});
						} else {
							// 启动异步载入
							Assets.loadBitmapData(path, false).onComplete(function(bitmapData:BitmapData):Void {
								if (dataProvider != path)
									return;
								if (isDispose || !Std.isOfType(dataProvider, String)) {
									ZGC.disposeBitmapData(bitmapData);
									return;
								}
								display.bitmapData = bitmapData;
								updateImageScaleWidthAndHeight();
								onBitmapDataUpdate();
								this.shader = _shader;
								isAysn = true;
							});
						}
					}
				}
				// else if(Std.isOfType(data,BitmapData) || Std.isOfType(data,Frame) || Std.isOfType(data,AsyncFrame))
				else if (Std.isOfType(data, BitmapData) || Std.isOfType(data, Frame)) {
					display.bitmapData = cast data;
					updateImageScaleWidthAndHeight();
					onBitmapDataUpdate();
					this.shader = _shader;
				}
			}
			display.visible = data != null && data != "";
			if (@:privateAccess display._setWidth)
				display.width = @:privateAccess display._width;
			if (@:privateAccess display._setHeight)
				display.height = @:privateAccess display._height;
		}
		if (fill) {
			this.scale(1);
			ZImage.fillStageImage(this);
		}
	}

	#if flash
	@:setter(width)
	public function set_width(value:Float) {
		display.width = value;
		return value;
	}

	@:getter(width)
	public function get_width() {
		return display.width;
	}

	@:setter(height)
	public function set_height(value:Float) {
		display.height = value;
		return value;
	}

	@:getter(height)
	public function get_height() {
		return display.height;
	}
	#else
	private override function set_width(value:Float):Float {
		display.width = value;
		return value;
	}

	private override function set_height(value:Float):Float {
		display.height = value;
		return value;
	}

	private override function get_width():Float {
		return Math.abs(display.width * scaleX);
	}

	private override function get_height():Float {
		return Math.abs(display.height * scaleY);
	}
	#end

	private override function set_dataProvider(data:Dynamic):Dynamic {
		if (super.dataProvider == data) {
			return data;
		}
		if (this.display.bitmapData != null && isAysn && Std.isOfType(this.display.bitmapData, BitmapData)) {
			ZGC.disposeBitmapData(this.display.bitmapData);
			isAysn = false;
		}
		super.dataProvider = data;
		this.updateComponents();
		return data;
	}

	private override function get_dataProvider():Dynamic {
		return super.dataProvider;
	}

	/**
	 * 设置九宫格格式
	 * @param rect 九宫格rect配置
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		display.setScale9Grid(rect);
	}

	/**
	 * 设置着色器对象
	 * @param value 着色器对象
	 * @return Shader
	 */
	override function set_shader(value:Shader):Shader {
		_shader = value;
		if (display != null)
			display.shader = value;
		return value;
	}

	override function get_shader():Shader {
		return _shader;
	}

	/**
	 * 当图片更新时发生的事件
	 */
	dynamic public function onBitmapDataUpdate():Void {}

	override function destroy() {
		super.destroy();
		this.isDispose = true;
		// 如果自身是使用URL载入的，则释放资源
		if (cacheAssets == null && this.display.bitmapData != null && isAysn && Std.isOfType(this.display.bitmapData, BitmapData)) {
			ZGC.disposeBitmapData(this.display.bitmapData);
		}
		this.display.bitmapData = null;
		// this._shader = null;
	}

	override function set_vAlign(value:String):String {
		this.display.vAlign = value;
		return super.set_vAlign(value);
	}

	override function set_hAlign(value:String):String {
		this.display.hAlign = value;
		return super.set_hAlign(value);
	}

	override function alignPivot(?v:Align = null, ?h:Align = null) {
		super.alignPivot(v, h);
		this.display.alignPivot(v, h);
	}

	/**
	 * 设置图片是否平滑，当smoothing宏生效时，默认为true，否则为false
	 */
	public var smoothing(get, set):Bool;

	private function set_smoothing(bool:Bool):Bool {
		this.display.smoothing = bool;
		return bool;
	}

	private function get_smoothing():Bool {
		return this.display.smoothing;
	}

	/**
	 * 为舞台等比例铺满背景，当对ZImage.fill设置为true时，会自动使用此方法的运算处理。
	 * @param display 需要铺满的显示对象
	 */
	public static function fillStageImage(display:ZImage):Void {
		var scale1 = display.getStageWidth() / display.width;
		var scale2 = display.getStageHeight() / display.height;
		var scale = Math.max(scale1, scale2);
		display.scale(scale);
		display.x = (display.getStageWidth() - display.width) / 2;
		display.y = (display.getStageHeight() - display.height) / 2;
	}
}
