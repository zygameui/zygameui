package zygame.display;

import zygame.core.Start;
import zygame.components.ZBuilder.Builder;
import zygame.core.Refresher;
import openfl.display.Sprite;
import openfl.events.Event;
import zygame.utils.Log;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;

class DisplayObjectContainer extends Sprite implements Refresher implements zygame.mini.MiniExtend {

	/**
	 * 自定义数据，默认为null，可以作为扩展数据使用
	 */
	public var customData:Dynamic;

	/**
	 * 基础生成baseBuilder，该属性只有通过MiniEngine创建时生效。
	 */
	public var baseBuilder:Builder;

	public var isInit:Bool = false;

	public var subtractionHeight:Int = 0;

	/**
	 * 绑定类型，Maplive可用
	 */
	public var bindType:String = null;

	/**
	 * 横向对齐实现
	 */
	public var hAlign(get,set):String;
	private var _hAlign:String = "left";
	private function get_hAlign():String
	{
		return _hAlign;
	}
	private function set_hAlign(value:String):String
	{
		_hAlign = value;
		alignPivot(_vAlign,_hAlign);
		return value;
	}

	/**
	 * 竖向对齐实现
	 */
	public var vAlign(get,set):String;
	private var _vAlign:String = "top";
	private function get_vAlign():String
	{
		return _vAlign;
	}
	private function set_vAlign(value:String):String
	{
		_vAlign = value;
		alignPivot(_vAlign,_hAlign);
		return value;
	}

	public function new() {
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onInitEvent);
		this.addEventListener(Event.REMOVED, onSelftRemove);
		this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveEvent);
	}

	/**
	 * 当真实自已被删掉时
	 * @param e
	 */
	private function onSelftRemove(e:Event):Void {
		onRemove();
	}

	public function onInitEvent(e:Event):Void {
		if (!isInit) {
			isInit = true;
			this.onInit();
		}
		onAddToStage();
	}

	/**
	 *  初始化接口
	 */
	public function onInit():Void {
        if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onInit");
			if (call != null)
				call();
		}
    }

	/**
	 *  帧事件接口
	 */
	public function onFrame():Void {
		if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onFrame");
			if (call != null)
				call();
		}
	}

	/**
	 *  经过了缩放计算的舞台宽度
	 *  @return Float
	 */
	public function getStageWidth():Float {
		return zygame.core.Start.stageWidth;
	}

	/**
	 *  经过了缩放计算的舞台高度
	 *  @return Float
	 */
	public function getStageHeight():Float {
		return zygame.core.Start.stageHeight - subtractionHeight;
	}

	/**
	 * 获取最顶层的容器
	 * @return DisplayObjectContainer
	 */
	public function getTopView():DisplayObjectContainer {
		return zygame.core.Start.current.topView;
	}

	/**
	 * 获取高度削减高度
	 * @return Float
	 */
	public function getSubtractionHeight():Int {
		return subtractionHeight;
	}

	/**
	 * 设置舞台高度削减
	 * @param height
	 */
	public function setSubtractionStageHeight(height:Int):Void {
		this.subtractionHeight = height;
	}

	/**
	 *  锚点对齐，不能直接对齐调用，容器不直接支持该功能。
	 */
	public function alignPivot(v:String = null, h:String = null):Void {
		_vAlign = v;
		_hAlign = h;
	}

	/**
	 *  设置帧事件使用
	 *  @param listen - 是否侦听
	 */
	public function setFrameEvent(listen:Bool):Void {
		if (listen)
			zygame.core.Start.current.addToUpdate(this);
		else
			zygame.core.Start.current.removeToUpdate(this);
	}

	/**
	 *  移除事件
	 *  @param e -
	 */
	private function onRemoveEvent(e:Event):Void {
		onRemoveToStage();
	}

	/**
	 *  缩放处理
	 *  @param f -
	 *  @return DisplayObjectContainer
	 */
	public function scale(f:Float):DisplayObjectContainer {
		this.scaleX = f;
		this.scaleY = f;
		return this;
	}

	/**
	 *  输出log
	 */
	public function log(a:Dynamic, b:Dynamic = "", c:Dynamic = "", d:Dynamic = "", e:Dynamic = "", f:Dynamic = ""):Void {
		#if (mac)
		Log.log(a + " " + b + " " + c + " " + d + " " + e + " " + f);
		#else
		trace(a, b, c, d, e, f);
		#end
	}

	/**
	 *  释放接口实现
	 */
	public function destroy():Void {
		for (i in 0...this.numChildren) {
			var child:openfl.display.DisplayObject = this.getChildAt(i);
			if (Std.is(child, DisplayObjectContainer)) {
				cast(child, DisplayObjectContainer).destroy();
			}
		}
	}

	/**
	 * 当自已被删掉时
	 */
	public function onRemove():Void {}

	/**
	 * 当从舞台移除时
	 */
	public function onRemoveToStage():Void {}

	/**
	 * 当添加到舞台时
	 */
	public function onAddToStage():Void {}

	/**
	 * 获取屏幕比例，>= 0.62的基本是平板尺寸
	 * @return Float
	 */
	public function getAspectRatio():Float {
		return Start.current.stage.stageWidth / Start.current.stage.stageHeight;
	}

	/**
	 * getBounds优化计算
	 * @param parent
	 * @return openfl.geom.Rectangle
	 */
	public override function getBounds(target:openfl.display.DisplayObject):openfl.geom.Rectangle {
		var rect:Rectangle = super.getBounds(target);
		// if (rect.width < width)
		// 	rect.width = width;
		// if (rect.height < height)
		// 	rect.height = height;
		return rect;
	}
}
