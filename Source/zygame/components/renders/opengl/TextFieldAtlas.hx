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
	private var __chars:Map<Int, FntFrame> = [];

	private var __emojs:Map<String, FntFrame> = [];

	public var maxHeight:Float = 0;

	public var fontSize:Float = 0;

	public function clear():Void {
		__chars = [];
		__emojs = [];
		__tileset.rectData = new Vector();
		@:privateAccess __tileset.__data = [];
	}

	public function new(bitmapData:BitmapData) {
		this.isTextAtlas = true;
		super(new Tileset(bitmapData));
	}

	public function getTileFrame(id:Int):FntFrame {
		return __chars.get(id);
	}

	public function getFontHeight():Float {
		return fontSize;
	}

	public function pushChar(char:String, rect:Rectangle, xadvance:Int):Void {
		var id = __tileset.addRect(rect);
		var frame = new FntFrame(this);
		frame.x = 0;
		frame.y = 0;
		frame.width = rect.width;
		frame.height = rect.height;
		frame.xadvance = xadvance;
		frame.id = id;
		if (rect.height > maxHeight)
			maxHeight = rect.height;
		if (char.length == 2) {
			// emoj表情
			__emojs.set(char, frame);
		} else {
			var code = char.charCodeAt(0);
			__chars.set(code, frame);
		}
	}

	override function getTileset():Tileset {
		return __tileset;
	}

	/**
	 * 通过emoj获得一个纹理
	 * @param emoj 
	 * @return FntFrame
	 */
	public function getTileFrameByEmoj(emoj:String):FntFrame {
		return __emojs.get(emoj);
	}
}
