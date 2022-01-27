package zygame.utils.load;

import openfl.display.Tileset;
import openfl.display.BitmapData;
// import openfl.Assets;
import zygame.utils.AssetsUtils in Assets;
import spine.SkeletonJson;
import spine.attachments.AtlasAttachmentLoader;
import spine.support.graphics.TextureAtlas;
import spine.SkeletonData;
import spine.SkeletonDataFileHandle;
import zygame.utils.StringUtils;

/**
 * SpineTextureAtalsLoader加载器
 */
class SpineTextureAtalsLoader {
	private var _texPath:Array<String>;
	private var _texs:Map<String, BitmapData>;
	private var _texJson:String;
	private var _errorCall:String->Void;
	private var _call:SpineTextureAtals->Void;

	public var path:String;

	/**
	 * Spine的资源管理器
	 * @param textjson 该参数允许是多个路径进行加载（数组）
	 * @param texpath
	 */
	public function new(textjson:String, texpath:Array<String>) {
		_texPath = texpath;
		_texJson = textjson;
		path = textjson;
	}

	/**
	 * 载入Spine纹理集合
	 * @param call
	 */
	public function load(call:SpineTextureAtals->Void, errorCall:String->Void) {
		_errorCall = errorCall;
		_call = call;
		_texs = new Map<String, BitmapData>();
		// 多纹理加载
		next();
	}

	public function next():Void {
		if (_texPath.length > 0) {
			var path:String = _texPath.shift();
			Assets.loadBitmapData(path, false).onComplete(function(bitmapData:BitmapData):Void {
				_texs.set(StringUtils.getName(path), bitmapData);
				next();
			}).onError(_errorCall);
		} else {
			Assets.loadText(_texJson).onComplete(function(data:String):Void {
				var spine:SpineTextureAtals = new SpineTextureAtals(_texs, data);
				spine.path = path;
				_call(spine);
			}).onError(_errorCall);
		}
	}
}

/**
 * SpineTextureAtalsLoader加载器
 */
class Base64SpineTextureAtalsLoader extends SpineTextureAtalsLoader {
    private var _base64texpath:Array<{path:String, base64data:String}>;

	/**
	 * Spine的资源管理器
	 * @param textjson 该参数允许是多个路径进行加载（数组）
	 * @param texpath
	 */
	public function new(textjson:String, texpath:Array<{path:String, base64data:String}>, path:String) {
        super(path, []);
        this._texJson = textjson;
		this._base64texpath = texpath;
	}

	override public function next():Void {
		if (_base64texpath.length > 0) {
			var data = _base64texpath.shift();
			BitmapData.loadFromBase64(data.base64data, "image/png").onComplete(function(bitmapData) {
				_texs.set(StringUtils.getName(data.path), bitmapData);
				next();
			}).onError(_errorCall);
		} else {
			var spine:SpineTextureAtals = new SpineTextureAtals(_texs, _texJson);
			spine.path = path;
			_call(spine);
		}
	}
}

/**
 * Spine纹理集
 */
class SpineTextureAtals extends Atlas {
	private var _tilemapSkeletonManager:SkeletonJson;
	private var _spriteSkeletonManager:SkeletonJson;

	private var _bitmapDatas:Map<String, BitmapData>;

	private var _data:String;

	private var _skeletonData:Map<String, SkeletonData>;

	public var path:String = null;

	public var id:String = null;

	public var loader:spine.tilemap.BitmapDataTextureLoader;

	public function new(maps:Map<String, BitmapData>, data:String):Void {
		_bitmapDatas = maps;
		_data = data;
		_skeletonData = new Map<String, SkeletonData>();
	}

	/**
	 * 获取Tilemap骨骼管理器
	 * @return SkeletonJson
	 */
	public function getTilemapSkeletonManager():SkeletonJson {
		if (_tilemapSkeletonManager == null) {
			loader = new spine.tilemap.BitmapDataTextureLoader(_bitmapDatas);
			var atlas:TextureAtlas = new TextureAtlas(_data, loader);
			_tilemapSkeletonManager = new SkeletonJson(new AtlasAttachmentLoader(atlas));
		}
		return _tilemapSkeletonManager;
	}

	/**
	 * 获取Sprite骨骼管理器
	 * @return SkeletonJson
	 */
	public function getSpriteSkeletonManager():SkeletonJson {
		if (_spriteSkeletonManager == null) {
			var loader:spine.openfl.BitmapDataTextureLoader = new spine.openfl.BitmapDataTextureLoader(_bitmapDatas);
			var atlas:TextureAtlas = new TextureAtlas(_data, loader);
			_spriteSkeletonManager = new SkeletonJson(new AtlasAttachmentLoader(atlas));
		}
		return _spriteSkeletonManager;
	}

	/**
	 * 生成龙骨数据
	 * @param json
	 * @return SkeletonData
	 */
	public function buildSpriteSkeletonData(id:String, data:String):SkeletonData {
		if (_skeletonData.exists(id)) {
			return _skeletonData.get(id);
		}
		var skeletonData:SkeletonData = getSpriteSkeletonManager().readSkeletonData(new SkeletonDataFileHandle(null, data));
		_skeletonData.set(id, skeletonData);
		return skeletonData;
	}

	/**
	 * 生成Tilemap数据
	 * @param id
	 * @param data
	 * @return SkeletonData
	 */
	public function buildTilemapSkeletonData(id:String, data:String):SkeletonData {
		if (_skeletonData.exists(id)) {
			return _skeletonData.get(id);
		}
		var skeletonData:SkeletonData = getTilemapSkeletonManager().readSkeletonData(new SkeletonDataFileHandle(null, data));
		_skeletonData.set(id, skeletonData);
		return skeletonData;
	}

	/**
	 * 获取
	 * @param data
	 * @return Int
	 */
	public function getSkeletonDataID(data:SkeletonData):String {
		var datas:Iterator<String> = _skeletonData.keys();
		while (datas.hasNext()) {
			var key:String = datas.next();
			var skeletonData:SkeletonData = _skeletonData.get(key);
			if (skeletonData == data)
				return key;
		}
		return null;
	}

	/**
	 * 生成Tilemap使用的骨骼动画
	 * @return spine.tilemap.SkeletonAnimation
	 */
	public function buildTilemapSkeleton(id:String, data:String):spine.tilemap.SkeletonAnimation {
		var skeletonData:SkeletonData = buildTilemapSkeletonData(id, data);
		var skeleton:spine.tilemap.SkeletonAnimation = new spine.tilemap.SkeletonAnimation(skeletonData);
		skeleton.assetsId = this.id + ":" + id;
		return skeleton;
	}

	/**
	 * 生成Tilemap使用的骨骼动画
	 * @return spine.openfl.SkeletonAnimation
	 */
	public function buildSpriteSkeleton(id:String, data:String):spine.openfl.SkeletonAnimation {
		var skeletonData:SkeletonData = buildSpriteSkeletonData(id, data);
		var skeleton:spine.openfl.SkeletonAnimation = new spine.openfl.SkeletonAnimation(skeletonData);
		skeleton.assetsId = this.id + ":" + id;
		return skeleton;
	}

	/**
	 * 卸载
	 */
	public function dispose():Void {
		var keys:Iterator<String> = this._bitmapDatas.keys();
		for (key in keys) {
			ZGC.disposeBitmapData(this._bitmapDatas.get(key));
			this._bitmapDatas.remove(key);
		}
		var datas:Iterator<String> = this._skeletonData.keys();
		for (key in datas) {
			this._skeletonData.remove(key);
		}
		this._skeletonData = null;
		this._bitmapDatas = null;
	}

	/**
	 * 获取位图帧数据
	 * @param name
	 * @return Frame
	 */
	public function getBitmapDataFrame(name:String):Frame {
		if (loader == null)
			getTilemapSkeletonManager();
		return loader.frameMaps.get(name);
	}

	override function getTileset():Tileset {
		if (loader == null)
			getTilemapSkeletonManager();
		return loader.getTileset();
	}
}
