package zygame.utils;

import hx.assets.XmlAtlas;
import zygame.utils.ZAssets;
import hx.core.OpenFlBitmapData;
import hx.display.BitmapData;
import hx.assets.Assets;

/**
 * 通过`zygame.utils.Assets`提供的资源加载器
 */
class ZMakerAssets extends Assets {
	public var assets:ZAssets;

	public function new(assets:ZAssets) {
		super();
		this.assets = assets;
		// 绑定位图
		for (key => value in @:privateAccess this.assets._bitmaps) {
			this.bitmapDatas.set(key, OpenFlBitmapData.fromBitmapData(value));
		}
		// 绑定json
		for (key => value in @:privateAccess this.assets._jsons) {
			this.objects.set(key, value);
		}
		// 绑定精灵图
		for (key => value in @:privateAccess this.assets._textures) {
			this.atlases.set(key, new XmlAtlas(OpenFlBitmapData.fromBitmapData(value.rootBitmapData), @:privateAccess value._rootXml));
		}
	}
}
