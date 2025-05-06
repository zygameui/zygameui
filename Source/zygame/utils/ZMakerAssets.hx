package zygame.utils;

import haxe.Json;
import spine.attachments.AtlasAttachmentLoader;
import hx.assets.SpineTextureAtlas;
import zygame.utils.load.SpineTextureAtalsLoader.SpineTextureAtals;
import hx.assets.XmlAtlas;
import zygame.utils.ZAssets;
import hx.core.OpenFlBitmapData;
import hx.display.BitmapData;
import hx.assets.Assets;
import spine.SkeletonJson;
#if spine_haxe
import spine.atlas.TextureAtlas;
#else
import spine.support.graphics.TextureAtlas;
#end

/**
 * 通过`zygame.utils.Assets`提供的资源加载器
 */
class ZMakerAssets extends Assets {
	public var assets:ZAssets;

	public function new(assets:ZAssets) {
		super();
		this.assets = assets;
		this.updateAssets();
	}

	public function updateAssets(force:Bool = false):Void {
		// 绑定位图
		for (key => value in @:privateAccess this.assets._bitmaps) {
			if (force || !this.bitmapDatas.exists(key)) {
				this.bitmapDatas.set(key, OpenFlBitmapData.fromBitmapData(value));
			}
		}
		// 绑定json
		for (key => value in @:privateAccess this.assets._jsons) {
			if (force || !this.objects.exists(key)) {
				this.objects.set(key, value);
			}
		}
		// 绑定精灵图
		for (key => value in @:privateAccess this.assets._textures) {
			if (force || !this.atlases.exists(key)) {
				this.atlases.set(key, new XmlAtlas(OpenFlBitmapData.fromBitmapData(value.rootBitmapData), @:privateAccess value._rootXml));
			}
		}
		// 绑定字符串
		for (key => value in @:privateAccess this.assets._strings) {
			if (force || !this.strings.exists(key)) {
				this.strings.set(key, value);
			}
		}
		// 绑定spine
		for (key => value in @:privateAccess this.assets._spines) {
			if (force || !this.atlases.exists(key)) {
				var bitmapDatas = @:privateAccess value._bitmapDatas;
				var atlasString = @:privateAccess value._data;
				var spineTextureAtlas = new SpineTextureAtlas(OpenFlBitmapData.fromBitmapData(bitmapDatas.iterator().next()));
				var atlas:TextureAtlas = new TextureAtlas(atlasString, spineTextureAtlas);
				spineTextureAtlas.skeletonJson = new SkeletonJson(new AtlasAttachmentLoader(atlas));
				this.atlases.set(key, spineTextureAtlas);
				// 顺便更新strings
				this.strings.set(key, Json.stringify(this.assets.getObject(key)));
			}
		}
	}
}
