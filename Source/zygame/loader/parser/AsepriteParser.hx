package zygame.loader.parser;

import zygame.components.data.AnimationData;
import zygame.utils.load.Frame;
import haxe.Json;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;
import zygame.utils.load.TextureLoader.TextureAtlas;

/**
 * 加载Aseprite的精灵图格式
 */
class AsepriteParser extends ParserBase {
	override function process() {
		AssetsUtils.loadBitmapData(getData().path).onComplete(function(data) {
			AssetsUtils.loadText(getData().json).onComplete(function(json) {
				var atlas = new AsepriteTextureAtlas(data, Json.parse(json));
				finalAssets(TEXTUREATLAS, atlas, 1);
			}).onError(function(data) {
				error("加载失败");
			});
		}).onError(function(data) {
			error("加载失败");
		});
	}
}

/**
 * Aseprite的精灵图
 */
class AsepriteTextureAtlas extends TextureAtlas {
	/**
	 * Tags对象
	 */
	public var frameTags:Map<String, AsepriteFrameTag> = [];

	/**
	 * Tags解析后的绑定位图数据
	 */
	public var frameBitmapData:Map<String, AnimationData> = [];

	/**
	 * 解析JSON数据
	 * @param json 
	 * @return Xml
	 */
	public function converJsonToXml(json:AsepriteJson):Xml {
		var xml = Xml.createDocument();
		var root = Xml.createElement("TextureAtlas");
		xml.addChild(root);
		var keys = Reflect.fields(json.frames);
		for (key in keys) {
			var value = Reflect.getProperty(json.frames, key);
			var item = Xml.createElement("Texture");
			item.set("x", Std.string(value.frame.x));
			item.set("y", Std.string(value.frame.y));
			item.set("width", Std.string(value.frame.w));
			item.set("height", Std.string(value.frame.h));
			item.set("frameX", Std.string(-value.spriteSourceSize.x));
			item.set("frameY", Std.string(-value.spriteSourceSize.y));
			item.set("frameWidth", Std.string(value.sourceSize.w));
			item.set("frameHeight", Std.string(value.sourceSize.h));
			item.set("name", key);
			root.addChild(item);
		}
		return xml;
	}

	public function new(bitmapData:BitmapData, json:AsepriteJson) {
		// JSON转换为XML配置
		super(bitmapData, converJsonToXml(json));
		// 解析tag的位图组
		for (tag in json.meta.frameTags) {
			frameTags.set(tag.name, tag);
			var array:AnimationData = new AnimationData(Std.int(1000 / 100));
			var i = tag.from;
			while (i <= tag.to) {
				array.addFrame(getBitmapDataFrameAt(i));
				i++;
			}
			frameBitmapData.set(tag.name, array);
		}
	}
}

/**
 * Aseprite的Json格式数据
 */
typedef AsepriteJson = {
	frames:Dynamic<{
		frame:{
			x:Int,
			y:Int,
			w:Int,
			h:Int
		},
		rotated:Bool,
		trimmed:Bool,
		spriteSourceSize:{
			x:Int,
			y:Int,
			w:Int,
			h:Int
		},
		sourceSize:{w:Int, h:Int},
		duration:Int
	}>,
	meta:{
		app:String, version:String, image:String, format:String, size:{w:Int, h:Int}, scale:String, frameTags:Array<AsepriteFrameTag>
	}
}

/**
 * FrameTag数据
 */
typedef AsepriteFrameTag = {
	name:String,
	from:Int,
	to:Int,
	direction:String
}
