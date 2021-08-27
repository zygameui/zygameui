package zygame.utils;

import zygame.components.ZBuilder;
import openfl.events.Event;
import zygame.components.ZBuilderScene;
import zygame.components.ZScene;
import zygame.core.Start;

/**
 *  场景管理器
 */
class ZSceneManager {
	/**
	 * 存放历史记录
	 */
	private static var _history:Array<Class<ZScene>> = [];

	private static var _scenes:Array<ZScene>;

	private static var _current:ZSceneManager;

	/**
	 *  获取场景管理的单例
	 */
	public static var current(get, never):ZSceneManager;

	private static function get_current():ZSceneManager {
		if (_current == null) {
			_scenes = [];
			_current = new ZSceneManager();
		}
		return _current;
	}

	private var _sceneMaps:Map<String, ZScene>;

	public function new() {
		_sceneMaps = [];
	}

	/**
	 * 获取当前场景
	 * @return ZScene
	 */
	public function getCurrentScene():ZScene {
		if (_scenes.length == 0)
			return null;
		return _scenes[_scenes.length - 1];
	}

	/**
	 *  创建场景，如果重复创建会复用使用
	 *  @param cName - 
	 *  @return ZScene
	 */
	public function createScene<T:ZScene>(cName:Class<T>, added:Bool = false):T {
		var key = Type.getClassName(cName);
		var scene:ZScene = _sceneMaps.get(key);
		if (scene == null) {
			scene = Type.createInstance(cName, []);
			_sceneMaps.set(key, scene);
			if (added)
				Start.current.addChild(scene);
		} else {
			if (added)
				Start.current.addChild(scene);
			scene.onSceneReset();
		}
		_scenes.push(scene);
		return cast scene;
	}

	/**
	 *  主动释放场景
	 *  @param zScene - 指定场景
	 */
	public function releaseScene(zScene:ZScene):Void {
		#if debug
		trace("releaseScene:", zScene);
		#end
		zScene.onSceneRelease();
		_sceneMaps.remove(Type.getClassName(Type.getClass(zScene)));
		_scenes.remove(zScene);
		if (zScene.parent != null) {
			zScene.parent.removeChild(zScene);
		}
	}

	/**
	 * 释放所有该类的场景
	 * @param cName 
	 */
	public function releaseSceneFormClass(cName:Class<ZScene>):Void {
		var key = Type.getClassName(cName);
		var classObj:Iterator<String> = _sceneMaps.keys();
		while (classObj.hasNext()) {
			var c = classObj.next();
			if (c == key) {
				var zscene:ZScene = _sceneMaps.get(c);
				releaseScene(zscene);
			}
		}
	}

	private function _removeScene(scene:ZScene):Void {}

	/**
	 *  替换场景，会将之前的场景移除
	 *  @param cName 替换的新场景
	 *  @param isReleaseScene 是否释放当前场景
	 *  @param isHistory 是否需要记录历史记录
	 *  @param forceReplace 是否强制切换场景
	 *  @return ZScene
	 */
	public function replaceScene<T:ZScene>(cName:Class<T>, isReleaseScene:Bool = false, isHistory:Bool = true, forceReplace:Bool = false):T {
		var key = Type.getClassName(cName);
		var key2 = getCurrentScene() != null ? Type.getClassName(Type.getClass(getCurrentScene())) : null;
		if (getCurrentScene() != null && key == key2)
			return cast getCurrentScene();
		var zscene:ZScene = null;
		while (_scenes.length > 0) {
			zscene = _scenes.shift();
		}
		if (isHistory) {
			// 仅保留5个历史记录
			_history.push(cast cName);
			if (_history.length > 5) {
				_history.shift();
			}
		}
		#if debug
		trace("replaceScene:", cName);
		#end
		// 如果是释放，则提前将ZAssets释放掉
		if (isReleaseScene && Std.isOfType(zscene, ZBuilderScene)) {
			ZBuilder.unbindAssets(cast(zscene, ZBuilderScene).assetsBuilder.assets);
		}
		var newscene = createScene(cName);
		if (zscene != null) {
			if (!Std.isOfType(newscene, ZBuilderScene) || cast(newscene, ZBuilderScene).loaded || forceReplace) {
				// 如果是释放场景，那么就会主动释放场景。
				if (isReleaseScene)
					releaseScene(zscene);
				else
					zscene.parent.removeChild(zscene);
			} else {
				GC.retain(zscene);
				newscene.addEventListener(Event.COMPLETE, function(_) {
					if (isReleaseScene)
						releaseScene(zscene);
					else
						zscene.parent.removeChild(zscene);
					GC.release(zscene);
				});
			}
		}
		#if debug
		trace("replaceScene addChild:", cName);
		#end
		Start.current.addChild(newscene);
		return newscene;
	}

	/**
	 * 返回历史场景
	 * @param isReleaseScene 
	 * @return ZScene
	 */
	public function replaceHistoryScene(isReleaseScene:Bool = false):ZScene {
		// 回退时，需要先将自已的场景移除掉
		_history.pop();
		var c = _history.pop();
		trace("_history=", c);
		if (c != null) {
			return this.replaceScene(c, isReleaseScene, true);
		}
		return null;
	}

	/**
	 * 根据实例替换场景
	 * @param scene 
	 * @param isReleaseScene 
	 * @return ZScene
	 */
	public function replaceSceneFormDisplay(scene:ZScene, isReleaseScene:Bool = false):ZScene {
		while (_scenes.length > 0) {
			var zscene:ZScene = _scenes.shift();
			// 如果是释放场景，那么就会主动释放场景。
			if (isReleaseScene)
				releaseScene(zscene);
			else
				zscene.parent.removeChild(zscene);
		}
		Start.current.addChild(scene);
		_scenes.push(scene);
		return scene;
	}

	/**
	 *  创建场景，如果重复创建会复用使用
	 *  @param cName - 
	 *  @return ZScene
	 */
	public function replaceSceneFormScene(scene:ZScene):ZScene {
		var key = Type.getClassName(Type.getClass(scene));
		_sceneMaps.set(key, scene);
		Start.current.addChild(scene);
		_scenes.push(scene);
		return scene;
	}
}
