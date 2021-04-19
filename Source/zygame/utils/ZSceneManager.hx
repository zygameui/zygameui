package zygame.utils;

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
	public function createScene(cName:Class<ZScene>):ZScene {
		var key = Type.getClassName(cName);
		var scene:ZScene = _sceneMaps.get(key);
		if (scene == null) {
			scene = Type.createInstance(cName, []);
			_sceneMaps.set(key, scene);
			Start.current.addChild(scene);
		} else {
			Start.current.addChild(scene);
			scene.onSceneReset();
		}
		_scenes.push(scene);
		return scene;
	}

	/**
	 *  主动释放场景
	 *  @param zScene - 指定场景
	 */
	public function releaseScene(zScene:ZScene):Void {
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

	/**
	 *  替换场景，会将之前的场景移除
	 *  @param cName 替换的新场景
	 *  @param isReleaseScene 是否释放当前场景
	 *  @param isHistory 是否需要记录历史记录
	 *  @return ZScene
	 */
	public function replaceScene(cName:Class<ZScene>, isReleaseScene:Bool = false, isHistory:Bool = true):ZScene {
		if (getCurrentScene() != null && Std.isOfType(getCurrentScene(), cName))
			return getCurrentScene();
		while (_scenes.length > 0) {
			var zscene:ZScene = _scenes.shift();
			// 如果是释放场景，那么就会主动释放场景。
			if (isReleaseScene)
				releaseScene(zscene);
			else
				zscene.parent.removeChild(zscene);
		}
		if (isHistory) {
			// 仅保留5个历史记录
			_history.push(cName);
			if (_history.length > 5) {
				_history.shift();
			}
		}
		return createScene(cName);
	}

	/**
	 * 返回历史场景
	 * @param isReleaseScene 
	 * @return ZScene
	 */
	public function replaceHistoryScene(isReleaseScene:Bool = false):ZScene {
		// 回退时，需要先将自已的场景移除掉
		trace("_history", _history);
		_history.pop();
		var c = _history.pop();
		if (c != null) {
			this.replaceScene(c, isReleaseScene, true);
		}
		return null;
	}

	/**
	 * 根据实例替换场景
	 * @param scene 
	 * @param isReleaseScene 
	 * @return ZScene
	 */
	public function releaseSceneFormDisplay(scene:ZScene, isReleaseScene:Bool = false):ZScene {
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
