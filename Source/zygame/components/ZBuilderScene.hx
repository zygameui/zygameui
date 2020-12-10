package zygame.components;

import zygame.macro.AutoBuilder;
import zygame.macro.JSONData;
import zygame.components.ZBuilder.AssetsBuilder;

/**
 * 通过ZBuilder创建场景，请注意在new构造函数准备好所有需要加载的资源。在触发onInit后，会自动载入；
 * 加载完成后会触发onBuilded事件；加载失败会触发onBuildError事件。场景在释放时，会自动释放掉assetsBuilder。
 */
class ZBuilderScene extends ZScene {
	public var assetsBuilder:AssetsBuilder;

	public function new(xmlPath:String) {
		super();
		assetsBuilder = ZBuilder.createAssetsBuilder(xmlPath, this);
	}

	/**
	 * 根据类型获取对象
	 * @param id
	 * @param type
	 * @return T
	 */
	public function get<T:Dynamic>(id:String, type:Class<T>):Null<T> {
		return assetsBuilder.get(id,type);
	}

	override function onInit() {
		super.onInit();
		
		//透明层，避免重复点击
		var bg:ZQuad = new ZQuad();
		this.addChild(bg);
		bg.alpha = 0;
		bg.width = getStageWidth();
		bg.height = getStageHeight();

		this.onLoad();
		assetsBuilder.build(function(bool) {
			if (bool) {
				ZBuilder.bindAssets(assetsBuilder.assets);
				onBuilded();
			} else {
				onBuildError();
			}
		},onLoaded);
	}

	/**
	 * 开始加载，如果需要额外加载资源，请重写onLoad后对assetsBuilder追加。
	 */
	public function onLoad() {}

	public function onLoaded() {}

	public function onBuilded() {}

	public function onBuildError() {}

	override function onSceneRelease() {
		super.onSceneRelease();
		ZBuilder.unbindAssets(assetsBuilder.assets);
		assetsBuilder.dispose();
		assetsBuilder = null;
	}
}
