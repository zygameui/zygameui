package zygame.display.batch;

import zygame.utils.ColorUtils;
import openfl.geom.ColorTransform;
import openfl.display.DisplayObjectShader;
import openfl.display.Shader;
import zygame.components.base.IFontAtlas;
import zygame.components.ZLabel;
import zygame.components.ZBuilder;
import openfl.geom.Rectangle;
import zygame.utils.load.SpineTextureAtalsLoader.SpineTextureAtals;
import zygame.display.batch.BSprite;
import zygame.utils.load.FntLoader;
import openfl.display.Tile;
import zygame.utils.load.Atlas;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.BaseFrame;
import zygame.utils.load.Frame;
import zygame.utils.Align;
import zygame.shader.TextColorShader;
import zygame.shader.ColorShader;

/**
 * 批量渲染字位图，能够支持精灵表/位图Fnt/Spine位图渲染
 * 如果使用的是位图Fnt渲染，则传入Fnt格式渲染进行正常渲染即可。
 * 如果使用的是精灵图渲染，精灵表的位图名需要对应每个字符。
 * 需要使用vAlign/hAlign时，需要相应地设置height,width值。
 */
class BLabel extends BSprite {
	private static var __defaultColorShader:ColorShader;

	private var _texts:Array<String> = [];

	private var _maxWidth:Float = 0;

	private var _maxHeight:Float = 0;

	private var _lineHeight:Float = 0;

	private var _size:Int = 0;

	private var _text:String = "";

	public var fntData:Atlas;

	/**
	 * 间距值
	 */
	public var gap:Int = 2;

	/**
	 * 行距
	 */
	public var lineGap:Int = -10;

	private var _width:Float = 0;
	private var _height:Float = 0;

	/**
	 * 是否使用全局文本过滤实现
	 */
	public var globalCharFilterEnable = true;

	/**
	 * 是否自动换行
	 */
	public var wordWrap:Bool = false;

	private var _node:BSprite;

	private var _font:String = "";

	/**
	 * 设置字体，只在精灵表单中生效
	 */
	public var fontName(get, set):String;

	private function get_fontName():String {
		return _font;
	}

	private function set_fontName(value:String):String {
		_font = value;
		this.drawText(__drawText);
		return _font;
	}

	public var dataProvider(get, set):Dynamic;

	private function get_dataProvider():Dynamic {
		return this.getText();
	}

	private function set_dataProvider(dataProvider:Dynamic):Dynamic {
		this.updateText(dataProvider);
		return dataProvider;
	}

	/**
	 * 设置字体结尾
	 */
	public var fontEnd:String = "";

	private var __sizeChange:Bool = false;

	public function new(fnt:Dynamic) {
		super();
		if (fnt is String)
			fntData = ZBuilder.getBaseTextureAtlas(fnt);
		else
			fntData = fnt;
		_node = new BSprite();
		this.addChild(_node);
	}

	override private function get_width():Float {
		if (_width == 0)
			return this.getTextWidth();
		return Math.abs(_width * scaleX);
	}

	override private function set_width(w:Float):Float {
		_width = w;
		__sizeChange = true;
		updateLayout();
		return _width;
	}

	override private function get_height():Float {
		if (_height == 0)
			return this.getTextHeight();
		return Math.abs(_height * scaleY);
	}

	override private function set_height(h:Float):Float {
		_height = h;
		__sizeChange = true;
		updateLayout();
		return _height;
	}

	private var _vAlign:Align = Align.TOP;

	/**
	 * 设置文本的竖向对齐情况
	 */
	public var vAlign(get, set):Align;

	private function set_vAlign(value:Align):Align {
		_vAlign = value;
		updateLayout();
		return _vAlign;
	}

	private function get_vAlign():Align {
		return _vAlign;
	}

	private var _hAlign:Align = Align.LEFT;

	/**
	 * 设置文本的横向对齐情况
	 */
	public var hAlign(get, set):Align;

	private function set_hAlign(value:Align):Align {
		_hAlign = value;
		updateLayout();
		return _hAlign;
	}

	private function get_hAlign():Align {
		return _hAlign;
	}

	/**
	 * 用于更新vhalign对齐关系
	 */
	private function updateLayout():Void {
		if (width > 0)
			switch (hAlign) {
				case Align.LEFT:
					_node.x = 0;
				case Align.RIGHT:
					_node.x = this._width - getTextWidth();
				case Align.CENTER:
					_node.x = this._width / 2 - getTextWidth() / 2;
				default:
			}
		if (height > 0)
			switch (vAlign) {
				case Align.TOP:
					_node.y = 0;
				case Align.BOTTOM:
					_node.y = this._height - getTextHeight();
				case Align.CENTER:
					_node.y = this._height / 2 - getTextHeight() / 2;
				default:
			}
		// #if vivo
		// _node.y += 3;
		// #end
	}

	/**
	 * 更新文本
	 * @param value 
	 */
	public function updateText(value:Dynamic, sizeChange:Bool = false):Void {
		if (__sizeChange) {
			sizeChange = true;
			__sizeChange = false;
		}
		if (!Std.isOfType(value, String))
			value = Std.string(value);
		if (_text != value || sizeChange) {
			_text = value;
			if (globalCharFilterEnable && ZLabel.onGlobalCharFilter != null)
				value = ZLabel.onGlobalCharFilter(value);
			__drawText = value;
			drawText(__drawText);
		}
	}

	private var __drawText:String = "";

	/**
	 * 内部文本渲染调用
	 * @param text 
	 */
	private function drawText(text:String):Void {
		this._node.removeTiles();
		if (text == null || fntData == null)
			return;
		_texts = text.split("");
		// 处理emoj表情
		#if !cpp
		var req = ~/[\ud04e-\ue50e]+/;
		#end
		if (Std.isOfType(fntData, IFontAtlas)) {
			_maxWidth = 0;
			var curFntData:IFontAtlas = cast fntData;
			_lineHeight = curFntData.getFontHeight();
			_maxHeight = curFntData.maxHeight;
			var offestX:Float = 0;
			var offestY:Float = 0;
			var scaleFloat:Float = this._size > 0 ? (this._size / _lineHeight) : 1;
			var lastWidth:Float = 0;
			var emoj:String = "";
			var isEmoj = false;
			for (char in _texts) {
				var id:Int = char.charCodeAt(0);
				var frame:FntFrame = null;
				#if !cpp
				if (req.match(char)) {
					emoj += char;
					if (emoj.length == 2) {
						isEmoj = true;
						frame = curFntData.getTileFrameByEmoj(emoj);
						emoj = "";
					}
				} else {
				#end
					frame = curFntData.getTileFrame(id);
				#if !cpp
				}
				#end
				if (frame != null) {
					// trace("this._width", (offestX + frame.width) * scaleFloat, "scaleFloat=", scaleFloat, "_lineHeight=", _lineHeight, _size, this._width);
					if (wordWrap && (offestX + frame.xadvance) * scaleFloat > this._width) {
						offestX = 0;
						offestY += curFntData.maxHeight;
						_maxHeight += curFntData.maxHeight;
					}
					var tile:FntTile = new FntTile(frame);
					if (isEmoj) {
						isEmoj = false;
					} else {
						if (__setColor) {
							var c = ColorUtils.toShaderColor(__color);
							tile.colorTransform = new ColorTransform(c.r, c.g, c.b, 1);
						}
					}
					_node.addChild(tile);
					tile.x = offestX + frame.xoffset;
					tile.y = offestY + frame.yoffset;
					lastWidth = frame.width;
					// if (_lineHeight < frame.height)
					// _lineHeight = frame.height;
					if (offestX + frame.width > _maxWidth) {
						_maxWidth = offestX + frame.width;
					}
					offestX += Std.int(frame.xadvance);
				} else if (char == " ") {
					offestX += (_size != 0 ? _size : lastWidth) * 0.8;
					if (offestX > _maxWidth) {
						_maxWidth = offestX;
					}
				} else if (char == "\n") {
					offestX = 0;
					offestY += curFntData.maxHeight;
					_maxHeight += curFntData.maxHeight;
				}
			}
		} else if (Std.isOfType(fntData, TextureAtlas) || Std.isOfType(fntData, SpineTextureAtals)) {
			// 精灵表中的位图字渲染，7月2号开始支持Spine的位图渲染
			var curSpriteDataGetBitmapDataFrame:String->Frame = null;
			if (Std.isOfType(fntData, TextureAtlas))
				curSpriteDataGetBitmapDataFrame = cast(fntData, TextureAtlas).getBitmapDataFrame;
			else
				curSpriteDataGetBitmapDataFrame = cast(fntData, SpineTextureAtals).getBitmapDataFrame;
			var offestX:Float = 0;
			var offestY:Float = 0;
			_maxHeight = 0;
			_maxWidth = 0;
			_lineHeight = 0;
			for (char in _texts) {
				var frame:Frame = curSpriteDataGetBitmapDataFrame(fontName + char + fontEnd);
				if (frame != null)
					if (_lineHeight < frame.height)
						_lineHeight = frame.height;
			}
			var scaleFloat:Float = this._size > 0 ? (this._size / _lineHeight) : 1;
			var emoj:String = "";
			var isEmoj = false;
			var lastWidth:Float = 0;
			for (char in _texts) {
				var frame:Frame = null;
				#if !cpp
				if (req.match(char)) {
					emoj += char;
					if (emoj.length == 2) {
						isEmoj = true;
						frame = curSpriteDataGetBitmapDataFrame(fontName + emoj + fontEnd);
						emoj = "";
					}
				} else {
				#end
					frame = curSpriteDataGetBitmapDataFrame(fontName + char + fontEnd);
				#if !cpp
				}
				#end
				if (frame != null) {
					if (wordWrap && (offestX + frame.width) * scaleFloat > this._width) {
						offestX = 0;
						offestY += frame.height + lineGap;
					}
					var tile:FntTile = new FntTile(frame);
					if (isEmoj) {
						tile.shader = new TextColorShader(0, 0xffffff);
						isEmoj = false;
					}
					_node.addChild(tile);
					tile.x = offestX;
					tile.y = offestY;
					tile.rotation = frame.rotate ? 90 : 0;
					if (frame.rotate) {
						tile.x += tile.width;
					}
					if (frame.frameY > 0) {
						tile.y += frame.frameY;
					}
					offestX += Std.int(frame.width + gap);
					lastWidth = frame.width;
					if (_maxHeight < offestY + frame.height)
						_maxHeight = offestY + frame.height;
					if (_maxWidth < offestX)
						_maxWidth = offestX;
				} else if (char == " ") {
					offestX += (_size != 0 ? _size : lastWidth) * 0.8;
				} else if (char == "\n") {
					offestX = 0;
					offestY += _lineHeight;
					_maxHeight += _lineHeight;
				}
			}
		}

		// 字体大小调整
		if (this._size > 0 && _lineHeight != 0) {
			_node.scaleX = this._size / _lineHeight;
			_node.scaleY = _node.scaleX;
		}

		updateLayout();
	}

	/**
			 * 清理区域选择的颜色
			 */
	public function clearFontSelectColor():Void {
		for (i in 0..._node.numTiles) {
			var tile:Tile = cast _node.getTileAt(i);
			tile.shader = null;
		}
	}

	/**
			 * 设置区域颜色，请注意设置了之后将一直生效。当文本未变更的情况下，需要clearFontSelectColor清理后才会清空
			 * @param startIndex 开始更改的位置
			 * @param len 更改长度 
			 * @param color 更改颜色
			 */
	public function setFontSelectColor(startIndex:Int, len:Int, color:Int):Void {
		var endIndex:Int = startIndex + len;
		if (endIndex >= _node.numTiles)
			endIndex = _node.numTiles;
		for (i in startIndex...endIndex) {
			var tile:Tile = cast _node.getTileAt(i);
			if (Std.isOfType(fntData, TextTextureAtlas)) {
				__isTextureAtlas = true;
				tile.shader = new TextColorShader(color, cast(fntData, TextTextureAtlas).textColor);
			} else {
				__isTextureAtlas = false;
				tile.shader = new ColorShader(color);
			}
		}
	}

	private var __isTextureAtlas:Bool = false;

	private var __color:UInt = 0;

	private var __setColor = false;

	/**
			 * 设置文本颜色
			 * @param color 
			 */
	public function setFontColor(color:Int):Void {
		__color = color;
		__setColor = true;
		if (!Std.isOfType(fntData, IFontAtlas)) {
			if (Std.isOfType(fntData, TextTextureAtlas)) {
				__isTextureAtlas = true;
				this.shader = new TextColorShader(color, cast(fntData, TextTextureAtlas).textColor);
			} else {
				__isTextureAtlas = false;
				this.shader = getColorShader(color);
			}
		}
	}

	/**
			 * 重用ColorShader着色器
			 * @param color 
			 * @return ColorShader
			 */
	private function getColorShader(color:UInt):ColorShader {
		if (__defaultColorShader == null) {
			__defaultColorShader = new ColorShader(color);
		} else {
			__defaultColorShader.updateColor(color);
		}
		return __defaultColorShader;
	}

	/**
			 * 设置文本大小
			 * @param size 
			 */
	public function setFontSize(size:Int):Void {
		this._size = size;
		drawText(__drawText);
	}

	/**
			 * 获取文本
			 * @return String
			 */
	public function getText():String {
		return _text;
	}

	/**
			 * 获取文本宽度
			 * @return Float
			 */
	public function getTextWidth():Float {
		#if neko
		if (_maxWidth == null)
			return 0;
		#end
		return _maxWidth * _node.scaleX;
	}

	/**
			 * 获取文本高度
			 * @return Float
			 */
	public function getTextHeight():Float {
		#if neko
		if (_maxHeight == null)
			return 0;
		#end
		return _maxHeight * _node.scaleY;
	}

	override function get_shader():Shader {
		return __setColor ? getColorShader(__color) : super.shader;
	}

	/**
			 * 获取字符的坐标宽度
			 * @param charIndex 
			 * @return Rectangle
			 */
	public function getCharBounds(charIndex:Int):Rectangle {
		var char = _node.getTileAt(charIndex);
		if (char == null)
			return null;
		var rect = char.getBounds(char.parent);
		if (rect != null) {
			rect.x += _node.x;
			rect.y += _node.y;
			rect.y *= _node.scaleX;
			rect.x *= _node.scaleX;
			rect.width *= _node.scaleX;
			rect.height *= _node.scaleX;
		}
		return rect;
	}
}

/**
 * 单个字
 */
class FntTile extends Tile {
	/**
	 * 当前字符帧
	 */
	public var curFrame:BaseFrame;

	public function new(frame:BaseFrame):Void {
		super();
		setFrame(frame);
	}

	/**
	 * 设置
	 * @param frame 
	 */
	public function setFrame(frame:BaseFrame):Void {
		curFrame = frame;
		if (frame == null) {
			this.id = -1;
			this.tileset = null;
		} else {
			this.id = frame.id;
			this.tileset = frame.parent.getTileset();
		}
	}

	/**
	 * 根据Frame获取对应的ID
	 * @return Int
	 */
	override function get_id():Int {
		if (curFrame == null) {
			this.id = -1;
			return -1;
		} else {
			this.id = curFrame.id;
			return curFrame.id;
		}
	}
}
