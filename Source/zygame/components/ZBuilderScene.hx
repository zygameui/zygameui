package zygame.components;

import zygame.utils.Lib;
import openfl.events.Event;
import zygame.utils.ZSceneManager;
import zygame.macro.AutoBuilder;
import zygame.macro.JSONData;
import zygame.components.ZBuilder.AssetsBuilder;

/**
 * 通过ZBuilder创建场景，请注意在new构造函数准备好所有需要加载的资源。在触发onInit后，会自动载入；
 * 加载完成后会触发onBuilded事件；加载失败会触发onBuildError事件。场景在释放时，会自动释放掉assetsBuilder。
 */
class ZBuilderScene extends ZScene {
	/**
	 * 资源管理对象
	 */
	public var assetsBuilder:AssetsBuilder;

	/**
	 * 是否已经加载完毕
	 */
	public var loaded(get, never):Bool;

	private var _loaded:Bool = false;

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
		return assetsBuilder.get(id, type);
	}

	override function onInit() {
		super.onInit();

		// 透明层，避免重复点击
		var bg:ZQuad = new ZQuad();
		this.addChild(bg);
		bg.alpha = 0;
		bg.width = getStageWidth();
		bg.height = getStageHeight();

		this.onLoad();
		assetsBuilder.build(function(bool) {
			if (bool) {
				ZBuilder.bindAssets(assetsBuilder.assets);
				_loaded = true;
				onBuilded();
				postCompleteEvent();
			} else {
				if (onBuildError()) {
					ZSceneManager.current.releaseScene(this);
				}
			}
		}, onLoaded);
	}

	/**
	 * 发起加载完成的事件
	 */
	private function postCompleteEvent() {
		this.dispatchEvent(new Event(Event.COMPLETE));
	}

	/**
	 * 开始加载，如果需要额外加载资源，请重写onLoad后对assetsBuilder追加。
	 */
	public function onLoad() {}

	public function onLoaded() {}

	public function onBuilded() {
		this.onBuildedEvent();
	}

	dynamic public function onBuildedEvent():Void {}

	/**
	 * 构造失败，一般为加载失败时触发，当返回true时，该窗口会自动移除，返回false可自行处理。
	 * @return Bool
	 */
	public function onBuildError():Bool {
		return true;
	}

	override function onSceneRelease() {
		super.onSceneRelease();
		ZBuilder.unbindAssets(assetsBuilder.assets);
		// 如果太早释放资源，可能会造成画面黑块的问题，延迟一定时间释放
		assetsBuilder.dispose();
		assetsBuilder = null;
	}

	function get_loaded():Bool {
		return _loaded;
	}
}
