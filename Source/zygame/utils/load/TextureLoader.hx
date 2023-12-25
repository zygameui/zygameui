package zygame.utils.load;

import haxe.Exception;
import haxe.Json;
import openfl.Vector;
import openfl.display.BitmapData;
// import openfl.Assets;
import zygame.utils.AssetsUtils in Assets;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.utils.Dictionary;
import openfl.display.Tileset;
import zygame.utils.load.Frame;
import zygame.utils.load.Atlas;
import openfl.utils.ByteArray;

/**
 *  纹理集合载入器
 */
class TextureLoader {
	public var imgPath:String;

	public var xmlPath:String;

	public function new(img:String, xml:String) {
		imgPath = img;
		xmlPath = xml;
	}

	/**
	 *  开始载入
	 * @param func -
	 */
	public function load(func:TextureAtlas->Void, errorCall:String->Void):Void {
		Assets.loadBitmapData(imgPath, false).onComplete(function(bitmapdata:BitmapData):Void {
			Assets.loadText(xmlPath).onComplete(function(data:String):Void {
				var xml:Xml = null;
				try {
					xml = Xml.parse(data);
				} catch (e:Exception) {
					throw data + "\n" + e.message + " " + e.stack.toString();
				}
				var textureAtlas:TextureAtlas = new TextureAtlas(bitmapdata, xml);
				textureAtlas.path = imgPath;
				func(textureAtlas);
			}).onError(errorCall);
		}).onError(errorCall);
	}
}

/**
 * 通过Base64加载图集
 */
class Base64TextureLoader extends TextureLoader {
	private var _base64:String;

	private var _xmlData:String;

	public function new(img:String, xml:String, filename:String) {
		_base64 = img;
		_xmlData = xml;
		super(filename, filename);
	}

	/**
	 *  开始载入
	 * @param func -
	 */
	override public function load(func:TextureAtlas->Void, errorCall:String->Void):Void {
		BitmapData.loadFromBase64(_base64, "image/png").onComplete(function(bitmapData:BitmapData):Void {
			var xml:Xml = null;
			try {
				xml = Xml.parse(_xmlData);
			} catch (e:Exception) {
				throw _xmlData + "\n" + e.message + " " + e.stack.toString();
			}
			var textureAtlas:TextureAtlas = new TextureAtlas(bitmapData, xml);
			textureAtlas.path = imgPath;
			func(textureAtlas);
		}).onError(errorCall);
	}
}

/**
 *  纹理集
 */
class TextureAtlas extends Atlas {
	/**
	 * 创建一张图的精灵表，提供给位图九宫格使用，精灵名为img
	 * @param bitmapData
	 * @return TextureAtlas
	 */
	public static function createTextureAtlasByOne(bitmapData:BitmapData):TextureAtlas {
		var xml:Xml = Xml.parse('<TextureAtlas><SubTexture name="img" x="0" y="0" width="'
			+ bitmapData.width
			+ '" height="'
			+ bitmapData.height
			+ '"/></TextureAtlas>');
		var atlas:TextureAtlas = new TextureAtlas(bitmapData, xml);
		return atlas;
	}

	public var path:String;

	private var _names:Array<String>;

	private var _rootBitmapData:BitmapData;

	private var _rootXml:Xml;

	private var _tileset:Tileset;

	private var _tileRects:Dictionary<String, Frame>;

	public function new(img:BitmapData, xml:Xml) {
		_rootBitmapData = img;
		_names = [];
		_tileRects = new Dictionary<String, Frame>();
		// 创建可在Tiles里使用的索引位图
		_tileset = new Tileset(img);
		if (img != null && xml != null)
			this.updateAtlas(img, xml);
	}

	/**
	 * 更新精灵表
	 * @param bitmapData
	 * @param xml
	 */
	public function updateAtlas(bitmapData:BitmapData, xml:Xml):Array<Rectangle> {
		_names = [];
		_rootXml = xml;
		// 重置所有的字
		for (key => value in _tileRects) {
			value.id = -1;
		}
		// 解析纹理
		var xmls:Iterator<Xml> = null;
		try {
			xmls = xml.firstElement().elements();
		} catch (e:Dynamic) {
			return null;
		}
		var rect:Rectangle = new Rectangle();
		var pos:Point = new Point();
		var rects:Array<Rectangle> = [];
		while (xmls.hasNext()) {
			var txml:Xml = xmls.next();
			rect.x = Std.parseFloat(txml.get("x"));
			rect.y = Std.parseFloat(txml.get("y"));
			rect.width = Std.parseFloat(txml.get("width"));
			rect.height = Std.parseFloat(txml.get("height"));
			// 追加到位图设置中
			var trect:Rectangle = rect.clone();
			rects.push(trect);

			var frame:Frame = null;
			// 创建批处理帧
			if (_tileRects.exists(txml.get("name"))) {
				frame = _tileRects.get(txml.get("name"));
			} else {
				frame = new Frame();
				frame.name = txml.get("name");
				_tileRects.set(txml.get("name"), frame);
			}

			frame.id = rects.length - 1;
			frame.x = trect.x;
			frame.y = trect.y;
			frame.width = trect.width;
			frame.height = trect.height;

			if (txml.exists("frameX"))
				frame.frameX = -Std.parseFloat(txml.get("frameX"));
			if (txml.exists("frameY"))
				frame.frameY = -Std.parseFloat(txml.get("frameY"));
			if (txml.exists("frameWidth"))
				frame.frameWidth = Std.parseInt(txml.get("frameWidth"));
			if (txml.exists("frameHeight"))
				frame.frameHeight = Std.parseInt(txml.get("frameHeight"));
			frame.parent = this;
			_names.push(txml.get("name"));
			if (txml.exists("slice9")) {
				this.bindScale9(txml.get("name"), txml.get("slice9"));
			}
		}
		// 更新渲染
		_tileset.bitmapData = bitmapData;
		_tileset.rectData = new Vector<Float>(0, false);
		@:privateAccess _tileset.__data = new Array();
		for (i in 0...rects.length) {
			_tileset.addRect(rects[i]);
		}
		return rects;
	}

	public function getRootBitmapData():BitmapData {
		return _rootBitmapData;
	}

	override public function getTileset():Tileset {
		return _tileset;
	}

	/**
	 * 获取批处理位图
	 * @param id
	 * @return Frame
	 */
	public function getBitmapDataFrame(id:String):Frame {
		if (_tileRects == null)
			return null;
		return _tileRects.get(id);
	}

	/**
	 * 获取批处理位图
	 * @param id
	 * @return Frame
	 */
	public function getBitmapDataFrameAt(id:Int):Frame {
		if (_tileRects == null)
			return null;
		var frames:Iterator<Frame> = _tileRects.each();
		while (frames.hasNext()) {
			var frame:Frame = frames.next();
			if (frame.id == id)
				return frame;
		}
		return null;
	}

	/**
	 *  根据名字含有进行筛选位图
	 * @param id -
	 *  @return Array<BitmapData>
	 */
	public function getBitmapDataFrames(id:String):Array<Frame> {
		var arr:Array<Frame> = [];
		for (i in 0..._names.length) {
			var pname:String = _names[i];
			if (pname.indexOf(id) != -1)
				arr.push(getBitmapDataFrame(pname));
		}
		return arr;
	}

	public function dispose():Void {
		zygame.utils.ZGC.disposeBitmapData(_rootBitmapData);
		_rootBitmapData = null;
		if (_tileset != null) {
			_tileset.bitmapData = null;
			_tileset.rectData = null;
			_tileset = null;
		}
		_rootXml = null;
		_tileRects = null;
	}

	/**
	 * 给某个精灵对象绑定九宫格，在批渲染中使用Scale9时，将不需要设置scale9。
	 * @param id
	 * @param data 支持String Rectangle
	 */
	public function bindScale9(id:String, data:Dynamic):Void {
		var curframe:Frame = getBitmapDataFrame(id);
		var rect:Rectangle = null;
		if (Std.isOfType(data, String)) {
			rect = zygame.utils.Lib.cssRectangle(curframe, data);
		} else if (Std.isOfType(data, Rectangle))
			rect = cast data;
		if (rect != null
			&& curframe != null
			&& (curframe.scale9rect == null
				|| curframe.scale9rect.x != rect.x
				|| curframe.scale9rect.y != rect.y
				|| curframe.scale9rect.width != rect.width
				|| curframe.scale9rect.height != rect.height)) {
			curframe.scale9rect = rect;
		}
	}
}

class TextTextureAtlas extends TextureAtlas {
	/**
	 * 文本的原始颜色
	 */
	public var textColor:UInt;

	public function new(img, xml, color) {
		super(img, xml);
		this.textColor = color;
		this.isTextAtlas = true;
	}
}
