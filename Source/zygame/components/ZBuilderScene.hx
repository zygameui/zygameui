package zygame.components;

import haxe.Exception;
import zygame.core.Start;
import zygame.utils.ScaleUtils;
import zygame.utils.StringUtils;
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
	 * 预载加载器实现，当添加ZBuilderScene时实现，会主动显示此载入加载器，当加载完成后，会直接移除
	 */
	public static var preloadClass:Class<Preload>;

	/**
	 * 资源管理对象
	 */
	public var assetsBuilder:AssetsBuilder;

	/**
	 * 是否已经加载完毕
	 */
	public var loaded(get, never):Bool;

	private var _loaded:Bool = false;

	private var preloadDisplay:Preload;

	/**
	 * 构造一个通过XML配置加载的场景对象，该对象可以直接使用AutoBuilder进行自动构造
	 * ```haxe
	 * @:build(zygame.macro.AutoBuilder.build("MyScene"))
	 * class MyScene extends ZBuilderScene {}
	 * ```
	 * @param xmlPath 页面XML配置路径
	 */
	public function new(xmlPath:String) {
		super();
		assetsBuilder = ZBuilder.createAssetsBuilder(xmlPath, this);
	}

	/**
	 * 根据类型获取对象
	 * @param id 对象ID
	 * @param type 对象类型
	 * @return T
	 */
	public function get<T:Dynamic>(id:String, type:Class<T>):Null<T> {
		return assetsBuilder.get(id, type);
	}

	/**
	 * 默认构造时都会有一个透明层在后面作为遮挡，如果需要隐藏，穿透点击的话可以将这个对象进行隐藏。
	 */
	public var bgDisplay:ZQuad;

	override function onInit() {
		super.onInit();

		// 是否存在预加载模块，如果存在，则显示预加载显示对象
		if (preloadClass != null) {
			preloadDisplay = Type.createInstance(preloadClass, []);
			this.addChild(preloadDisplay);
		}

		// 透明层，避免重复点击
		bgDisplay = new ZQuad();
		this.addChild(bgDisplay);
		bgDisplay.alpha = 0;
		bgDisplay.width = getStageWidth();
		bgDisplay.height = getStageHeight();

		this.onLoad();
		assetsBuilder.onSizeChange = onSizeChange;
		assetsBuilder.build(function(bool) {
			if (bool) {
				ZBuilder.bindAssets(assetsBuilder.assets);
				_loaded = true;
				this.onBuildedEvent();
				onBuilded();
				postCompleteEvent();
			} else {
				if (onBuildError()) {
					// 当如果是加载失败的情况下，应该直接释放资源，而不是走onSceneRelease。
					ZBuilder.unbindAssets(assetsBuilder.assets);
					assetsBuilder.dispose();
					ZSceneManager.current.releaseScene(this, false);
				}
			}
		}, onLoaded);
	}

	/**
	 * 预备构造xml时的处理，当设置此方法，允许在完成`ZBuilder.buildui`之前对XML配置进行修改，此方法会逐个将XML子对象返回：
	 * ```haxe
	 * this.buildXmlContent = function(xml){
	 * 	switch(xml.get("id")){
	 * 		case "a":
	 * 			xml.set("src","b");
	 *  }
	 * }
	 * ```
	 */
	public var buildXmlContent(never, set):Xml->Void;

	private function set_buildXmlContent(cb:Xml->Void):Xml->Void {
		assetsBuilder.buildXmlContent = cb;
		return cb;
	}

	/**
	 * 发起加载完成的事件
	 */
	private function postCompleteEvent() {
		this.dispatchEvent(new Event(Event.COMPLETE));
		// 当存在预加载模块，在资源已经加载完成时，需要进行移除处理
		if (preloadDisplay != null && preloadDisplay.parent != null) {
			preloadDisplay.parent.removeChild(preloadDisplay);
		}
	}

	/**
	 * 开始加载，如果需要额外加载资源，请重写onLoad后对assetsBuilder追加。
	 */
	public function onLoad() {}

	/**
	 * 加载完成事件，当前没有完成`onBuilded`事件
	 */
	public function onLoaded() {}

	/**
	 * 当页面对象构造完成，在这个时刻可以正常访问对象
	 */
	public function onBuilded() {}

	/**
	 * 对象构造成功的额外回调
	 */
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
		assetsBuilder.dispose();
		// todo 如果这里不释放，是否可以解决空对象访问，内存是否能正常释放
		// assetsBuilder = null;
	}

	function get_loaded():Bool {
		return _loaded;
	}
}

/**
 * 预加载器，需要通用的加载页面时，可给ZBuilderScene进行设置
 * ```haxe
 * ZBuilderScene.preloadClass = MyPreload;
 * ```
 */
class Preload extends ZBox {

	/**
	 * 构造一个预加载器，一般不需要自行构造
	 */
	public function new() {
		super();
		this.width = getStageWidth();
		this.height = getStageHeight();
	}

	/**
	 * 加载进度回调
	 * @param f 加载进度
	 */
	public function onProgress(f:Float):Void {}
}
