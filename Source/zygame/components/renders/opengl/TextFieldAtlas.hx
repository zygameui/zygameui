package zygame.components.renders.opengl;

import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import zygame.utils.load.FntLoader.FntFrame;
import zygame.components.base.IFontAtlas;
import zygame.utils.load.Atlas;

/**
 * 文本纹理
 */
class TextFieldAtlas extends Atlas implements IFontAtlas {
	private var __tileset:Tileset;

	private var __chars:Map<Int, FntFrame> = [];

	public var maxHeight:Float = 0;

	public var fontSize:Float = 0;

	public var rootBitmapData:BitmapData;

	public function clear():Void {
		__chars = [];
		__tileset.rectData = new Vector();
		@:privateAccess __tileset.__data = [];
	}

	public function new(bitmapData:BitmapData) {
		this.isTextAtlas = true;
		this.rootBitmapData = bitmapData;
		__tileset = new Tileset(bitmapData);
	}

	public function getTileFrame(id:Int):FntFrame {
		return __chars.get(id);
	}

	public function getFontHeight():Float {
		return fontSize;
	}

	public function pushChar(char:String, rect:Rectangle, xadvance:Int):Void {
		var code = char.charCodeAt(0);
		var id = __tileset.addRect(rect);
		var frame = new FntFrame();
		frame.x = 0;
		frame.y = 0;
		frame.width = rect.width;
		frame.height = rect.height;
		frame.xadvance = xadvance;
		frame.id = id;
		if (rect.height > maxHeight)
			maxHeight = rect.height;
		__chars.set(code, frame);
	}

	override function getTileset():Tileset {
		return __tileset;
	}
}
