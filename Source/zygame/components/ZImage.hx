package zygame.components;

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
 *  支持使用图片路径、以及位图设置内容
 */
class ZImage extends DataProviderComponent {
	private var isDispose:Bool = false;

	private var isAysn:Bool = false;

	private var _shader:Shader;

	public var display:Image;

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
			if (data != null) {
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
						if (cacheAssets != null) {
							cacheAssets.loadBitmapData(path, function(bitmapData:BitmapData):Void {
								display.bitmapData = bitmapData;
								updateImageScaleWidthAndHeight();
								onBitmapDataUpdate();
								this.shader = _shader;
							});
						} else {
							// 启动异步载入
							Assets.loadBitmapData(path, false).onComplete(function(bitmapData:BitmapData):Void {
								if (isDispose) {
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
			display.visible = data != null;
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
	 * @param rect
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		display.setScale9Grid(rect);
	}

	/**
	 * 设置着色器
	 * @param value
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
	 * 当图片异步载入更新后发生
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
		this._shader = null;
	}

	override function set_vAlign(value:String):String {
		this.display.vAlign = value;
		return super.set_vAlign(value);
	}

	override function set_hAlign(value:String):String {
		this.display.hAlign = value;
		return super.set_hAlign(value);
	}

	override function alignPivot(?v:String = null, ?h:String = null) {
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

	override private function __update(transformOnly:Bool, updateChildren:Bool):Void {
		super.__update(transformOnly, updateChildren);
	}

	/**
	 * 为舞台等比例铺满背景
	 * @param display 
	 */
	public static function fillStageImage(display:ZImage):Void {
		var scale1 = display.width / display.getStageWidth();
		var scale2 = display.height / display.getStageHeight();
		var scale = Math.max(scale1, scale2);
		display.scale(scale);
		display.x = (display.getStageWidth() - display.width) / 2;
		display.y = (display.getStageHeight() - display.height) / 2;
	}
}
