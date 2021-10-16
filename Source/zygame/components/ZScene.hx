package zygame.components;

import openfl.display.DisplayObject;
import zygame.core.Start;
import zygame.components.ZBox;
import zygame.components.ZScene;
import zygame.utils.ZSceneManager;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 *  场景，用于管理不同的场景使用
 */
class ZScene extends ZBox {
	public function new() {
		super();
	}

	/**
	 *  当场景被创建后，重新createScene或者替换场景时，会进行调用场景重设，这时应该在这里进行重置数据。
	 */
	public function onSceneReset():Void {}

	/**
	 *  当场景释放时，请在这里精准释放所有额外内容。
	 */
	public function onSceneRelease():Void {
		setFrameEvent(false);
		setTouchEvent(false);
		// 测试性
		this.destroy();
	}

	/**
	 *  创建场景
	 *  @param cName - 
	 *  @return ZScene
	 */
	public function createScene<T:ZScene>(cName:Class<T>):T {
		return ZSceneManager.current.createScene(cName);
	}

	/**
	 *  替换场景，会将之前的场景移除
	 *  @param cName 替换的新场景
	 *  @param isReleaseScene 是否释放当前场景
	 *  @param isHistory 是否需要记录历史记录
	 *  @param forceReplace 是否强制切换场景
	 *  @param parameter 定义属性变更，如果传递的时候，设置的属性，则可以变更对应的参数
	 *  @return ZScene
	 */
	public function replaceScene<T:ZScene>(cName:Class<T>, isReleaseScene:Bool = false, isHistory:Bool = true, forceReplace:Bool = false,
			parameter:Dynamic = null):T {
		return ZSceneManager.current.replaceScene(cName, isReleaseScene, isHistory, forceReplace, parameter);
	}

	/**
	 * 释放当前场景
	 */
	public function releaseScene():Void {
		ZSceneManager.current.releaseScene(this);
	}

	/**
	 * 返回上一个场景，仅记录5个场景记录
	 * @param isReleaseScene 
	 * @return ZScene
	 */
	public function replaceHistoryScene(isReleaseScene:Bool = false):ZScene {
		return ZSceneManager.current.replaceHistoryScene(isReleaseScene);
	}

	override private function get_width():Float {
		return getStageWidth();
	}

	override private function get_height():Float {
		return getStageHeight();
	}

	private var _lockScene:ZLockScene;
	private var _lockDisplay:DisplayObject;

	/**
	 * 是否被锁定
	 * @return Bool
	 */
	public function isLockScene():Bool {
		return _lockScene != null;
	}

	/**
	 * 锁定画布渲染，锁定后可让draw变成1draw，当调用了lock之后，在更换新的场景之前，务必先调用unlock
	 * @param display 如果不传递时，在ZBuilderScene类下，会自动定位显示对象，其他类型需要传递
	 */
	public function lockScene(display:DisplayObject = null):Void {
		if (_lockDisplay != null)
			return;
		if (display == null && Std.isOfType(this, ZBuilderScene)) {
			display = cast(this, ZBuilderScene).assetsBuilder.display;
		}
		if (display == null || display.parent != this) {
			trace("lockScene Error:Display's parent not is this.");
			return;
		}
		_lockScene = new ZLockScene();
		_lockScene.lockBitmapScene(this);
		_lockDisplay = display;
		var childIndex = this.getChildIndex(display);
		display.parent.removeChild(display);
		this.addChildAt(_lockScene, childIndex);
	}

	/**
	 * 解除画布渲染锁定
	 */
	public function unlockScene():Void {
		if (_lockDisplay != null) {
			var childIndex = this.getChildIndex(_lockScene);
			_lockScene.parent.removeChild(_lockScene);
			_lockScene.releaseScene();
			this.addChildAt(_lockDisplay, childIndex);
			_lockDisplay = null;
			_lockScene = null;
		}
	}
}
