package zygame.loader.parser;

import zygame.utils.Lib;
import zygame.utils.load.TextureLoader.TextureAtlas;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;

/**
 * 精灵图表载入解析器(同时支持Base64、路径载入)
 */
@:keep
class TextureAtlasParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return true;
	}

	public var bitmapData:BitmapData;

	override function process() {
		var img = getData().imgpath;
		var xml = getData().xmlpath;
		var atf = getData().atf;
		if (getAssets().existZipAssets(this.getName(), "png")) {
			@:privateAccess getAssets().loadZipTextureAtlas(this.getName(), function(t:TextureAtlas):Void {
				if (t != null) {
					t.path = xml;
					finalAssets(TEXTUREATLAS, t, 1);
				}
			});
			return;
		}
		var isbase64 = Lib.isBase64(img);
		if (bitmapData == null) {
			if (isbase64) {
				// Base64载入法
				BitmapData.loadFromBase64(img, "image/png").onComplete(function(data) {
					bitmapData = data;
					this.finalAssets(PROGRESS, null, 0.5);
					this.contiune();
				}).onError(function(err) {
					sendError("TextureAtlas 无法解析Base64数据：" + getData().path);
				});
			} else {
				var paresr = LoaderAssets.createParserBase(img, getAssets().extPasrer);
				paresr.out = (parser, type, assetsData, pro) -> {
					bitmapData = assetsData;
					this.finalAssets(PROGRESS, null, 0.5);
					this.contiune();
				};
				paresr.error = (msg) -> {
					sendError("TextureAtlas PNG无法加载路径：" + getData().path);
				}
				paresr.load(getAssets());
			}
		} else {
			// 开始载入XML
			if (isbase64) {
				// Base64一般使用现成的XML数据
				var textureAtlas:TextureAtlas = new TextureAtlas(bitmapData, Xml.parse(xml));
				textureAtlas.path = getData().path;
				finalAssets(TEXTUREATLAS, textureAtlas, 1);
				bitmapData = null;
			} else {
				// 载入
				AssetsUtils.loadText(xml).onComplete(function(xmldata) {
					var textureAtlas:TextureAtlas = new TextureAtlas(bitmapData, Xml.parse(xmldata));
					textureAtlas.path = getData().path;
					finalAssets(TEXTUREATLAS, textureAtlas, 1);
					bitmapData = null;
				}).onError(function(err) {
					sendError("TextureAtlas XML无法加载路径：" + getData().path);
				});
			}
		}
	}
}
