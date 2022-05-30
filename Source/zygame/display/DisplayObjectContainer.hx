package zygame.display;

import openfl.display.Stage;
import zygame.utils.ZSceneManager;
import zygame.components.ZScene;
import zygame.utils.Align;
import zygame.utils.ScaleUtils;
import zygame.utils.Lib;
import openfl.geom.Point;
import zygame.components.ZTween;
import zygame.core.Start;
import zygame.components.ZBuilder.Builder;
import zygame.core.Refresher;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;

/**
 * 引擎中的基础容器，它实现了基础的生命周期的方法：
 * `onInit`会在addChild之后触发
 * `onRemove`当发生移除时触发
 * `onAddToStage`当添加到舞台时发生
 * `onRemoveToStage`当从舞台移除时发生
 */
@:access(openfl.display.DisplayObject)
class DisplayObjectContainer extends Sprite implements Refresher implements zygame.mini.MiniExtend {
	/**
	 * 自适配宽度
	 */
	private var _hdwidth:Null<Float> = null;

	/**
	 * 自适配高度
	 */
	private var _hdheight:Null<Float> = null;

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

	private var _scrollMaskDislayObject:DisplayObject;
	private var _scrollMaskDislayObjectRect:Rectangle;

	/**
	 * 动画配置：这里设置的ZTween将仅影响当前容器的动画
	 */
	public var tween(get, set):ZTween;

	private var _tween:ZTween;

	function get_tween():ZTween {
		return _tween;
	}

	function set_tween(value:ZTween):ZTween {
		if (_tween != null) {
			_tween.stop();
		}
		_tween = value;
		if (_tween != null && this.parent != null) {
			Lib.nextFrameCall(_tween.bindDisplayObject, [this]);
		}
		return _tween;
	}

	/**
	 * Bate功能：遮罩对象（依赖scrollRect实现的遮罩逻辑实现）
	 */
	@:noCompletion public var scrollMaskDislayObject(get, set):DisplayObject;

	private function get_scrollMaskDislayObject():DisplayObject {
		return _scrollMaskDislayObject;
	}

	private function set_scrollMaskDislayObject(value:DisplayObject):DisplayObject {
		_scrollMaskDislayObject = value;
		if (_scrollMaskDislayObject == null) {
			this.scrollRect = null;
			return null;
		}
		_scrollMaskDislayObject.visible = true;
		if (_scrollMaskDislayObjectRect == null)
			_scrollMaskDislayObjectRect = new Rectangle();
		_scrollMaskDislayObjectRect.x = value.x + super.get_x();
		_scrollMaskDislayObjectRect.y = value.y + super.get_y();
		_scrollMaskDislayObjectRect.width = value.width;
		_scrollMaskDislayObjectRect.height = value.height;
		this.scrollRect = _scrollMaskDislayObjectRect;
		_scrollMaskDislayObject.visible = false;
		return value;
	}

	/**
	 * 绑定类型，Maplive可用
	 */
	public var bindType:String = null;

	/**
	 * 横向对齐实现
	 */
	public var hAlign(get, set):Align;

	private var _hAlign:Align = "left";

	private function get_hAlign():Align {
		return _hAlign;
	}

	private function set_hAlign(value:Align):Align {
		_hAlign = value;
		alignPivot(_vAlign, _hAlign);
		return value;
	}

	/**
	 * 竖向对齐实现
	 */
	public var vAlign(get, set):Align;

	private var _vAlign:Align = "top";

	private function get_vAlign():Align {
		return _vAlign;
	}

	private function set_vAlign(value:Align):Align {
		_vAlign = value;
		alignPivot(_vAlign, _hAlign);
		return value;
	}

	public function new() {
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onInitEvent);
		this.addEventListener(Event.REMOVED, onSelfRemove);
		this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveEvent);
	}

	/**
	 * 当真实自已被删掉时
	 * @param e
	 */
	private function onSelfRemove(e:Event):Void {
		onRemove();
	}

	/**
	 * 初始化事件
	 * @param e 
	 */
	public function onInitEvent(e:Event):Void {
		var add_to_state:Bool = e.type == Event.ADDED_TO_STAGE;
		if (!isInit) {
			isInit = true;
			this.onInit();
		}
		if (add_to_state)
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
	 * 舞台大小适配变化，为该容器设置设计尺寸，可以在不同的分辨率下，使用不同的设计尺寸；如果设置为null，则使用全局的设计尺寸。
	 * @param width 设置hdwidth宽度
	 * @param height 设置hdheight高度
	 * @param scaleMath 是否需要实装缩放处理
	 */
	public function onSizeChange(width:Null<Float>, height:Null<Float>, scaleMath:Bool = true):Void {
		var currentScale = ScaleUtils.mathScale(getStageWidth(), getStageHeight(), width, height, false, false);
		if (scaleMath)
			this.scale(currentScale);
		_hdwidth = Std.int(getStageWidth() / currentScale) + 1;
		_hdheight = Std.int(getStageHeight() / currentScale) + 1;
	}

	/**
	 *  经过了缩放计算的舞台宽度
	 *  @return Float
	 */
	public function getStageWidth():Float {
		return _hdwidth != null ? _hdwidth : zygame.core.Start.stageWidth;
	}

	/**
	 *  经过了缩放计算的舞台高度
	 *  @return Float
	 */
	public function getStageHeight():Float {
		return _hdheight != null ? _hdheight : zygame.core.Start.stageHeight - subtractionHeight;
	}

	/**
	 * 获取最顶层的容器
	 * @return DisplayObjectContainer
	 */
	public function getTopView():DisplayObjectContainer {
		return zygame.core.Start.current.topView;
	}

	/**
	 * 直接获得舞台对象
	 * @return Stage
	 */
	public function getStage():Stage {
		return zygame.core.Start.current.stage;
	}

	/**
	 * 获取当前显示的场景
	 * @return ZScene
	 */
	public function getCurrentScene():ZScene {
		return ZSceneManager.current.getCurrentScene();
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
	public function alignPivot(v:Align = null, h:Align = null):Void {
		_vAlign = v;
		_hAlign = h;
	}

	/**
	 *  设置帧事件使用
	 * @param listen - 是否侦听
	 */
	public function setFrameEvent(listen:Bool):Void {
		if (listen)
			zygame.core.Start.current.addToUpdate(this);
		else
			zygame.core.Start.current.removeToUpdate(this);
	}

	/**
	 * 重写该方法触发addChild之后的onInit事件
	 * @param event 
	 * @return Bool
	 */
	@:noCompletion override private function __dispatchWithCapture(event:Event):Bool {
		if (event.type == Event.ADDED) {
			if (this.hasEventListener(Event.ADDED_TO_STAGE)) {
				onInitEvent(event);
			}
		}
		return super.__dispatchWithCapture(event);
	}

	/**
		*移除事件
		* @param e -
	 */
	private function onRemoveEvent(e:Event):Void {
		onRemoveToStage();
	}

	/**
	 *  缩放处理
	 * @param f -
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
		#if (mac && !hl)
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
			if (Std.isOfType(child, DisplayObjectContainer)) {
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
	 * 4.7 全屏屏
	 * 5.7 IPHON8
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
		return rect;
	}

	/**
	 * 从Start层转换最终坐标点
	 * @return Point
	 */
	public function localToGlobalInParentStart(point:Point):Point {
		point = this.parent.localToGlobal(point);
		point = Start.current.globalToLocal(point);
		return point;
	}

	/**
	 * 获取当前onFrame的延迟值
	 */
	public var delay(get, never):Float;

	function get_delay():Float {
		return Start.current.frameDt;
	}

	/**
	 * 获取当前onFrame的延迟缩放值，可用于加速计算
	 */
	public var delayScale(get, never):Float;

	function get_delayScale():Float {
		return Start.current.frameDtScale;
	}
}
