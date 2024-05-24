package zygame.components;

import openfl.display.DisplayObject;
import zygame.components.renders.opengl.TextFieldContextBitmapData;
import zygame.utils.ZLog;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import zygame.components.data.MixColorData;
import openfl.events.RenderEvent;
import openfl.geom.Matrix;
import haxe.Exception;
import openfl.events.Event;
import openfl.events.TextEvent;
import zygame.shader.StrokeShader;
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
 * 文本类，用于显示文本内容使用的显示对象，可设置文本的一些基础属性，通过dataProvider进行赋值文本内容，默认允许XML中使用。
 * ```xml
 * <ZLabel text="文案"/>
 * ```
 */
@:keep
class ZLabel extends DataProviderComponent {
	/**
	 * 全局文本过滤实现
	 */
	public static var onGlobalCharFilter:String->String;

	/**
	 * 缓存文字支持
	 */
	public static var textFieldContextBitmapData:TextFieldContextBitmapData;

	/**
	 * 描边着色器
	 */
	public static var __textFieldStrokeShader = new zygame.shader.StrokeShader();

	/**
	 * 渲染模式：
	 * 系统文字ZLabelRenderType.NATIVE，使用系统fillText渲染。
	 * 缓存文字ZLabelRenderType.CACHE，使用缓存文字的基础上渲染。
	 */
	public static var renderType = NATIVE;

	private var _defaultDisplay:ZTextField;

	private var _display:ZTextField;

	/**
	 * 使用Tilemap渲染缓存文字
	 */
	private var _cacheBitmapLabel:ZBitmapLabel;

	/**
	 * 缓存的版本
	 */
	private var _cacheVersion:Int = 0;

	/**
	 * 禁止使用缓存纹理，默认为`false`
	 */
	public var disableCache:Bool = false;

	/**
	 * 文本渲染（位图模式）
	 */
	#if !disable_zlabel_cache_bitmap
	private var _bitmap:Bitmap;
	#end

	private var _font:TextFormat;

	private var _isHtml:Bool = false;

	private var _width:Float = 100;

	private var _height:Float = 0;

	private var __height:Float = 0;

	private var __changed:Bool = false;

	/**
	 * 忽略字符段，在赋值时存在符合条件的字符，会自动忽略
	 */
	public var igoneChars:Array<String> = [];

	private var __point:Point = new Point();

	/**
	 * 自动文本尺寸
	 */
	public var autoTextSize:Bool = false;

	/**
	 * 正则限制符
	 */
	public var restrict(get, set):String;

	private var _restrict:String;

	private var _restrictEreg:EReg;

	private function get_restrict():String {
		return _restrict;
	}

	private function set_restrict(value:String):String {
		_restrict = value;
		if (value.indexOf("^") == 0)
			_restrictEreg = new EReg("[" + value.substr(1) + "]", "g");
		else
			_restrictEreg = new EReg("[^" + value + "]", "g");
		return _restrict;
	}

	/**
	 * 缩放系数
	 */
	public static var labelScale:Float = #if (high_label || (html5 && !un_scale_label)) 2 #else 1 #end;

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
		if (value == null)
			value = "";
		if (_defaultDisplay == null)
			updatedefaultText();
		if (_defaultDisplay.text == value)
			return value;
		if (ZLabel.onGlobalCharFilter != null)
			_defaultDisplay.text = ZLabel.onGlobalCharFilter(value);
		else
			_defaultDisplay.text = value;
		this.__changed = true;
		return value;
	}

	private function get_defaultText():String {
		return _defaultDisplay == null ? "" : _defaultDisplay.text;
	}

	private var _maxChars:Int = 0;

	/**
	 * 最大的字符长度
	 */
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
		if (_defaultDisplay.textColor == value)
			return value;
		this.__changed = true;
		_defaultDisplay.textColor = value;
		return value;
	}

	private function updatedefaultText():Void {
		if (_defaultDisplay == null) {
			_defaultDisplay = new ZTextField();
			this.addChild(_defaultDisplay);
		}
		_defaultDisplay.wordWrap = _display.wordWrap;
		_defaultDisplay.scaleX = 1 / labelScale;
		_defaultDisplay.scaleY = 1 / labelScale;
		_defaultDisplay.width = _display.width * labelScale;
		_defaultDisplay.height = _display.height * labelScale;
		_defaultDisplay.mouseEnabled = false;
		var oldColor:UInt = _font.color;
		_font.color = defaultColor;
		_defaultDisplay.setTextFormat(_font);
		_font.color = oldColor;
	}

	private function get_defaultColor():UInt {
		return _defaultDisplay == null ? 0 : _defaultDisplay.textColor;
	}

	/**
	 * 构造一个文本渲染对象
	 */
	public function new() {
		super();
		this.dataProvider = "";
		_display = new ZTextField();
		if (textFieldContextBitmapData != null) {
			_cacheBitmapLabel = new ZBitmapLabel(textFieldContextBitmapData.getAtlas());
			_cacheBitmapLabel.wordWrap = true;
			_cacheBitmapLabel.setFontSize(24);
			_cacheBitmapLabel.width = 100;
		}
		#if !disable_zlabel_cache_bitmap
		_bitmap = new Bitmap();
		_bitmap.scaleY = _bitmap.scaleX = 1 / labelScale;
		#end
		#if ios
		_font = new TextFormat("assets/" + zygame.components.base.ZConfig.fontName);
		#else
		_font = new TextFormat(zygame.components.base.ZConfig.fontName);
		#end
		_font.size = 24;
		_display.scaleX = 1 / labelScale;
		_display.scaleY = 1 / labelScale;
		_display.width = 0;
		_display.height = 0;
		_display.text = "";
		_display.wordWrap = true;
		_display.selectable = false;
		// 调试使用
		#if zlabel_debug
		_display.border = true;
		_display.borderColor = 0xff0000;
		#end
		_display.addEventListener("change", (_) -> {
			setTextFormat();
			this.__changed = true;
		});
		this.mouseChildren = false;
		zquad = new ZQuad();
		zquad.visible = false;
		this.vAlign = Align.CENTER;
		this.addEventListener(RenderEvent.RENDER_OPENGL, __onRender);
	}

	/**
	 * 过渡颜色支持
	 */
	public var mixColor(default, set):MixColorData;

	private function set_mixColor(v:MixColorData):MixColorData {
		this.mixColor = v;
		if (__blur == 0 && this.mixColor == null)
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = null;
			#else
			this.getDisplay().shader = null;
			#end
		else
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = __textFieldStrokeShader;
			#else
			this.getDisplay().shader = __textFieldStrokeShader;
			#end
		return v;
	}

	private function __onRender(e:RenderEvent):Void {
		#if !disable_zlabel_cache_bitmap
		if (this._bitmap.shader != null) {
		#else
		if (this.getDisplay().shader != null) {
		#end
			__textFieldStrokeShader.updateParam(__blur, __color);
			if (mixColor != null)
				__textFieldStrokeShader.updateMixColor(mixColor.startColor, mixColor.endColor);
			else
				__textFieldStrokeShader.updateMixColor(_font.color, _font.color);
		}
		this.__updateLabel();
	}

	private function __updateLabel():Void {
		if (__changed) {
			__changed = false;
			if (this.dataProvider != null) {
				this.drawText(this.dataProvider);
			}
			__drawTexting = true;
			this.updateComponents();
		}
	}

	override private function __updateTransforms(overrideTransform:Matrix = null):Void {
		__updateLabel();
		super.__updateTransforms(overrideTransform);
	}

	private function setTextFormat():Void {
		if (_display != null && _display.text != "") {
			_display.setTextFormat(_font);
		}
		if (_defaultDisplay != null && _defaultDisplay.text != "") {
			var oldColor = _font.color;
			_font.color = defaultColor;
			_defaultDisplay.setTextFormat(_font);
			_font.color = oldColor;
		}
		try {
			if (__setFontSelectColor.length > 0) {
				var rootColor = _font.color;
				var textLength = _display.text != null ? _display.text.length : 0;
				for (data in __setFontSelectColor) {
					if (data.endIndex > textLength || data.startIndex == -1) {
						continue;
					}
					_font.color = data.color;
					_display.setTextFormat(_font, data.startIndex, data.endIndex);
				}
				_font.color = rootColor;
			}
		} catch (e:Exception) {
			ZLog.exception(e);
		}
	}

	override private function set_vAlign(value:Align):Align {
		super.set_vAlign(value);
		if (_cacheBitmapLabel != null)
			_cacheBitmapLabel.vAlign = value;
		__changed = true;
		return value;
	}

	override private function __getBounds(rect:Rectangle, matrix:Matrix):Void {
		__updateLabel();
		super.__getBounds(rect, matrix);
	}

	override private function set_hAlign(value:Align):Align {
		super.set_hAlign(value);
		if (_cacheBitmapLabel != null)
			_cacheBitmapLabel.hAlign = value;
		__changed = true;
		return value;
	}

	override public function initComponents():Void {
		#if !disable_zlabel_cache_bitmap
		this.addChild(_bitmap);
		#else
		this.addChild(_display);
		#end
		this.addChild(zquad);
	}

	private static function _getCurrentScale():Float {
		if (zygame.core.Start.currentScale < 1) {
			return 1;
		} else {
			return zygame.core.Start.currentScale;
		}
	}

	private function updateTextXY(txt:DisplayObject, txtWidth:Float, txtHeight:Float):Void {
		txtWidth *= txt.scaleX;
		#if (openfl < '9.0.0')
		if (this.height < txtHeight * this.scaleY / labelScale #if quickgamelabelScale / _getCurrentScale() #end)
			this.height = txtHeight * this.scaleY / labelScale #if quickgamelabelScale / _getCurrentScale() #end + 32;
		#else
		if (this.__height < txtHeight * this.scaleY / labelScale #if quickgamelabelScale / _getCurrentScale() #end) {
			this._height = txtHeight * this.scaleY / labelScale #if quickgamelabelScale / _getCurrentScale() #end;
		} else if (__height != 0 && __height != _height) {
			this._height = __height;
		}
		txt.height = _height;
		#end
		if (_defaultDisplay != null && txtHeight < _defaultDisplay.textHeight) {
			txtHeight = _defaultDisplay.textHeight;
		}
		if (txtHeight == 0)
			txtHeight = (_font.size);

		switch (hAlign) {
			case Align.LEFT:
				txt.x = 0;
			case Align.RIGHT:
				txt.x = _width - txtWidth / labelScale #if quickgamelabelScale / _getCurrentScale() #end;
			case Align.CENTER:
				if (textAlign == LEFT)
					txt.x = _width / 2 - txtWidth / labelScale / 2 #if quickgamelabelScale / _getCurrentScale() #end;
				else {
					txt.x = 0;
				}
			default:
		}
		switch (vAlign) {
			case Align.TOP:
				txt.y = 0;
			case Align.BOTTOM:
				txt.y = _height - txtHeight / labelScale #if quickgamelabelScale / _getCurrentScale() #end;
			case Align.CENTER:
				txt.y = _height / 2 - txtHeight / labelScale / 2 #if quickgamelabelScale / _getCurrentScale() #end;
				#if quickgamelabelScale
				txt.y -= (_height - _height / _getCurrentScale()) / 2;
				#end
			default:
		}
	}

	/**
 * 强制刷新
 */
	public function forceDraw():Void {
		if (this.__changed) {
			this.__drawTexting = true;
			this.updateComponents();
			this.__changed = false;
		}
	}

	/**
 * 文本布局
 */
	public var textAlign(default, set):Align = LEFT;

	private function set_textAlign(v:Align):Align {
		if (this.textAlign != null) {
			this.textAlign = v;
			__changed = true;
		}
		return v;
	}

	override public function updateComponents():Void {
		_display.width = _width * labelScale;
		_display.height = _height;
		if (!disableCache && _cacheBitmapLabel != null) {
			_cacheBitmapLabel.width = _width * labelScale;
			_cacheBitmapLabel.height = _height;
		}
		switch (textAlign) {
			case LEFT:
				_font.align = LEFT;
			case RIGHT:
				_font.align = RIGHT;
			case CENTER:
				_font.align = CENTER;
			default:
		}

		setTextFormat();

		for (text in igoneChars) {
			_display.text = StringTools.replace(_display.text, text, "");
		}

		// 自动字体大小
		if (autoTextSize && !this.getDisplay().wordWrap) {
			this.getDisplay().scaleY = this.getDisplay().scaleX = Math.min(1, _width / this.getTextWidth());
			this.getDisplay().width = _width / this.getDisplay().scaleY;
		}

		if (!disableCache && _cacheBitmapLabel != null) {
			this.updateTextXY(_cacheBitmapLabel, _cacheBitmapLabel.getTextWidth(), _cacheBitmapLabel.getTextHeight());
		} else {
			this.updateTextXY(_display, _display.textWidth, _display.textHeight);
		}

		// 更新可选区域
		// this.scrollRect = new Rectangle(0, 0, this.width, this.height);

		// 光标实现
		if (zquad.visible) {
			if (disableCache || _cacheBitmapLabel == null) {
				if (_display.text.length > 0) {
					rect = _display.getCharBoundaries(_display.text.length - 1);
					if (rect != null) {
						zquad.x = (rect.x + rect.width) / labelScale + _display.x;
						zquad.y = (rect.y) / labelScale + _font.size * 0.168 / labelScale + _display.y;
					}
				} else {
					if (_display.x == 0) {
						switch (hAlign) {
							case LEFT, RIGHT:
								zquad.x = _display.x;
							case CENTER:
								zquad.x = this.width / 2;
							default:
						}
					}
					zquad.y = _font.size * 0.168 / labelScale + _display.y;
				}
			} else {
				var char:String = _cacheBitmapLabel.dataProvider;
				if (char.length > 0) {
					rect = _cacheBitmapLabel.getCharBounds(char.length - 1);
					if (rect != null) {
						zquad.x = (rect.x + rect.width) / labelScale + _cacheBitmapLabel.x;
						zquad.y = _font.size * 0.168 / labelScale + _cacheBitmapLabel.y;
					}
				} else {
					if (_cacheBitmapLabel.x == 0) {
						switch (hAlign) {
							case LEFT, RIGHT:
								zquad.x = _cacheBitmapLabel.x;
							case CENTER:
								zquad.x = this.width / 2;
							default:
						}
					}
					zquad.y = _font.size * 0.168 / labelScale + _cacheBitmapLabel.y;
				}
			}
		} else {
			zquad.x = _display.x;
			zquad.y = _font.size * 0.168 / labelScale + _display.y;
		}
		// 默认文本实现
		if (_defaultDisplay != null) {
			updatedefaultText();
			var text = "";
			if (this.disableCache || this._cacheBitmapLabel == null) {
				text = _display.text;
			} else {
				text = _cacheBitmapLabel.dataProvider;
			}
			if (text == null || text.length == 0) {
				this.updateTextXY(_defaultDisplay, _defaultDisplay.textWidth, _defaultDisplay.textHeight);
				_defaultDisplay.visible = true;
			} else {
				_defaultDisplay.visible = false;
			}
		}
		// 当存在超出时处理
		var textHeight = _display.textHeight + 5;
		if (textHeight > _height)
			_display.height = textHeight;
		if (_defaultDisplay != null) {
			_defaultDisplay.height = _defaultDisplay.textHeight + 5;
		}

		#if !disable_zlabel_cache_bitmap
		if (__drawTexting) {
			// 转换成BitmapData数据
			if (__blur > 0 || disableCache || _cacheBitmapLabel == null) {
				var drawText:DisplayObject = (disableCache || _cacheBitmapLabel == null) ? _display : @:privateAccess _cacheBitmapLabel._textmap;
				var bitmapData = new BitmapData(Std.int(drawText.width * labelScale), Std.int(drawText.height * labelScale), true, 0x0);
				bitmapData.disposeImage();
				var m = drawText.transform.matrix;
				m.scale(labelScale, labelScale);
				bitmapData.draw(drawText, m, null, null, null, true);
				_bitmap.bitmapData = bitmapData;
				_bitmap.smoothing = true;
				if (_cacheBitmapLabel != null) {
					_cacheBitmapLabel.parent?.removeChild(_cacheBitmapLabel);
				}
			} else {
				this._cacheBitmapLabel.x = 0;
				this._cacheBitmapLabel.y = 0;
				this.addChild(_cacheBitmapLabel);
			}
		}
		#end
		__drawTexting = false;
	}

	override private function set_dataProvider(value:Dynamic):Dynamic {
		if (__setFontSelectColor.length > 0)
			__setFontSelectColor = [];

		if (value == null) {
			value = "";
		}
		value = Std.isOfType(value, String) ? value : Std.string(value);

		if (_restrictEreg != null) {
			value = _restrictEreg.replace(value, "");
		}

		if (super.dataProvider == value)
			return value;

		super.dataProvider = value;

		if (_cacheBitmapLabel != null && !disableCache) {
			// 刷新内容
			__changed = true;
			if (this._cacheBitmapLabel.dataProvider == "") {
				this.drawText(this.dataProvider);
			}
		} else if (_display != null) {
			// 刷新内容
			__changed = true;
			if (this._display.text == "") {
				this.drawText(this.dataProvider);
			}
		}

		#if html5
		if (HTML5TextInput.zinput == this)
			HTML5TextInput.openInput(this);
		#end

		this.invalidate();
		return value;
	}

	private var __drawTexting:Bool = false;

	private function drawText(value:String):Void {
		__drawTexting = true;
		if (value != null) {
			if (value.length > _maxChars && _maxChars != 0) {
				value = value.substr(0, _maxChars);
			}
			if (getDisplay().wordWrap == false) {
				value = StringTools.replace(value, "\n", "");
				value = StringTools.replace(value, "\r", "");
			}
		}

		#if (!wechat)
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
		if (onGlobalCharFilter != null) {
			value = onGlobalCharFilter(value);
		}
		#end
		if (_isHtml)
			_display.htmlText = value;
		else {
			if (!disableCache && _cacheBitmapLabel != null) {
				textFieldContextBitmapData.drawText(value);
				_cacheBitmapLabel.width = _width * labelScale;
				_cacheBitmapLabel.height = _height;
				_cacheBitmapLabel.dataProvider = value;
			} else {
				if (_display.text == value)
					return;
				#if (meituan)
				// OpenFL8.9.0文本无法实时刷新区域。（7.2.5开始默认实现）
				if (_display != null) {
					var newText = new ZTextField();
					newText.width = _display.width;
					newText.height = _display.height;
					newText.scaleX = 1 / labelScale;
					newText.scaleY = 1 / labelScale;
					newText.x = _display.x;
					newText.y = _display.y;
					newText.setTextFormat(_font);
					newText.wordWrap = true;
					newText.selectable = false;
					newText.maxChars = _display.maxChars;
					newText.displayAsPassword = _display.displayAsPassword;
					newText.shader = _display.shader;
					this.removeChild(_display);
					_display = newText;
					this.addChild(_display);
				}
				#end
				_display.text = Std.string(value);
			}
		}
	}

	/**
 * 选中文本效果实现
 * @param start 选中最开始的位置
 * @param len 选中结束的位置
 */
	public function selectText(start:Int = 0, len:Int = -1):Void {
		if (_display.selectable && _display.type == TextFieldType.INPUT)
			_display.setSelection(start, len == -1 ? _display.text.length : len);
	}

	override private function set_width(value:Float):Float {
		if (_width == value)
			return value;
		_width = value #if quickgamelabelScale * _getCurrentScale() #end;
		if (_cacheBitmapLabel != null)
			_cacheBitmapLabel.width = _width;
		this.__changed = true;
		return value;
	}

	override private function get_width():Float {
		if (__changed) {
			__changed = false;
			this.drawText(this.dataProvider);
			this.updateComponents();
		}
		return Math.abs(_width #if quickgamelabelScale / _getCurrentScale() #end * this.scaleX);
	}

	override private function set_height(value:Float):Float {
		if (_height == value)
			return value;
		_height = value #if quickgamelabelScale * _getCurrentScale() #end;
		__height = value;
		if (_cacheBitmapLabel != null)
			_cacheBitmapLabel.height = _height;
		this.__changed = true;
		return value;
	}

	override private function get_height():Float {
		if (__changed) {
			__changed = false;
			this.drawText(this.dataProvider);
			this.updateComponents();
		}
		return Math.abs(_height #if quickgamelabelScale / _getCurrentScale() #end * this.scaleY);
	}

	/**
 * 获取文本高度
 * @return Float
 */
	public function getTextHeight():Float {
		if (__changed) {
			__changed = false;
			this.drawText(this.dataProvider);
			this.updateComponents();
		}
		if (!disableCache && _cacheBitmapLabel != null)
			return _cacheBitmapLabel.getTextHeight();
		return _display.textHeight / labelScale;
	}

	/**
 * 获取文本宽度
 * @return Float
 */
	public function getTextWidth():Float {
		if (__changed) {
			__changed = false;
			this.drawText(this.dataProvider);
			this.updateComponents();
		}
		if (!disableCache && _cacheBitmapLabel != null)
			return _cacheBitmapLabel.getTextWidth();
		return _display.textWidth / labelScale;
	}

	/**
 * 设置文本行距
 * @param lead 行距
 */
	public function setFontLeading(lead:Int):Void {
		_font.leading = lead;
		// setTextFormat();
		__changed = true;
	}

	/**
 * 设置文本字体大小
 * @param font 文本大小
 */
	public function setFontSize(font:Int):Void {
		if (_font.size == font)
			return;
		#if (quickgamelabelScale)
		// 快游戏兼容,OPPO新版本已修复这个问题。
		font = Std.int(font * zygame.core.Start.currentScale);
		#end
		_font.size = Std.int(font * labelScale);
		// setTextFormat();
		zquad.width = 2;
		zquad.height = font;
		_cacheBitmapLabel?.setFontSize(font);
		__changed = true;
	}

	/**
 * 设置文本的颜色
 * @param color 文本颜色
 */
	public function setFontColor(color:UInt):Void {
		if (_font.color == color)
			return;
		_font.color = color;
		zquad.color = color;
		_display.textColor = color;
		__changed = true;
		_cacheBitmapLabel?.setFontColor(color);
		if (__setFontSelectColor.length > 0)
			__setFontSelectColor = [];
	}

	private var __setFontSelectColor:Array<{
		startIndex:Int,
		endIndex:Int,
		color:UInt
	}> = [];

	/**
 * 设置颜色
 * @param start 开始位置
 * @param end 结束位置
 * @param color 颜色值
 */
	public function setFontSelectColor(startIndex:Int, len:Int, color:UInt):Void {
		// 当长度小于0，或者索引少于-1时则无效
		this.disableCache = true;
		__changed = true;
		__setFontSelectColor.push({
			startIndex: startIndex,
			endIndex: startIndex + len,
			color: color
		});
	}

	/**
 * 设置HTML标签文本，但在部分设备上渲染可能会存在问题，建议使用简易格式的渲染。
 * @param bool 是否开启html渲染
 */
	public function setHtml(bool:Bool):Void {
		_isHtml = bool;
		this.dataProvider = this.dataProvider;
	}

	/**
 * 设置文本是否可选择
 * @param bool 是否可选
 */
	public function setSelectable(bool:Bool):Void {
		_display.selectable = bool;
	}

	/**
 * 设置是否可换行
 * @param bool 是否可换行
 */
	public function setWordWrap(bool:Bool):Void {
		_display.wordWrap = bool;
		if (_cacheBitmapLabel != null)
			_cacheBitmapLabel.wordWrap = bool;
	}

	/**
 * 设置是否可以输入
 * @param bool 是否可输入
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

	#if (minigame || cpp || html5)
	public function openInput():Void {
		onMiniGameInput(null);
	}

	/**
 * 触发小游戏的输入事件
 * @param e
 */
	private function onMiniGameInput(e:MouseEvent):Void {
		var timecha = Date.now().getTime() - _isDownTime;
		#if (sxk_game_sdk && (!cpp || android))
		// SXKSDK键盘支持
		if (v4.utils.KeyboardInputTools.keyboard != null) {
			v4.utils.KeyboardInputTools.keyboard.input(this);
		} else {
			#if html5
			Lib.nextFrameCall(function() {
				HTML5TextInput.openInput(this);
				this.setSelectQuadVisible(true);
			});
			#end
		}
		#elseif minigame
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
		#elseif (kengsdkv2 && cpp)
		// 安卓 IOS 原生输入支持
		#if kengsdkv2
		KengSDK.showKeyboard(this.dataProvider, _display.maxChars, function(text:String):Void {
			#if android
			Lib.resumeCall(function() {
				this.dataProvider = text;
			});
			#else
			this.dataProvider = text;
			#end
		});
		#end
		#end
	}
	#end

	private var __color:UInt = 0;
	private var __blur:Float = 0;

	/**
 * 描边字体：更改了文字大小后，可重新描边一次。
 * @param color 描边的颜色
 * @param blur 描边的厚度，默认建议使用1
 */
	public function stroke(color:UInt, blur:Float = 1):Void {
		__blur = blur;
		__color = color;
		if (blur == 0 && this.mixColor == null) {
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = null;
			#else
			this.getDisplay().shader = null;
			#end
		} else {
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = __textFieldStrokeShader;
			#else
			this.getDisplay().shader = __textFieldStrokeShader;
			#end
		}
	}

	/**
 * 加粗字体
 * @param blur 加粗大小
 */
	public function bold(blur:Float = 1):Void {
		__blur = blur;
		__color = _font.color;
		#if !disable_zlabel_cache_bitmap
		this._bitmap.shader = __textFieldStrokeShader;
		#else
		this.getDisplay().shader = __textFieldStrokeShader;
		#end
	}

	/**
 *  释放文本占用的缓存
 */
	override public function destroy():Void {
		super.destroy();
		this.removeChild(_display);
		// _display = null;
		setFrameEvent(false);
	}

	/**
 * 获取文本基础渲染对象
 * @return ZTextField
 */
	public function getDisplay():ZTextField {
		return _display;
	}

	private function setSelectQuadVisible(b:Bool = false) {
		if (zquad.visible == b)
			return;
		zquad.visible = b;
		zquad.alpha = 1;
		setFrameEvent(b);
		if (b) {
			this.__changed = true;
			this.addChild(zquad);
		} else {
			#if html5
			HTML5TextInput.closeInput(this);
			#end
		}
		this.updateComponents();
	}

	override function onAddToStage():Void {
		super.onAddToStage();
		if (_cacheBitmapLabel != null
			&& !disableCache
			&& textFieldContextBitmapData != null
			&& _cacheVersion != textFieldContextBitmapData.version) {
			var old = this.dataProvider;
			this.dataProvider = "";
			this.dataProvider = old;
		}
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

	/**
 * 获取字符的坐标宽度
 * @param charIndex 位置字符
 * @return Rectangle
 */
	public function getCharBounds(charIndex:Int):Rectangle {
		var rect = _display.getCharBoundaries(charIndex);
		rect.x += _display.x;
		rect.y += _display.y;
		return rect;
	}
}
