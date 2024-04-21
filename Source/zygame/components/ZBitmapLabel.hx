package zygame.components;

import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import zygame.utils.load.FntLoader.FntData;
import zygame.components.base.DataProviderComponent;
import openfl.display.Tilemap;
import zygame.utils.Align;
import zygame.display.batch.BLabel;
import zygame.utils.load.Atlas;

/**
 * 本地化纹理字，可以在不支持本地化纹理时，可使用`native_label`使用ZLabel进行渲染
 */
#if native_label
class NativeZBitmapLabel extends ZLabel {
	public function new(fnt:Atlas) {
		super();
	}

	public function setFontName(font:String):Void {}

	public var wordWrap:Bool = false;

	override public function setFontSelectColor(startIndex:Int, len:Int, color:Int):Void {}
}
#else
typedef NativeZBitmapLabel = ZBitmapLabel;
#end

/**
 * 使用位图数据进行渲染文本，该文本的功能实现了简单的位图文本渲染功能。该文本不支持换行，HTMLText文本等。如果有需要使用大量相同的位图文字的时候，可以考虑使用BLabel进行批渲染得到高性能。
 */
@:keep
class ZBitmapLabel extends DataProviderComponent {
	private var _fnt:Atlas;
	private var _textmap:Tilemap;
	private var _node:BLabel;
	private var _text:String = "";
	private var __height:Float = 0;

	/**
	 * 构造一个位图文本渲染器
	 * @param fnt 位图纹理数据
	 */
	public function new(fnt:Atlas) {
		_fnt = fnt;
		super();
		_textmap = new Tilemap(0, 0, _fnt != null ? _fnt.getTileset() : null);
		// _textmap.tileAlphaEnabled = false;
		// _textmap.tileBlendModeEnabled = false;
		// _textmap.tileColorTransformEnabled = false;
		_node = new BLabel(fnt);
		_textmap.addTile(_node);
		this.vAlign = Align.CENTER;
		this.hAlign = Align.LEFT;
	}

	override public function initComponents():Void {
		this.addChild(_textmap);
	}

	/**
	 * 清理区域选择的颜色
	 */
	public function clearFontSelectColor():Void {
		_node.clearFontSelectColor();
	}

	/**
	 * 设置区域颜色，请注意设置了之后将一直生效。当文本未变更的情况下，需要clearFontSelectColor清理后才会清空
	 * @param startIndex 开始更改的位置
	 * @param len 更改长度 
	 * @param color 更改颜色
	 */
	public function setFontSelectColor(startIndex:Int, len:Int, color:Int):Void {
		_node.setFontSelectColor(startIndex, len, color);
	}

	/**
	 * 是否自动换行
	 */
	public var wordWrap(get, set):Bool;

	private function set_wordWrap(value:Bool):Bool {
		_node.wordWrap = value;
		return value;
	}

	private function get_wordWrap():Bool {
		return _node.wordWrap;
	}

	override private function get_vAlign():Align {
		return _node.vAlign;
	}

	override private function get_hAlign():Align {
		return _node.hAlign;
	}

	override private function set_vAlign(value:Align):Align {
		_node.vAlign = value;
		updateComponents();
		return value;
	}

	override private function set_hAlign(value:Align):Align {
		_node.hAlign = value;
		updateComponents();
		return value;
	}

	/**
	 * 设置字体，在XML配置中，你可以使用fontName进行设置
	 * @param str 字体名称
	 */
	public function setFontName(str:String):Void {
		_node.fontName = str;
	}

	/**
	 * 设置文本颜色，在XML配置中，你可以使用color进行设置
	 * @param color 字体颜色
	 */
	public function setFontColor(color:Null<Int>):Void {
		if (color == null) {
			_node.shader = null;
		} else {
			_node.setFontColor(color);
		}
	}

	/**
	 * 设置文字大小，在XML配置中，你可以使用size进行设置
	 * @param font 字体大小
	 */
	public function setFontSize(size:Int):Void {
		_node.setFontSize(size);
		updateComponents();
	}

	override public function updateComponents():Void {
		// 批量渲染字
		_node.updateText(_text);
		var txtHeight:Float = getTextHeight();
		// 新版本是否不再需要移动位移？
		// #if (quickgame)
		// _display.y -= 5;
		// #end
		if (this.__height < txtHeight) {
			_textmap.height = txtHeight;
			_node.height = _textmap.height;
		} else if (__height != 0 && __height != _textmap.height) {
			_textmap.height = __height;
			_node.height = __height;
		}
	}

	/**
	 * 获取文本的高度
	 * @return Float
	 */
	public function getTextHeight():Float {
		return _node.getTextHeight();
	}

	/**
	 * 获取文本的宽度
	 * @return Float
	 */
	public function getTextWidth():Float {
		return _node.getTextWidth();
	}

	#if flash
	@:setter(width)
	public function set_width(value:Float) {
		_textmap.width = value;
		_node.width = value;
		updateComponents();
		return value;
	}

	@:getter(width)
	public function get_width() {
		return _textmap.width;
	}

	@:setter(height)
	public function set_height(value:Float) {
		_textmap.height = value;
		_node.height = value;
		__height = value;
		updateComponents();
		return value;
	}

	@:getter(height)
	public function get_height() {
		return _textmap.height;
	}
	#else
	override private function set_width(value:Float):Float {
		_textmap.width = value;
		_node.width = value;
		updateComponents();
		return value;
	}

	override private function get_width():Float {
		return _textmap.width;
	}

	override private function set_height(value:Float):Float {
		_textmap.height = value;
		_node.height = value;
		__height = value;
		updateComponents();
		return value;
	}

	override private function get_height():Float {
		return _textmap.height;
	}
	#end

	override private function set_dataProvider(value:Dynamic):Dynamic {
		if (Std.isOfType(value, Int))
			value = Std.string(value);
		super.dataProvider = value;
		_text = value;
		updateComponents();
		return value;
	}

	/**
	 * 获取字符的坐标宽度
	 * @param charIndex 从0开始计算的第几个字符
	 * @return Rectangle
	 */
	public function getCharBounds(charIndex:Int):Rectangle {
		var rect = _node.getCharBounds(charIndex);
		rect.x += _node.x;
		rect.y += _node.y;
		return rect;
	}
}
