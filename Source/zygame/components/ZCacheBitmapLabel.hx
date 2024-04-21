package zygame.components;

import zygame.components.base.ZCacheTextField;

/**
 * 自动缓存文本字渲染
 */
class ZCacheBitmapLabel extends ZBitmapLabel {
	public var cacheAtlas:ZCacheTextField;

	/**
	 * 构造一个缓存文本渲染器
	 */
	public function new() {
		cacheAtlas = new ZCacheTextField("cache", null, 12, 0x0);
		cacheAtlas.text = "";
		super(cacheAtlas.getAtlas());
		this.wordWrap = true;
        this.vAlign = "center";
	}

	override function setFontSize(size:Int) {
		cacheAtlas.setFontSize(size);
	}

	override function setFontColor(color:Null<Int>) {
		cacheAtlas.setFontColor(color);
	}

	override function set_dataProvider(value:Dynamic):Dynamic {
		if (Std.isOfType(value, Int))
			value = Std.string(value);
		cacheAtlas.text = value;
		return super.set_dataProvider(value);
	}
}
