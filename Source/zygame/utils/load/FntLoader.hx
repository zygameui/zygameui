package zygame.utils.load;

import zygame.components.base.IFontAtlas;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.utils.Dictionary;
import zygame.utils.load.Atlas;
import zygame.utils.load.BaseFrame;
import zygame.utils.AssetsUtils in Assets;

/**
 * 位图字体载入器
 */
class FntLoader {
	public var pngpath:String;

	public var xmlpath:String;

	public function new(pngpath:String, xmlpath:String) {
		this.pngpath = pngpath;
		this.xmlpath = xmlpath;
	}

	/**
	 * 开始载入位图
	 * @param call 
	 */
	public function load(call:FntData->Void, errorCall:String->Void) {
		Assets.loadBitmapData(pngpath).onComplete(function(bitmapData:BitmapData):Void {
			Assets.loadText(xmlpath).onComplete(function(data:String):Void {
				call(new FntData(bitmapData, Xml.parse(data), pngpath));
			}).onError(errorCall);
		}).onError(errorCall);
	}
}

/**
 * 字体数据
 */
class FntData extends Atlas implements IFontAtlas {
	private var _xml:Xml;

	public var path:String;
	public var maxHeight:Float = 0;

	private var _ids:Dictionary<Int, FntFrame>;

	/**
	 * 文本字体的高度
	 */
	public function getFontHeight():Float {
		return maxHeight;
	}

	public function new(bitmapData:BitmapData, xml:Xml, path:String) {
		this._ids = new Dictionary<Int, FntFrame>();
		this._xml = xml;
		this.path = path;
		// 解析瓦片
		var _tileset = new Tileset(bitmapData);
		super(_tileset);
		var chars:Iterator<Xml> = xml.elementsNamed("font").next().elementsNamed("chars").next().elements();
		var minYOffect:Float = 99999;
		while (chars.hasNext()) {
			var char:Xml = chars.next();
			var id:Int = Std.parseInt(char.get("id"));
			var posx:Float = Std.parseFloat(char.get("x"));
			var posy:Float = Std.parseFloat(char.get("y"));
			var pwidth:Float = Std.parseFloat(char.get("width"));
			var pheight:Float = Std.parseFloat(char.get("height"));
			var xadvance:Int = Std.parseInt(char.get("xadvance"));
			if (pwidth != 0 && pheight != 0) {
				var frame:FntFrame = new FntFrame(this);
				frame.id = _tileset.addRect(new Rectangle(posx, posy, pwidth, pheight));
				frame.width = pwidth;
				frame.height = pheight;
				frame.xadvance = xadvance;
				frame.xoffset = Std.parseInt(char.get("xoffset"));
				frame.yoffset = Std.parseInt(char.get("yoffset"));
				this._ids.set(id, frame);
				if (maxHeight < pheight)
					maxHeight = pheight;
				if (minYOffect > frame.yoffset)
					minYOffect = frame.yoffset;
			}
		}

		var frames:Iterator<FntFrame> = this._ids.each();
		while (frames.hasNext()) {
			var fntFrame = frames.next();
			fntFrame.yoffset -= minYOffect;
		}
	}

	public function getTileFrame(id:Int):FntFrame {
		return _ids.get(id);
	}

	public function dispose():Void {
		zygame.utils.ZGC.disposeBitmapData(getRootBitmapData());
		_ids = null;
	}

	/**
	 * 通过emoj获得一个纹理
	 * @param emoj 
	 * @return FntFrame
	 */
	public function getTileFrameByEmoj(emoj:String):FntFrame {
		return null;
	}
}

/**
 * 位图精灵帧
 */
class FntFrame extends BaseFrame {
	public var xadvance:Int = 0;

	public var xoffset(get, set):Float;

	private function set_xoffset(f:Float):Float {
		x = f;
		return f;
	}

	private function get_xoffset():Float {
		return x;
	}

	public var yoffset(get, set):Float;

	private function set_yoffset(f:Float):Float {
		y = f;
		return f;
	}

	private function get_yoffset():Float {
		return y;
	}
}
