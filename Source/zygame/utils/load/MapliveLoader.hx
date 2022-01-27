package zygame.utils.load;

import zygame.utils.AssetsUtils in Assets;
import zygame.components.ZMapliveScene;
import openfl.display.BitmapData;
import spine.SkeletonData;
import zygame.utils.load.TextureLoader;

/**
 * Maplive2地图数据载入器
 */
class MapliveLoader {
	private var _url:String;

	/**
	 * 新增一个Maplive2的载入器
	 * @param url
	 */
	public function new(url:String):Void {
		_url = url;
	}

	/**
	 * 加载Maplive2地图数据
	 * @param call
	 */
	public function load(call:MapliveData->Void, onPro:Float->Void, onError:String->Void):Void {
		Assets.loadText(_url + "/main.json").onComplete(function(data:String):Void {
			var mapData:MapliveData = new MapliveData(data);
			mapData.rootPath = _url;
			mapData.load(function(bool:Bool):Void {
				if (bool) {
					call(mapData);
				} else {
					onError("Maplive map data load fail:" + _url);
				}
			}, onPro);
		}).onError(function(data:Dynamic):Void {
			onError("Path not load:" + _url);
		});
	}
}

/**
 * 场景加载器
 */
class MapliveSceneLoader {
	private var _url:String;

	private var _rootPath:String;

	public function new(path:String, rootPath:String):Void {
		_url = path;
		_rootPath = rootPath;
	}

	public function load(call:MapliveSceneData->Void, onPro:Float->Void = null):Void {
		Assets.loadText(_url).onComplete(function(data:String):Void {
			var mapData:MapliveSceneData = new MapliveSceneData(data);
			mapData.rootPath = _rootPath;
			mapData.load(function(bool:Bool):Void {
				if (bool) {
					call(mapData);
				} else {
					call(null);
				}
			}, onPro);
		});
	}
}

/**
 * Maplive2场景数据
 */
class MapliveSceneData {
	private var _data:Dynamic;

	public var mapliveData:MapliveData;

	public var curAssets:ZMaliveAssets;

	public var rootPath:String;

	public function new(data:String):Void {
		_data = haxe.Json.parse(data);
		curAssets = new ZMaliveAssets();
	}

	/**
	 * 进行加载，如果加载成功，将会返回true，否则为false
	 * @param call
	 */
	public function load(call:Bool->Void, onPro:Float->Void):Void {
		if (_data.files == null)
			call(true);
		else if (_data.files.length == 0)
			call(true);
		else {
			// 开始载入必须的资源
			LoaderUtils.loadAssets(curAssets, rootPath, _data.files);
			curAssets.start(function(f:Float):Void {
				if (onPro != null)
					onPro(f);
				if (f == 1)
					call(true);
			}, function(err) {
				call(false);
			});
		}
	}

	/**
	 * 获取纹理集
	 * @param id
	 * @return TextureAtlas
	 */
	public function getTextureAtlas(id:String):TextureAtlas {
		var atlas:TextureAtlas = curAssets.getTextureAtlas(id);
		if (atlas == null)
			atlas = mapliveData.curAssets.getTextureAtlas(id);
		return atlas;
	}

	/**
	 * 读取位图数据
	 * @param id
	 */
	public function getBitmapData(id:String):BitmapData {
		var bitmapData:BitmapData = curAssets.getBitmapData(id, true);
		if (bitmapData == null)
			bitmapData = mapliveData.curAssets.getBitmapData(id, true);
		return bitmapData;
	}

	public function getSpineSpriteData(id:String):SkeletonData {
		var data:SkeletonData = curAssets.getSpineSpriteSkeletonData(id);
		if (data == null)
			data = mapliveData.curAssets.getSpineSpriteSkeletonData(id);
		return data;
	}

	public function getSpineTilemapData(id:String):SkeletonData {
		var data:SkeletonData = curAssets.getSpineTilemapSkeletonData(id);
		if (data == null)
			data = mapliveData.curAssets.getSpineTilemapSkeletonData(id);
		return data;
	}

	/**
	 * 获取图层
	 * @return Array<Dynamic>
	 */
	public function getLayers():Array<Dynamic> {
		return _data.data.layers;
	}

	/**
	 * 获取场景的宽
	 * @return Float
	 */
	public function getWidth():Float {
		return _data.width;
	}

	/**
	 * 获取场景的高
	 * @return Float
	 */
	public function getHeight():Float {
		return _data.height;
	}

	public function getData():Dynamic {
		return _data;
	}

	public function getBindType():String {
		return _data.bindType;
	}

	/**
	 * 卸载场景数据
	 */
	public function unload():Void {
		mapliveData = null;
		_data = null;
		curAssets.unloadAll();
	}
}

/**
 * Maplive2地图数据
 */
class MapliveData {
	public var rootPath:String = null;

	public var curAssets:ZMaliveAssets;

	private var _data:Dynamic;

	private var _scenes:Map<String, MapliveSceneData>;

	/**
	 * 默认的场景类型
	 */
	public var defaultSceneClass:Class<Dynamic> = null;

	public function new(data:String):Void {
		_data = haxe.Json.parse(data);
		_scenes = new Map<String, MapliveSceneData>();
		curAssets = new ZMaliveAssets();
	}

	/**
	 * 进行加载，如果加载成功，将会返回true，否则为false
	 * @param call
	 */
	public function load(call:Bool->Void, onPro:Float->Void = null):Void {
		if (_data.files == null)
			call(true);
		else if (_data.files.length == 0)
			call(true);
		else {
			LoaderUtils.loadAssets(curAssets, rootPath, _data.files);
			curAssets.start(function(f:Float):Void {
				if (onPro != null)
					onPro(f);
				if (f == 1)
					call(true);
			});
		}
	}

	/**
	 * 集合名称
	 */
	public var name(get, never):String;

	private function get_name():String {
		return _data.name;
	}

	/**
	 * 加载场景资源，会自动进行缓存
	 * @param name 场景名
	 * @param call 加载完成的场景会进行返回
	 */
	public function loadScene(name:String, call:ZMapliveScene->Void, onPro:Float->Void = null):Void {
		var mapData:MapliveSceneData = _scenes.get(name);
		if (mapData != null) {
			call(new ZMapliveScene(mapData));
			return;
		}
		var path:String = rootPath + "/scenes/" + Reflect.getProperty(_data.scenes, name);
		var loader:MapliveSceneLoader = new MapliveSceneLoader(path, rootPath);
		var self:MapliveData = this;
		loader.load(function(data:MapliveSceneData):Void {
			zygame.utils.Log.log("scene data loaded!");
			data.mapliveData = self;
			_scenes.set(name, data);
			if (defaultSceneClass == null && data.getBindType() == null) {
				call(new ZMapliveScene(data));
			} else {
				#if maplive
				call(new ZMapliveScene(data));
				#else
				if (data.getBindType() == null)
					call(Type.createInstance(defaultSceneClass, [data]));
				else
					call(Type.createInstance(Type.resolveClass(data.getBindType()), [data]));
				#end
			}
		}, onPro);
	}

	public function getData():Dynamic {
		return _data;
	}

	/**
	 * 卸载场景
	 * @param id
	 */
	public function unloadScene(id:String):Void {
		var mapData:MapliveSceneData = _scenes.get(id);
		if (mapData != null) {
			mapData.unload();
			_scenes.remove(id);
		}
	}

	/**
	 * 卸载所有资源
	 */
	public function unloadAll():Void {
		curAssets.unloadAll();
		var key:Iterator<String> = _scenes.keys();
		while (key.hasNext()) {
			var k:String = key.next();
			_scenes.get(k).unload();
			_scenes.remove(k);
		}
	}
}

/**
 * 载入解析工具
 */
class LoaderUtils {
	/**
	 * 统一载入资源入口
	 * @param curAssets
	 * @param rootPath
	 * @param files
	 */
	public static function loadAssets(curAssets:ZAssets, rootPath:String, files:Array<String>):Void {
		// 开始载入必须的资源
		for (i in 0...files.length) {
			var path:String = files[i];
			if (path.indexOf("textureatlas:") == 0) {
				loadTextureAtlas(curAssets, rootPath, path);
			} else if (path.indexOf("spineatlas:") == 0) {
				loadSpineAtlas(curAssets, rootPath, path);
			} else
				curAssets.loadFile(rootPath + "/files/" + path);
		}
	}

	private static function loadTextureAtlas(curAssets:ZAssets, rootPath:String, path:String):Void {
		var name:String = path.substr(13);
		curAssets.loadTextures(rootPath + "/files/" + name + ".png", rootPath + "/files/" + name + ".xml");
	}

	private static function loadSpineAtlas(curAssets:ZAssets, rootPath:String, path:String):Void {
		var name:String = path.substr(11);
		curAssets.loadSpineTextAlats([rootPath + "/files/" + name + ".png"], rootPath + "/files/" + name + ".atlas");
	}
}

class ZMaliveAssets extends ZAssets {
	override function getBitmapData(id:String, foundAtlas:Bool = true):Dynamic {
		return super.getBitmapData(id, foundAtlas);
	}
}
