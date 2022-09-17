package zygame.utils;

#if openfl_console
import com.junkbyte.console.Cc;
#end
import haxe.Exception;
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

	private function updateParameter(scene:ZScene, parameter:Dynamic = null) {
		// 更新参数
		if (parameter != null) {
			var keys = Reflect.fields(parameter);
			try {
				for (index => value in keys) {
					Reflect.setProperty(scene, value, Reflect.getProperty(parameter, value));
				}
			} catch (e:Exception) {
				trace("无法赋值");
			}
		}
	}

	/**
	 *  创建场景，如果重复创建会复用使用
	 * @param cName - 
	 *  @return ZScene
	 */
	public function createScene<T:ZScene>(cName:Class<T>, added:Bool = false, parameter:Dynamic = null):T {
		var key = Type.getClassName(cName);
		var scene:ZScene = _sceneMaps.get(key);
		if (scene == null) {
			scene = Type.createInstance(cName, []);
			#if openfl_console
			Cc.watch(scene);
			#end
			updateParameter(scene, parameter);
			_sceneMaps.set(key, scene);
			if (added)
				Start.current.addChild(scene);
		} else {
			if (added)
				Start.current.addChild(scene);
			updateParameter(scene, parameter);
			scene.onSceneReset();
		}
		_scenes.push(scene);
		return cast scene;
	}

	/**
	 *  主动释放场景
	 * @param zScene - 指定场景
	 */
	public function releaseScene(zScene:ZScene, onSceneRelease:Bool = true):Void {
		#if debug
		trace("releaseScene:", zScene);
		#end
		if (zScene == null)
			return;
		if (onSceneRelease) {
			zScene.onSceneRelease();
			zScene.onSceneReleaseEvent();
		}
		// 如果释放了，则进行历史清理
		var c = Type.getClass(zScene);
		_history.remove(c);
		_sceneMaps.remove(Type.getClassName(c));
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
	 * @param cName 替换的新场景
	 * @param isReleaseScene 是否释放当前场景
	 * @param isHistory 是否需要记录历史记录
	 * @param forceReplace 是否强制切换场景
	 * @param parameter 定义属性变更，如果传递的时候，设置的属性，则可以变更对应的参数
	 *  @return ZScene
	 */
	public function replaceScene<T:ZScene>(cName:Class<T>, isReleaseScene:Bool = false, isHistory:Bool = true, forceReplace:Bool = false,
			parameter:Dynamic = null):T {
		var key = Type.getClassName(cName);
		var key2 = getCurrentScene() != null ? Type.getClassName(Type.getClass(getCurrentScene())) : null;
		// 验证：C++运行正常
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
		var newscene = createScene(cName, false, parameter);
		if (zscene != null) {
			if (!Std.isOfType(newscene, ZBuilderScene) || cast(newscene, ZBuilderScene).loaded || forceReplace) {
				// 如果是释放场景，那么就会主动释放场景。
				if (isReleaseScene)
					releaseScene(zscene);
				else {
					switch (zscene.replaceMode) {
						case REMOVE_TO_STAGE:
							if (zscene.parent != null)
								zscene.parent.removeChild(zscene);
						case VISIBLE_SET_FALSE:
							zscene.visible = false;
					}
				}
			} else {
				GC.retain(zscene);
				function _eventComplete(_) {
					if (isReleaseScene)
						releaseScene(zscene);
					else
						switch (zscene.replaceMode) {
							case REMOVE_TO_STAGE:
								if (zscene.parent != null)
									zscene.parent.removeChild(zscene);
							case VISIBLE_SET_FALSE:
								zscene.visible = false;
						}
					GC.release(zscene);
					newscene.removeEventListener(Event.COMPLETE, _eventComplete);
				}
				newscene.addEventListener(Event.COMPLETE, _eventComplete);
			}
		}
		#if debug
		trace("replaceScene addChild:", cName);
		#end
		if (newscene.parent == null)
			Start.current.addChild(newscene);
		else
			newscene.visible = true;
		#if performance_analysis
		// 切换场景时更新一下
		PerformanceAnalysis.log();
		#end
		onReplaceScene();
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
		if (c != null) {
			return this.replaceScene(c, isReleaseScene, true);
		}
		return null;
	}

	/**
	 * 当发生更换场景事件时
	 */
	dynamic public function onReplaceScene() {}

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
	 * @param cName - 
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
