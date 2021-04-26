package zygame.components;

import zygame.shader.TextStrokeShader;
import zygame.utils.Lib;
#if html5
import zygame.components.input.HTML5TextInput;
#end
import openfl.geom.Point;
import openfl.text.TextField;
import zygame.components.base.DataProviderComponent;
import openfl.text.TextFormat;
import zygame.utils.Align;
import openfl.text.TextFieldType;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import zygame.components.base.ZTextField;

enum ZLabelRenderType {
	NATIVE;
	CACHE;
}

/**
 * 文本类，用于显示文本内容使用的显示对象，可设置文本的一些基础属性，通过dataProvider进行赋值文本内容。
 */
@:keep
class ZLabel extends DataProviderComponent {
	/**
	 * 渲染模式：
	 * 系统文字ZLabelRenderType.NATIVE，使用系统fillText渲染。
	 * 缓存文字ZLabelRenderType.CACHE，使用缓存文字的基础上渲染。
	 */
	public static var renderType = NATIVE;

	private var _defaultDisplay:ZTextField;

	private var _display:ZTextField;

	private var _font:TextFormat;

	private var _isHtml:Bool;

	private var _width:Float = 100;

	private var _height:Float = 0;

	private var __height:Float = 0;

	public var igoneChars:Array<String> = [];

	private var __point:Point = new Point();

	/**
	 * 缩放系数
	 */
	private var _scale:Float = #if (html5 && !un_scale_label) 2 #else 1 #end;

	//  private var _scale:Float = 1;

	/**
	 * 光标色块
	 */
	private var zquad:ZQuad;

	private var quadshowtime:Int = 0;
	private var quadhidetime:Int = 30;
	private var curstate:Bool = false;
	private var rect:Rectangle;

	/**
	 * 默认文本
	 */
	public var defaultText(get, set):String;

	private function set_defaultText(value:String):String {
		if (_defaultDisplay == null)
			updatedefaultText();
		this.updateComponents();
		_defaultDisplay.text = value;
		return value;
	}

	private function get_defaultText():String {
		return _defaultDisplay == null ? "" : _defaultDisplay.text;
	}

	private var _maxChars:Int = 0;

	public var maxChars(get, set):UInt;

	private function set_maxChars(value:Int):Int {
		if (_defaultDisplay == null)
			updatedefaultText();
		_defaultDisplay.maxChars = value;
		_display.maxChars = value;
		_maxChars = value;
		return value;
	}

	private function get_maxChars():Int {
		if (_defaultDisplay == null)
			updatedefaultText();
		return _defaultDisplay.maxChars;
	}

	/**
	 * 默认字颜色
	 */
	public var defaultColor(get, set):UInt;

	private function set_defaultColor(value:UInt):UInt {
		if (_defaultDisplay == null)
			updatedefaultText();
		this.updateComponents();
		_defaultDisplay.textColor = value;
		return value;
	}

	private function updatedefaultText():Void {
		if (_defaultDisplay == null) {
			_defaultDisplay = new ZTextField();
			this.addChild(_defaultDisplay);
		}
		_defaultDisplay.wordWrap = _display.wordWrap;
		_defaultDisplay.scaleX = 1 / _scale;
		_defaultDisplay.scaleY = 1 / _scale;
		_defaultDisplay.width = _display.width * _scale;
		_defaultDisplay.height = _display.height * _scale;
		_defaultDisplay.mouseEnabled = #if cpp true #else false #end;
		var oldColor:UInt = _font.color;
		_font.color = defaultColor;
		_defaultDisplay.setTextFormat(_font);
		_font.color = oldColor;
	}

	private function get_defaultColor():UInt {
		return _defaultDisplay == null ? 0 : _defaultDisplay.textColor;
	}

	public function new() {
		super();
		_display = new ZTextField();
		#if ios
		_font = new TextFormat("assets/" + zygame.components.base.ZConfig.fontName);
		#else
		_font = new TextFormat(zygame.components.base.ZConfig.fontName);
		#end
		_font.size = 24;
		_display.scaleX = 1 / _scale;
		_display.scaleY = 1 / _scale;
		_display.width = 0;
		_display.height = 0;
		_display.setTextFormat(_font);
		_display.wordWrap = true;
		_display.selectable = false;
		_display.addEventListener("change", (_) -> {
			this.updateComponents();
		});
		this.mouseChildren = false;
		zquad = new ZQuad();
		zquad.visible = false;
		this.vAlign = Align.CENTER;
	}

	override private function set_vAlign(value:String):String {
		super.set_vAlign(value);
		updateComponents();
		return value;
	}

	override private function set_hAlign(value:String):String {
		super.set_hAlign(value);
		updateComponents();
		return value;
	}

	override public function initComponents():Void {
		this.addChild(_display);
		this.addChild(zquad);
	}

	private static function _getCurrentScale():Float {
		if (zygame.core.Start.currentScale < 1) {
			return 1;
		} else {
			return zygame.core.Start.currentScale;
		}
	}

	private function updateTextXY(txt:TextField):Void {
		var txtHeight:Float = _display.textHeight;
		// 新版本是否不再需要移动位移？
		// #if (quickgame)
		// _display.y -= 5;
		// #end
		#if (openfl < '9.0.0')
		if (this.height < txtHeight * this.scaleY / _scale #if quickgame_scale / _getCurrentScale() #end)
			this.height = txtHeight * this.scaleY / _scale #if quickgame_scale / _getCurrentScale() #end + 32;
		#else
		if (this.__height < txtHeight * this.scaleY / _scale #if quickgame_scale / _getCurrentScale() #end) {
			this._height = txtHeight * this.scaleY / _scale #if quickgame_scale / _getCurrentScale() #end;
		} else if (__height != 0 && __height != _height) {
			this._height = __height;
		}
		_display.height = _height;
		#end
		if (txtHeight == 0)
			txtHeight = _font.size;
		switch (hAlign) {
			case Align.LEFT:
				txt.x = 0;
			case Align.RIGHT:
				txt.x = _width - txt.textWidth / _scale #if quickgame_scale / _getCurrentScale() #end;
			case Align.CENTER:
				txt.x = _width / 2 - txt.textWidth / _scale / 2 #if quickgame_scale / _getCurrentScale() #end;
				#if quickgame_scale
				txt.x -= (_width - _width / _getCurrentScale()) / 2;
				#end
		}
		switch (vAlign) {
			case Align.TOP:
				txt.y = 0;
			case Align.BOTTOM:
				txt.y = _height - txtHeight / _scale #if quickgame_scale / _getCurrentScale() #end;
			case Align.CENTER:
				txt.y = _height / 2 - txtHeight / _scale / 2 #if quickgame_scale / _getCurrentScale() #end;
				#if quickgame_scale
				txt.y -= (_height - _height / _getCurrentScale()) / 2;
				#end
		}
	}

	override public function updateComponents():Void {
		_display.width = _width * _scale;
		_display.height = _height;

		for (text in igoneChars) {
			_display.text = StringTools.replace(_display.text, text, "");
		}

		this.updateTextXY(_display);

		// 更新可选区域
		this.scrollRect = new Rectangle(0, 0, this.width, this.height);

		// 光标实现
		if (zquad.visible) {
			if (_display.text.length > 0) {
				rect = _display.getCharBoundaries(_display.text.length - 1);
				if (rect != null) {
					zquad.x = (rect.x + rect.width) / _scale + _display.x;
					zquad.y = (rect.y) / _scale + _font.size * 0.168 / _scale + _display.y;
				}
			} else {
				zquad.x = _display.x;
				zquad.y = _font.size * 0.168 / _scale + _display.y;
			}
		} else {
			zquad.x = _display.x;
			zquad.y = _font.size * 0.168 / _scale + _display.y;
		}
		// 默认文本实现
		if (_defaultDisplay != null) {
			updatedefaultText();
			if (_display.text.length == 0) {
				this.updateTextXY(_defaultDisplay);
				_defaultDisplay.visible = true;
			} else {
				_defaultDisplay.visible = false;
			}
		}
		_display.width = _display.textWidth + 5;
		_display.height = _display.textHeight + 5;
		if (_defaultDisplay != null) {
			_defaultDisplay.width = _defaultDisplay.textWidth + 5;
			_defaultDisplay.height = _defaultDisplay.textHeight + 5;
		}
	}

	override private function get_dataProvider():Dynamic {
		if (_isHtml)
			return _display.htmlText;
		else {
			return _display.text;
		}
	}

	override private function set_dataProvider(value:Dynamic):Dynamic {
		value = Std.string(value);
		super.dataProvider = value;
		if (value != null && value.length > _maxChars) {
			if (_maxChars != 0) {
				value = value.substr(0, _maxChars);
			}
		}
		if (getDisplay().wordWrap == false) {
			value = StringTools.replace(value, "\n", "");
			value = StringTools.replace(value, "\r", "");
		}
		#if !wechat
		#if (quickgame || qqquick || minigame)
		// 快游戏引擎不会清理文本画布，请在这里进行清理
		if (untyped _display.__graphics.__context != null)
			untyped _display.__graphics.__context.clearRect(0, 0, _display.__graphics.__canvas.width, _display.__graphics.__canvas.height);
		#end
		#end
		// 多国语言化
		#if (!neko && !hl)
		if (value != null && Std.isOfType(value, String) && value.indexOf("@") == 0)
			value = zygame.utils.LanguageUtils.getText(value);
		#end
		if (_isHtml)
			_display.htmlText = value;
		else {
			if (_display.text == value)
				return value;
			#if (cpp && openfl < '9.0.0')
			// OpenFL8.9.0文本无法实时刷新区域。（7.2.5开始默认实现）
			if (_display != null) {
				var newText = new ZTextField();
				newText.width = _display.width;
				newText.height = _display.height;
				newText.scaleX = 1 / _scale;
				newText.scaleY = 1 / _scale;
				newText.setTextFormat(_font);
				newText.wordWrap = true;
				newText.selectable = false;
				newText.maxChars = _display.maxChars;
				this.removeChild(_display);
				_display = newText;
				this.addChild(_display);
			}
			#end
			// 不再主动调用__cleanup();
			// if (_display.text != Std.string(value))
			// 	@:privateAccess _display.__cleanup();
			_display.text = Std.string(value);
		}
		// 修复9.0.0设置无法正常格式化问题
		_display.setTextFormat(_font);
		// 刷新内容
		updateComponents();
		return value;
	}

	public function selectText(start:Int = 0, len:Int = -1):Void {
		if (_display.selectable && _display.type == TextFieldType.INPUT)
			_display.setSelection(start, len == -1 ? _display.text.length : len);
	}

	override private function set_width(value:Float):Float {
		_width = value #if quickgame_scale * _getCurrentScale() #end;
		updateComponents();
		return value;
	}

	override private function get_width():Float {
		return Math.abs(_width #if quickgame_scale / _getCurrentScale() #end * this.scaleX);
	}

	override private function set_height(value:Float):Float {
		_height = value #if quickgame_scale * _getCurrentScale() #end;
		__height = value;
		updateComponents();
		return value;
	}

	override private function get_height():Float {
		return Math.abs(_height #if quickgame_scale / _getCurrentScale() #end * this.scaleY);
	}

	public function getTextHeight():Float {
		return _display.textHeight / _scale;
	}

	public function getTextWidth():Float {
		return _display.textWidth / _scale;
	}

	/**
	 * 设置文本字体大小
	 * @param font
	 */
	public function setFontSize(font:Int):Void {
		#if (quickgame_scale)
		// 快游戏兼容,OPPO新版本已修复这个问题。
		font = Std.int(font * zygame.core.Start.currentScale);
		#end
		_font.size = Std.int(font * _scale);
		_display.setTextFormat(_font);
		zquad.width = 2;
		zquad.height = font;
		updateComponents();
	}

	/**
	 * 设置文本的颜色
	 * @param color
	 */
	public function setFontColor(color:UInt):Void {
		_font.color = color;
		zquad.color = color;
		_display.setTextFormat(_font);
		updateComponents();
	}

	/**
	 * 设置HTML标签文本，但在部分设备上渲染可能会存在问题，建议使用简易格式的渲染。
	 * @param bool
	 */
	public function setHtml(bool:Bool):Void {
		_isHtml = bool;
		this.dataProvider = this.dataProvider;
	}

	/**
	 * 设置文本是否可选择
	 * @param bool
	 */
	public function setSelectable(bool:Bool):Void {
		_display.selectable = bool;
	}

	/**
	 * 设置是否可换行
	 * @param bool
	 */
	public function setWordWrap(bool:Bool):Void {
		_display.wordWrap = bool;
	}

	/**
	 * 设置是否可以输入
	 * @param bool
	 */
	public function setIsInput(bool:Bool):Void {
		#if (minigame || ios || android || html5)
		// 小游戏模式需要实现输入
		this.mouseChildren = false;
		if (bool) {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMiniGameInputDown);
			this.addEventListener(MouseEvent.CLICK, onMiniGameInput);
		} else {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMiniGameInputDown);
			this.removeEventListener(MouseEvent.CLICK, onMiniGameInput);
		}
		#else
		this.mouseChildren = false;
		if (bool) {
			this.mouseChildren = true;
		}
		this.setSelectable(bool);
		_display.type = bool ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		#end
	}

	private var _isDownTime:Float = 0;

	private function onMiniGameInputDown(e:MouseEvent):Void {
		_isDownTime = Date.now().getTime();
	}

	#if (minigame || android || ios || html5)
	/**
	 * 触发小游戏的输入事件
	 * @param e
	 */
	private function onMiniGameInput(e:MouseEvent):Void {
		var timecha = Date.now().getTime() - _isDownTime;
		#if minigame
		if (zygame.core.KeyboardManager.keyboard != null) {
			zygame.core.KeyboardManager.focus(_display);
			zygame.core.KeyboardManager.keyboard.input(this);
		}
		this.setSelectQuadVisible(true);
		#elseif html5
		Lib.nextFrameCall(function() {
			HTML5TextInput.openInput(this);
			this.setSelectQuadVisible(true);
		});
		#elseif (kengsdkv2 || ios)
		// 安卓 IOS 原生输入支持
		#if kengsdkv2
		KengSDK.showKeyboard(this.dataProvider, _display.maxChars, function(text:String):Void {
			Lib.resumeCall(function() {
				this.dataProvider = text;
			});
		});
		#end
		#end
	}
	#end

	/**
	 * 描边字体：更改了文字大小后，可重新描边一次。
	 * @param color 描边的颜色
	 * @param blur 描边的厚度，默认建议使用1
	 */
	public function stroke(color:UInt, blur:Int = 1):Void {
		this.getDisplay().shader = new zygame.shader.TextStrokeShader(color, blur, _font.size);
	}

	/**
	 * 加粗字体
	 */
	public function bold(blur:Int = 1):Void {
		this.getDisplay().shader = new zygame.shader.TextStrokeShader(_font.color, blur, _font.size);
	}

	#if android
	// override function getBounds(target:DisplayObject):Rectangle {
	// 	var rect = super.getBounds(target);
	// 	rect.height /= _scale;
	// 	rect.width /= _scale;
	// 	__point.x = this.x;
	// 	__point.y = this.y;
	// 	__point = this.parent.localToGlobal(__point);
	// 	var rect:Rectangle = new Rectangle(__point.x,__point.y);
	// 	__point.x = this.x + this.width;
	// 	__point.y = this.y + this.height;
	// 	__point = this.parent.localToGlobal(__point);
	// 	rect.width = __point.x - rect.x;
	// 	rect.height = __point.y - rect.y;
	// 	//转换至target坐标系
	// 	__point.x = rect.x;
	// 	__point.y = rect.y;
	// 	__point = target.globalToLocal(__point);
	// 	var rx = rect.x;
	// 	var ry = rect.y;
	// 	rect.x = __point.x;
	// 	rect.y = __point.y;
	// 	__point.x = rx + rect.width;
	// 	__point.y = ry + rect.height;
	// 	__point = target.globalToLocal(__point);
	// 	rect.width = __point.x - rect.x;
	// 	rect.height = __point.y - rect.y;
	// 	return rect;
	// }
	#end

	/**
	 *  释放文本占用的缓存
	 */
	override public function destroy():Void {
		super.destroy();
		this.removeChild(_display);
		_display = null;
		setFrameEvent(false);
	}

	public function getDisplay():ZTextField {
		return _display;
	}

	private function setSelectQuadVisible(b:Bool = false) {
		zquad.visible = b;
		zquad.alpha = 1;
		setFrameEvent(b);
		if (b)
			this.updateComponents();
		else {
			#if html5
			HTML5TextInput.closeInput();
			#end
			// ZLabelAction.dipose();
		}
	}

	override function onAddToStage():Void {
		super.onAddToStage();
	}

	override function onRemoveToStage():Void {
		super.onRemoveToStage();
		setSelectQuadVisible(false);
	}

	override function onFrame():Void {
		// super.onFrame();
		if (zquad.visible) {
			quadshowtime++;
			if (quadshowtime >= quadhidetime) {
				quadshowtime = 0;
				if (curstate) {
					zquad.alpha = 0;
				} else {
					zquad.alpha = 1;
				}
				curstate = !curstate;
			}
		}
	}
}
