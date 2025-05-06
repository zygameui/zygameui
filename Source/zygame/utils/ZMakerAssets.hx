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
		this.updateAssets();
	}

	public function updateAssets():Void {
		// 绑定位图
		for (key => value in @:privateAccess this.assets._bitmaps) {
			if (!this.bitmapDatas.exists(key)) {
				this.bitmapDatas.set(key, OpenFlBitmapData.fromBitmapData(value));
			}
		}
		// 绑定json
		for (key => value in @:privateAccess this.assets._jsons) {
			if (!this.objects.exists(key)) {
				this.objects.set(key, value);
			}
		}
		// 绑定精灵图
		for (key => value in @:privateAccess this.assets._textures) {
			if (!this.atlases.exists(key)) {
				this.atlases.set(key, new XmlAtlas(OpenFlBitmapData.fromBitmapData(value.rootBitmapData), @:privateAccess value._rootXml));
			}
		}
	}
}
