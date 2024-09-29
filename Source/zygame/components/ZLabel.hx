package zygame.components;

import zygame.utils.EmojTools;
import openfl.display.Tilemap;
import zygame.display.batch.QuadsBatchs;
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

	/**
	 * 是否使用全局文本过滤实现
	 */
	public var globalCharFilterEnable = true;

	private var _defaultDisplay:ZTextField;

	private var _display:ZTextField;

	/**
	 * 使用Tilemap渲染缓存文字
	 */
	private var _cacheBitmapLabel:ZBitmapLabel;

	/**
	 * 使用Quads渲染缓存文字
	 */
	private var _cacheBatch:QuadsBatchs;

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
			_cacheBatch = new QuadsBatchs();
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
		if (__blur == 0 && this.mixColor == null) {
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = null;
			#else
			this.getDisplay().shader = null;
			#end
		} else {
			this.disableCache = true;
			#if !disable_zlabel_cache_bitmap
			this._bitmap.shader = __textFieldStrokeShader;
			#else
			this.getDisplay().shader = __textFieldStrokeShader;
			#end
		}
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
		// 基础宽高应该使用实际宽高处理
		txtWidth *= txt.scaleX;
		txtHeight *= txt.scaleY;
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
			if (_cacheBitmapLabel != null) {
				var scaleMath = Math.min(1, _width / this._cacheBitmapLabel.getTextWidth());
				_cacheBitmapLabel.setFontSize(Math.round(_font.size * scaleMath));
			}
		}

		if (!disableCache && _cacheBitmapLabel != null) {
			this.updateTextXY(_cacheBitmapLabel, _cacheBitmapLabel.getTextWidth(), _cacheBitmapLabel.getTextHeight());
			_cacheBitmapLabel.x = _cacheBitmapLabel.y = 0;
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
					var chars = EmojTools.split(char, "");
					rect = _cacheBitmapLabel.getCharBounds(chars.length - 1);
					if (rect != null) {
						zquad.x = (rect.x + rect.width) / labelScale + _cacheBitmapLabel.x;
						zquad.y = this._cacheBitmapLabel.height / 2 - zquad.height / 2;
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
					zquad.y = this._cacheBitmapLabel.height / 2 - zquad.height / 2;
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
			if (#if force_cache_bitmap true #else __blur > 0 || disableCache || _cacheBitmapLabel == null #end) {
				if (_bitmap.bitmapData != null) {
					_bitmap.bitmapData.dispose();
				}
				var drawText:DisplayObject = (disableCache || _cacheBitmapLabel == null) ? _display : @:privateAccess _cacheBitmapLabel._textmap;
				var bitmapData = new BitmapData(Std.int(drawText.width * labelScale), Std.int(drawText.height * labelScale / drawText.scaleY),
					true, 0x0);
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
				#if !zlabel_cache_to_sprite
				// Tilemap渲染，但在IOS等性能手机上，会增加消耗
				this._cacheBitmapLabel.x = 0;
				this._cacheBitmapLabel.y = 0;
				this.addChild(_cacheBitmapLabel);
				#else
				// 使用Sprite渲染，字体位置、颜色都不对劲
				this.addChild(_cacheBatch);
				_cacheBatch.drawBitmapLabel(_cacheBitmapLabel);
				_cacheBatch.scaleX = @:privateAccess _cacheBitmapLabel._node._node.scaleX;
				_cacheBatch.scaleY = @:privateAccess _cacheBitmapLabel._node._node.scaleY;
				_cacheBatch.x = @:privateAccess _cacheBitmapLabel._node._node.x * _cacheBatch.scaleX;
				_cacheBatch.y = @:privateAccess _cacheBitmapLabel._node._node.y * _cacheBatch.scaleY;
				// _cacheBatch.shader = __textFieldStrokeShader;
				#end
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

		#if un_emoj
		var req = ~/[#*0-9]\uFE0F?\u20E3|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26AA\u26B0\u26B1\u26BD\u26BE\u26C4\u26C8\u26CF\u26D1\u26E9\u26F0-\u26F5\u26F7\u26F8\u26FA\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2757\u2763\u27A1\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B55\u3030\u303D\u3297\u3299]\uFE0F?|[\u261D\u270C\u270D](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?|[\u270A\u270B](?:\uD83C[\uDFFB-\uDFFF])?|[\u23E9-\u23EC\u23F0\u23F3\u25FD\u2693\u26A1\u26AB\u26C5\u26CE\u26D4\u26EA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2795-\u2797\u27B0\u27BF\u2B50]|\u26D3\uFE0F?(?:\u200D\uD83D\uDCA5)?|\u26F9(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|\u2764\uFE0F?(?:\u200D(?:\uD83D\uDD25|\uD83E\uDE79))?|\uD83C(?:[\uDC04\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]\uFE0F?|[\uDF85\uDFC2\uDFC7](?:\uD83C[\uDFFB-\uDFFF])?|[\uDFC4\uDFCA](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDFCB\uDFCC](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF43\uDF45-\uDF4A\uDF4C-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uDDE6\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF]|\uDDE7\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF]|\uDDE8\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF]|\uDDE9\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF]|\uDDEA\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA]|\uDDEB\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7]|\uDDEC\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE]|\uDDED\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA]|\uDDEE\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9]|\uDDEF\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5]|\uDDF0\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF]|\uDDF1\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE]|\uDDF2\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF]|\uDDF3\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF]|\uDDF4\uD83C\uDDF2|\uDDF5\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE]|\uDDF6\uD83C\uDDE6|\uDDF7\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC]|\uDDF8\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF]|\uDDF9\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF]|\uDDFA\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF]|\uDDFB\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA]|\uDDFC\uD83C[\uDDEB\uDDF8]|\uDDFD\uD83C\uDDF0|\uDDFE\uD83C[\uDDEA\uDDF9]|\uDDFF\uD83C[\uDDE6\uDDF2\uDDFC]|\uDF44(?:\u200D\uD83D\uDFEB)?|\uDF4B(?:\u200D\uD83D\uDFE9)?|\uDFC3(?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D(?:[\u2640\u2642]\uFE0F?(?:\u200D\u27A1\uFE0F?)?|\u27A1\uFE0F?))?|\uDFF3\uFE0F?(?:\u200D(?:\u26A7\uFE0F?|\uD83C\uDF08))?|\uDFF4(?:\u200D\u2620\uFE0F?|\uDB40\uDC67\uDB40\uDC62\uDB40(?:\uDC65\uDB40\uDC6E\uDB40\uDC67|\uDC73\uDB40\uDC63\uDB40\uDC74|\uDC77\uDB40\uDC6C\uDB40\uDC73)\uDB40\uDC7F)?)|\uD83D(?:[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3]\uFE0F?|[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDC8F\uDC91\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC](?:\uD83C[\uDFFB-\uDFFF])?|[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4\uDEB5](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDD74\uDD90](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?|[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC25\uDC27-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDC8E\uDC90\uDC92-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE2D\uDE2F-\uDE34\uDE37-\uDE41\uDE43\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEDC-\uDEDF\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB\uDFF0]|\uDC08(?:\u200D\u2B1B)?|\uDC15(?:\u200D\uD83E\uDDBA)?|\uDC26(?:\u200D(?:\u2B1B|\uD83D\uDD25))?|\uDC3B(?:\u200D\u2744\uFE0F?)?|\uDC41\uFE0F?(?:\u200D\uD83D\uDDE8\uFE0F?)?|\uDC68(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:[\uDC68\uDC69]\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]))|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFC-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFD-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFD\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFE])))?))?|\uDC69(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?[\uDC68\uDC69]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?|\uDC69\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?))|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]))|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFC-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFD-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFD\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFE])))?))?|\uDC6F(?:\u200D[\u2640\u2642]\uFE0F?)?|\uDD75(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|\uDE2E(?:\u200D\uD83D\uDCA8)?|\uDE35(?:\u200D\uD83D\uDCAB)?|\uDE36(?:\u200D\uD83C\uDF2B\uFE0F?)?|\uDE42(?:\u200D[\u2194\u2195]\uFE0F?)?|\uDEB6(?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D(?:[\u2640\u2642]\uFE0F?(?:\u200D\u27A1\uFE0F?)?|\u27A1\uFE0F?))?)|\uD83E(?:[\uDD0C\uDD0F\uDD18-\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2\uDDD3\uDDD5\uDEC3-\uDEC5\uDEF0\uDEF2-\uDEF8](?:\uD83C[\uDFFB-\uDFFF])?|[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD\uDDCF\uDDD4\uDDD6-\uDDDD](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDDDE\uDDDF](?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDD0D\uDD0E\uDD10-\uDD17\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCC\uDDD0\uDDE0-\uDDFF\uDE70-\uDE7C\uDE80-\uDE88\uDE90-\uDEBD\uDEBF-\uDEC2\uDECE-\uDEDB\uDEE0-\uDEE8]|\uDD3C(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF])?|\uDDCE(?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D(?:[\u2640\u2642]\uFE0F?(?:\u200D\u27A1\uFE0F?)?|\u27A1\uFE0F?))?|\uDDD1(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1|\uDDD1\u200D\uD83E\uDDD2(?:\u200D\uD83E\uDDD2)?|\uDDD2(?:\u200D\uD83E\uDDD2)?))|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFC-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFD-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFD\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFE]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF\uDDBC\uDDBD](?:\u200D\u27A1\uFE0F?)?|[\uDDB0-\uDDB3]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?))?|\uDEF1(?:\uD83C(?:\uDFFB(?:\u200D\uD83E\uDEF2\uD83C[\uDFFC-\uDFFF])?|\uDFFC(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB\uDFFD-\uDFFF])?|\uDFFD(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])?|\uDFFE(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB-\uDFFD\uDFFF])?|\uDFFF(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB-\uDFFE])?))?)/g;
		// 剔除所有emoj表情
		// var req = ~/[\ud04e-\ue50e]+/;
		value = req.replace(value, " ");
		#end

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

		#if (!wechat || IOS_HIGH_PREFORMANCE_V2)
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
		if (globalCharFilterEnable && onGlobalCharFilter != null) {
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
		// TODO 耗性能
		// if (__changed) {
		// 	__changed = false;
		// 	this.drawText(this.dataProvider);
		// 	this.updateComponents();
		// }
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
		// TODO 耗性能
		// if (__changed) {
		// 	__changed = false;
		// 	this.drawText(this.dataProvider);
		// 	this.updateComponents();
		// }
		if (_height < this._font.size) {
			_height = this._font.size * 1.168;
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
	 * 设置高亮的文本
	 * @param texts 
	 * @param color 
	 */
	public function setHighLightTexts(texts:Array<String>, color:UInt):Void {
		var text:String = _dataProvider;
		for (s in texts) {
			var at = text.indexOf(s);
			if (at != -1) {
				this.setFontSelectColor(at, s.length, color);
			}
		}
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
		#if (sxk_game_sdk && (ios || android || minigame))
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
			this._cacheVersion = textFieldContextBitmapData.version;
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
