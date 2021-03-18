package zygame.components;

import zygame.components.base.DataProviderComponent;
import zygame.components.ZBox;
import openfl.display.DisplayObject;
import openfl.events.TouchEvent;
import zygame.utils.Rect;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.display.Shape;
import zygame.components.ZQuad;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import zygame.components.layout.BaseLayout;
import zygame.utils.load.TextureLoader;
import zygame.display.batch.TouchImageBatchsContainer;

/**
 * 滚动窗口，装载的对象要以0,0作为原点，否则会产生坐标错位的问题。
 */
class ZScroll extends DataProviderComponent {
	/**
	 * 批渲染容器
	 */
	private var touchBatch:TouchImageBatchsContainer;

	/**
	 * 获取批渲染对象，在获取之前，要选进行createImageBatch接口
	 */
	public var batch(get, never):TouchImageBatchsContainer;

	public function get_batch():TouchImageBatchsContainer {
		return touchBatch;
	}

	/**
	 * 创建批渲染对象
	 * @param textures
	 */
	public function createImageBatch(textures:TextureAtlas):Void {
		touchBatch = new TouchImageBatchsContainer(textures);
		touchBatch.getBatchs().width = this.width;
		touchBatch.getBatchs().height = this.height;
		touchBatch.setTouchEvent(false);
		super.addChildAt(touchBatch, 1);
	}

	/**
	 *  容器对象
	 */
	public static inline var VIEW:String = "view";

	/**
	 * 禁用滑动
	 */
	public static inline var OFF:String = "off";

	/**
	 * 启动滑动
	 */
	public static inline var NO:String = "no";

	/**
	 * 自动识别，当宽度或者高度不足时，会进行禁用，其他情况为可用状态
	 */
	public static inline var AUTO:String = "auto";

	private var _bgColor:UInt = 0;

	/**
	 * 竖向滚动条
	 */
	public var vscrollState:String = "auto";

	/**
	 * 横向滚动条
	 */
	public var hscrollState:String = "auto";

	/**
	 * 缓动速率，值越小缓动越久
	 */
	public var slowSpeed:Float = 0.2;

	private var _v:Float = 0;
	private var _h:Float = 0;

	/**
	 * 禁用超屏缓动处理
	 */
	public var disableSuperscreenEasing:Bool = false;

	public function new() {
		super();
		_view = new ZBox();
		_bgDisplay = new ZQuad();
		_bgDisplay.alpha = 0;
	}

	override public function addChild(display:DisplayObject):DisplayObject {
		return _view.addChild(display);
	}

	override public function addChildAt(display:DisplayObject, index:Int):DisplayObject {
		return _view.addChildAt(display, index);
	}

	/**
	 * 获取是否操作拖动正在移动中
	 * @return Bool
	 */
	public function getIsMoveing():Bool {
		return Math.abs(_movePosBegin.x - this.mouseX) > 10 || Math.abs(_movePosBegin.y - this.mouseY) > 10;
	}

	/**
	 * 获取窗口是否正在移动运动中
	 * @return Bool
	 */
	public function isMoveing():Bool {
		return _moveMath != 0;
	}

	private var _view:ZBox;

	private var _bgDisplay:ZQuad;

	/**
	 * 设置背景颜色
	 * @param u -
	 */
	public function setBackgroundColor(u:UInt):Void {
		_bgColor = u;
		_bgDisplay.alpha = 1;
		_bgDisplay.color = u;
		_bgDisplay.width = this.width;
		_bgDisplay.height = this.height;
	}

	/**
	 * 设置背景的透明度
	 * @param f -
	 */
	public function setBackgroundAlpha(f:Float):Void {
		_bgDisplay.alpha = f;
	}

	override public function updateComponents():Void {
		if (_view != null)
			_view.updateComponents();
	}

	override public function initComponents():Void {
		super.addChildAt(_view, 0);
		this.addComponent(_view, VIEW);
		_movePosBegin = new Point();
		_boxPosBegin = new Point();
		_movePos = new Point();
		_lastMovePos = new Point();
		this.cutRect = new Rect(0, 0, this.width, this.height);

		super.addChildAt(_bgDisplay, 0);
		_bgDisplay.color = _bgColor;
		_bgDisplay.width = width;
		_bgDisplay.height = height;
	}

	private var _cutRect:Rect;
	private var _cutRect2:Rectangle = new Rectangle();

	// private var _cutSpr:ZQuad;
	public var cutRect(get, set):Rect;

	private function get_cutRect():Rect {
		return _cutRect;
	}

	private function set_cutRect(rect:Rect):Rect {
		if (_cutRect != rect) {
			if (_cutRect != null)
				_cutRect.removeEventListener(Event.CHANGE, _onSizeChange);
			if (rect != null)
				rect.addEventListener(Event.CHANGE, _onSizeChange);
		}
		_cutRect = rect;
		if (rect != null) {
			_onSizeChange(null);
		} else {
			this.mask = null;
		}
		return rect;
	}

	private function _onSizeChange(e:Event):Void {
		_cutRect2.x = -_h;
		_cutRect2.y = -_v;
		_cutRect2.width = this._cutRect.width;
		_cutRect2.height = this._cutRect.height;
		this._view.scrollRect = _cutRect2;
		if (this.batch != null) {
			this.batch.getBatchs().getBSprite().y = _v;
			// this.batch.scrollRect = _cutRect2;
		}
		#if !flash
		this.invalidate();
		#end
	}

	private var _width:Float = 0;
	private var _height:Float = 0;

	#if flash @:setter(width) #else override #end private function set_width(value:Float):Float {
		_width = value;
		if (_bgDisplay != null) {
			_bgDisplay.width = value;
		}
		if (batch != null)
			batch.width = value;
		if (cutRect != null)
			cutRect.width = value;
		return value;
	}

	#if flash @:setter(height) #else override #end function set_height(value:Float):Float {
		_height = value;
		if (_bgDisplay != null) {
			_bgDisplay.height = value;
		}
		if (batch != null)
			batch.height = value;
		if (cutRect != null)
			cutRect.height = value;
		return value;
	}

	#if flash @:getter(width) #else override #end private function get_width():Float {
		return _width;
	}

	#if flash @:getter(height) #else override #end private function get_height():Float {
		return _height;
	}

	/**
	 *  点击的初始化位置
	 */
	private var _movePosBegin:Point;

	private var _boxPosBegin:Point;
	private var _isMove:Bool = false;
	private var _moveMath:Int = 0;
	private var _movePos:Point;
	private var _lastMovePos:Point;
	private var _vMoveing:Bool = false;
	private var _hMoveing:Bool = false;

	override public function onTouchBegin(touch:TouchEvent):Void {
		super.onTouchBegin(touch);
		if (this.mouseX < 0 || this.mouseY < 0 || this.mouseX > this.width || this.mouseY > this.height)
			return;
		if (touchBatch != null)
			touchBatch.onTouchBegin(touch);
		if (touch.touchPointID != 0)
			return;

		_isMove = true;
		_boxPosBegin.x = _h;
		_boxPosBegin.y = _v;
		_movePosBegin.x = this.mouseX;
		_movePosBegin.y = this.mouseY;
		_lastMovePos.x = this.mouseX;
		_lastMovePos.y = this.mouseY;
		_movePos.x = 0;
		_movePos.y = 0;
		_vMoveing = true;
		_hMoveing = true;

		if (this.view.height < this.height) {
			_vMoveing = false;
		}
		if (this.view.width < this.width) {
			_hMoveing = false;
		}
	}

	override public function onTouchMove(touch:TouchEvent):Void {
		if (touchBatch != null)
			touchBatch.onTouchMove(touch);
		if (_isMove && touch.touchPointID == 0 && getIsMoveing()) {
			if (hscrollState != OFF && _hMoveing)
				_h = _boxPosBegin.x - (_movePosBegin.x - this.mouseX);
			if (vscrollState != OFF && _vMoveing)
				_v = _boxPosBegin.y - (_movePosBegin.y - this.mouseY);

			var rx:Float = _lastMovePos.x - this.mouseX;
			var ry:Float = _lastMovePos.y - this.mouseY;

			var mx:Float = Math.abs(rx);
			var my:Float = Math.abs(ry);
			if (mx > 10 || my > 10) {
				_moveMath = 5;
			}

			if (mx > Math.abs(_movePos.x) || (rx > 0) != (_movePos.x > 0))
				_movePos.x = (_lastMovePos.x - this.mouseX);
			if (my > Math.abs(_movePos.y) || (ry > 0) != (_movePos.y > 0))
				_movePos.y = (_lastMovePos.y - this.mouseY);
			_lastMovePos.x = this.mouseX;
			_lastMovePos.y = this.mouseY;
			updateDisableSuperscreenEasing();
		}
	}

	override public function onTouchEnd(touch:TouchEvent):Void {
		if (touchBatch != null)
			touchBatch.onTouchEnd(touch);
		if (touch.touchPointID == 0) {
			_isMove = false;
			if (_moveMath == 0) {
				if (Std.int(_h) > 0 || viewWidth < this.width)
					_moveMath = 1;
				else if (Std.int(_h) < this.width - viewWidth)
					_moveMath = 1;
				if (Std.int(_v) > 0 || viewHeight < this.height)
					_moveMath = 1;
				else if (Std.int(_v) < this.height - viewHeight)
					_moveMath = 1;
				else
					_moveMath = 0;
				_movePos.x = 0;
				_movePos.y = 0;
			}
		}
	}

	override public function onFrame():Void {
		if (!_isMove && _moveMath > 0) {
			if (Std.int(_movePos.x) == 0 && Std.int(_movePos.y) == 0) {
				// Y轴适配
				if (vscrollState != OFF && _vMoveing) {
					if (Std.int(_v) > 0 || viewHeight < this.height)
						_v -= (_v) * slowSpeed;
					else if (Std.int(_v) < this.height - viewHeight)
						_v += ((this.height - viewHeight) - _v) * slowSpeed;
					else
						_vMoveing = false;
				} else {
					_vMoveing = false;
				}

				// X轴适配
				if (hscrollState != OFF && _hMoveing) {
					if (Std.int(_h) > 0 || viewWidth < this.width)
						_h -= (_h) * slowSpeed;
					else if (Std.int(_h) < this.width - viewWidth)
						_h += ((this.width - viewWidth) - _h) * slowSpeed;
					else
						_hMoveing = false;
				} else {
					_hMoveing = false;
				}

				if (_vMoveing == false && _hMoveing == false) {
					_moveMath = 0;
				}
			} else {
				if (hscrollState != OFF && _hMoveing) {
					_movePos.x -= (_movePos.x) * slowSpeed;
					_h -= _movePos.x;
				} else
					_movePos.x = 0;
				if (vscrollState != OFF && _vMoveing) {
					_movePos.y -= (_movePos.y) * slowSpeed;
					_v -= _movePos.y;
				} else
					_movePos.y = 0;
			}

			_v = Std.int(_v);
			_h = Std.int(_h);
		} else {
			_moveMath -= _moveMath > 0 ? 1 : 0;
		}

		updateDisableSuperscreenEasing();

		_onSizeChange(null);
	}

	private function updateDisableSuperscreenEasing():Void {
		// 禁用超屏缓动
		if (disableSuperscreenEasing) {
			if (this.height > viewHeight) {
				_v = 0;
			} else if (Std.int(_v) > 0)
				_v = 0;
			else if (Std.int(_v) < this.height - viewHeight) {
				_v = this.height - viewHeight;
			}
			if (this.width > viewWidth) {
				_h = 0;
			} else if (Std.int(_h) > 0)
				_h = 0;
			else if (Std.int(_h) < this.width - viewWidth) {
				_h = this.width - viewWidth;
			}
		}
	}

	/**
	 * 获取容器的实际宽度
	 */
	public var viewWidth(get, never):Float;

	/**
	 * 获取容器的实际高度
	 */
	public var viewHeight(get, never):Float;

	private function get_viewWidth():Float {
		return _view.width;
	}

	private function get_viewHeight():Float {
		return _view.height;
	}

	/**
	 * 竖向滚动点
	 */
	public var vscroll(get, set):Float;

	/**
	 * 横向滚动点
	 */
	public var hscroll(get, set):Float;

	private function get_vscroll():Float {
		return -_v;
	}

	private function set_vscroll(value:Float):Float {
		_v = -value;
		_vMoveing = true;
		if (this.cutRect != null) {
			_onSizeChange(null);
			updateComponents();
		}
		return value;
	}

	private function get_hscroll():Float {
		return -_h;
	}

	private function set_hscroll(value:Float):Float {
		_h = -value;
		_hMoveing = true;
		if (this.cutRect != null) {
			_onSizeChange(null);
			updateComponents();
		}
		return value;
	}

	/**
	 * 获取存放容器
	 */
	public var view(get, never):ZBox;

	private function get_view():ZBox {
		return _view;
	}

	/**
	 * 设置布局对象，用于控制Box里的容器显示位置
	 */
	public var layout(get, set):BaseLayout;

	private function get_layout():BaseLayout {
		return _view.layout;
	}

	private function set_layout(value:BaseLayout):BaseLayout {
		_view.layout = value;
		return value;
	}

	override public function onAddToStage():Void {
		this.setTouchEvent(true);
		this.setFrameEvent(true);
	}

	override public function onRemoveToStage():Void {
		this.setTouchEvent(false);
		this.setFrameEvent(false);
	}

	override public function onRemove() {
		super.onRemove();
	}
}
