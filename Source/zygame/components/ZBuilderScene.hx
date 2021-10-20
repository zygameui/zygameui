package zygame.components;

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
	 * 自适配宽度
	 */
	private var _hdwidth:Null<Float> = null;

	/**
	 * 自适配高度
	 */
	private var _hdheight:Null<Float> = null;

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

	public var bgDisplay:ZQuad;

	public function onSizeChange(width:Float, height:Float):Void {
		var currentScale = ScaleUtils.mathScale(getStageWidth(), getStageHeight(), width, height, false, false);
		this.scale(currentScale);
		_hdwidth = Std.int(getStageWidth() / this.scaleX) + 1;
		_hdheight = Std.int(getStageHeight() / this.scaleY) + 1;
	}

	override function onInit() {
		super.onInit();

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
		assetsBuilder.dispose();
		// todo 如果这里不释放，是否可以解决空对象访问，内存是否能正常释放
		// assetsBuilder = null;
	}

	function get_loaded():Bool {
		return _loaded;
	}

	override function getStageWidth():Float {
		return _hdwidth != null ? _hdwidth : super.getStageWidth();
	}

	override function getStageHeight():Float {
		return _hdheight != null ? _hdheight : super.getStageHeight();
	}
}
