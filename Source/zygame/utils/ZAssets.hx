package zygame.utils;

#if zygame3d
import zygame.utils.load.Loader3DData.ZLoader3D;
#end
import zygame.loader.parser.Loader3DParser;
import zygame.loader.parser.AssetsType;
import zygame.loader.parser.MP3Parser;
import zygame.loader.parser.MapliveParser;
import zygame.loader.parser.FntParser;
import zygame.loader.parser.SpineParser;
import zygame.loader.parser.TextureAtlasParser;
import zygame.loader.parser.ZIPAssetsParser;
import zygame.loader.parser.DynamicTextureAtlasParser;
import zygame.loader.parser.SWFParser;
import zygame.loader.LoaderAssets;
import zygame.loader.parser.ParserBase;
#if cmnt
import zygame.cmnt.GameUtils;
#end
import zygame.utils.load.DynamicTextureLoader;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.FntLoader;
import zygame.utils.StringUtils;
import openfl.utils.Dictionary;
import openfl.display.BitmapData;
import zygame.utils.load.Frame;
import zygame.utils.load.MapliveLoader;
import zygame.components.base.ZConfig;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;
import zygame.utils.load.Music;
import zygame.utils.load.CDBLoader;
import zygame.utils.load.SpineTextureAtalsLoader;
import zygame.utils.load.SWFLiteLibrary;
import openfl.display.MovieClip;
import zygame.components.base.ZCacheTextField;
import zygame.utils.load.AssetsZipLoader;
import zygame.media.SoundChannelManager;
import haxe.macro.Compiler;

/**
 *  资源管理器，基于openfl.Assets的实现
 */
@:keep
class ZAssets {
	/**
	 * 最大可同时加载数量
	 */
	public var maxLoadNumber:Int = #if MAX_LOAD_COUNT Std.parseInt(Compiler.getDefine("MAX_LOAD_COUNT")) #elseif ios 10 #else 5 #end;

	/**
	 * 当前正在加载的数量
	 */
	private var currentLoadNumber:Int = 0;

	/**
	 * 正在载入的索引
	 */
	private var currentLoadIndex:Int = 0;

	/**
	 * 当前已载入成功的数量
	 */
	private var currentLoadedCount:Int = 0;

	/**
	 * 扩展格式解析器，例如命名为data，实际为xml时，则可以设置扩展命名映射
	 * extPasrer.set("data","xml");
	 */
	public var extPasrer:Map<String, String> = new Map();

	/**
	 * 解析器资源载入
	 */
	private var _parsers:Array<ParserBase> = [];

	/**
	 * 解析器载入中对象
	 */
	private var _loadingParsers:Array<ParserBase> = [];

	/**
	 * File载入列表，用于解决重复载入判断，会在调用start/释放的时候清空
	 */
	private var _loadfilelist:Array<String> = [];

	/**
	 * 载入停止
	 */
	private var _loadStop:Bool = false;

	private var _callBack:Float->Void;
	private var _errorCallBack:String->Void;

	private var _bitmaps:Dictionary<String, BitmapData>;
	private var _jsons:Dictionary<String, Dynamic>;
	private var _xmls:Dictionary<String, Xml>;
	private var _textures:Dictionary<String, TextureAtlas>;
	private var _sounds:Dictionary<String, Sound>;
	private var _musics:Dictionary<String, Music>;
	private var _fnts:Dictionary<String, FntData>;
	private var _maps:Dictionary<String, MapliveData>;
	private var _spines:Dictionary<String, SpineTextureAtals>;
	#if (openfl < '9.0.0')
	private var _swflites:Dictionary<String, SWFLiteLibrary>;
	#end
	private var _zips:Dictionary<String, Zip>;
	private var _cdbs:Dictionary<String, CDBData>;
	private var _textcache:Dictionary<String, ZCacheTextField>;
	private var _strings:Dictionary<String, String>;
	private var _3ds:Dictionary<String, #if zygame3d zygame.utils.load.Loader3DData.ZLoader3D #else Dynamic #end>;
	private var _dynamicAtlas:Dictionary<String, DynamicTextureAtlas>;
	private var _3dprticle:Dictionary<String, Dynamic>;

	/**
	 * 当前播放的背景音乐
	 */
	private var _bgid:String;

	public function new() {
		_sounds = new Dictionary<String, Sound>();
		_bitmaps = new Dictionary<String, BitmapData>();
		_jsons = new Dictionary<String, Dynamic>();
		_xmls = new Dictionary<String, Xml>();
		_textures = new Dictionary<String, TextureAtlas>();
		_musics = new Dictionary<String, Music>();
		_fnts = new Dictionary<String, FntData>();
		_maps = new Dictionary<String, MapliveData>();
		_spines = new Dictionary<String, SpineTextureAtals>();
		#if (openfl < '9.0.0')
		_swflites = new Dictionary<String, SWFLiteLibrary>();
		#end
		_zips = new Dictionary<String, Zip>();
		_cdbs = new Dictionary<String, CDBData>();
		_strings = new Dictionary<String, String>();
		_textcache = new Dictionary();
		_3ds = new Dictionary();
		_dynamicAtlas = new Dictionary();
		_3dprticle = new Dictionary();
	}

	/**
	 * 加载3D文件
	 * @param path 3D文件
	 * @param contextFiles 该3D文件关联的文件，如动画文件。
	 */
	public function load3DFile(path:String):Void {
		_parsers.push(new Loader3DParser(path));
	}

	/**
	 *  载入资源列表
	 *  @param arr -
	 */
	public function loadFiles(arr:Array<String>):Void {
		for (i in 0...arr.length) {
			loadFile(arr[i]);
		}
	}

	/**
	 *  载入单个文件
	 *  @param path -
	 */
	public function loadFile(data:Dynamic):Void {
		if (Std.is(data, ParserBase)) {
			_parsers.push(data);
			return;
		}
		if (Std.is(data, String) && _loadfilelist.indexOf(data) == -1) {
			// 检查该path可载入的支持
			for (base in LoaderAssets.fileparser) {
				var cheakpath:String = data;
				var ext:String = StringUtils.getExtType(cheakpath);
				if (extPasrer.exists(ext)) {
					ext = extPasrer.get(ext);
					cheakpath = cheakpath.substr(0, cheakpath.lastIndexOf(".")) + "." + ext;
				}
				var bool = Reflect.callMethod(base, Reflect.field(base, "supportType"), [cheakpath]);
				if (bool) {
					_parsers.push(Type.createInstance(base, [data]));
					_loadfilelist.push(data);
					return;
				}
			}
			throw "数据格式[" + data + "]无法载入";
		}
	}

	/**
	 * 加载SWFLite压缩文件
	 * @param path 加载路径
	 * @param isZip 是否为压缩包，默认为压缩包
	 */
	public function loadSwfliteFile(path:String, isZip:Bool = true):Void {
		#if (openfl >= '9.0.0')
		throw "OpenFL9 not support SWF file.";
		#else
		_parsers.push(new SWFParser({
			path: path,
			zip: isZip
		}));
		#end
	}

	/**
	 * 加载动态纹理图
	 * @param atlasName
	 * @param path
	 */
	public function loadDynamicTextureAtlasImage(atlasName:String, path:String):Void {
		for (loader in _parsers) {
			if (Std.is(loader, DynamicTextureAtlasParser) && cast(loader, DynamicTextureAtlasParser).getName() == atlasName) {
				cast(loader, DynamicTextureAtlasParser).loader.loadFile(path);
				return;
			}
		}
		var atlasLoader = new DynamicTextureAtlasParser(atlasName);
		atlasLoader.loader.loadFile(path);
		_parsers.push(atlasLoader);
	}

	/**
	 * 加载Zip资源包
	 * @param path
	 */
	public function loadAssetsZip(path:String):Void {
		_parsers.push(new ZIPAssetsParser(path));
		// if (ZIPAssetsParser.supportType(path)) {
		// } else
		// 	throw "提供的" + path + "是无效的zip扩展文件";
	}

	/**
	 * 卸载对应的压缩文件
	 * @param id
	 */
	public function unloadAssetsZip(id:String):Void {
		if (_zips.exists(id)) {
			_zips.get(id).unload();
			_zips.remove(id);
		}
	}

	/**
	 *  载入纹理资源
	 *  @param img 如果只传递图片，xml会直接识别图片资源
	 *  @param xml -
	 */
	public function loadTextures(img:String, xml:String = null, isAtf:Bool = false):Void {
		var _xml = xml != xml ? xml : img.substr(0, img.lastIndexOf(".")) + ".xml";
		_parsers.push(new TextureAtlasParser({
			imgpath: img,
			xmlpath: _xml,
			path: _xml,
			atf: isAtf
		}));
	}

	/**
	 * 以Base64格式加载资源
	 * @param imgBase64 图片base64格式数据
	 * @param xmlString xml字符串数据
	 * @param filename 储存到assets中的映射名
	 * @param isAtf
	 */
	public function loadBase64Textures(imgBase64:String, xmlString:String, filename:String, isAtf:Bool):Void {
		_parsers.push(new TextureAtlasParser({
			imgpath: imgBase64,
			xmlpath: xmlString,
			path: filename,
			atf: isAtf
		}));
	}

	/**
	 * 加载Spine纹理集资源
	 * @param texPath
	 * @param texJsonPath 该参数可以传入数组，支持多纹理加载
	 */
	public function loadSpineTextAlats(texPaths:Array<String>, texJsonPath:String):Void {
		_parsers.push(new SpineParser({
			imgs: texPaths,
			atlas: texJsonPath,
			path: texJsonPath,
			base64: false
		}));
	}

	/**
	 * 加载Base64Spine纹理集资源
	 * @param texPaths 需要提供路径/base64数据，支持多纹理
	 * @param jsonData 纹理json数据
	 * @param texJsonPath 纹理json路径
	 */
	public function loadBase64SpineTextAlats(texPaths:Array<{path:String, base64data:String}>, jsonData:String, texJsonPath:String):Void {
		_parsers.push(new SpineParser({
			imgs: texPaths,
			atlas: jsonData,
			path: texJsonPath,
			base64: true
		}));
	}

	/**
	 * 载入位图字体
	 * @param pngPath
	 * @param xmlPath
	 */
	public function loadFnt(pngPath:String, xmlPath:String):Void {
		_parsers.push(new FntParser({
			imgpath: pngPath,
			fntpath: xmlPath,
			path: xmlPath
		}));
	}

	/**
	 * 载入Maplive2格式数据资源
	 * @param bundlePath
	 */
	public function loadMapliveData(bundlePath:String):Void {
		_parsers.push(new MapliveParser(bundlePath));
	}

	/**
	 * 加载音乐
	 * @param path
	 */
	public function loadMusic(path:String):Void {
		_parsers.push(new MP3Parser({
			type: "Music",
			path: path
		}));
	}

	public function getNowLoadCount():Int {
		return _parsers.length;
	}

	public var canError:Bool = false;

	/**
	 *  开始加载
	 *  @param func - 加载进度回调
	 *  @param errorCall - 错误回调
	 *  @param canError - 是否允许容错加载，如果设置为true，则永远不会触发errorCall
	 */
	public function start(func:Float->Void, errorCall:String->Void = null, canError:Bool = false):Void {
		this.canError = canError;
		_errorCallBack = errorCall;
		_callBack = func;
		_loadStop = false;
		this.currentLoadedCount = 0;
		this.currentLoadIndex = 0;
		// 加载循序排序，优先加载zip资源
		_parsers.sort((a, b) -> Std.is(a, ZIPAssetsParser) ? -1 : 0);
		#if debug
		trace("PARSER LOAD START:", _parsers);
		#end
		this.loadNext();
	}

	/**
	 * 开始载入下一个资源
	 */
	private function loadNext():Void {
		if (_parsers.length <= currentLoadIndex || _loadStop) {
			// 检查是否已载入完毕
			var curprogress = getProgress();
			if (curprogress == 1) {
				this._parsers = [];
				this._loadfilelist = [];
				#if debug
				trace("载入进度：" + Std.int(curprogress * 100) + "%");
				#end
				_callBack(curprogress);
			}
			return;
		}
		var parser = _parsers[currentLoadIndex];
		currentLoadIndex++;
		currentLoadNumber++;
		if (parser == null) {
			loadNext();
			return;
		}
		trace("载入进度：" + currentLoadIndex, parser, _parsers.length, parser.getName());
		parser.out = onAssetsOut;
		parser.done = loadDone;
		parser.error = loadError;
		_loadingParsers.push(parser);
		parser.load(this);
		// 如果是ZIP资源，需要等待ZIP载入完毕后，再载入其他资源
		if (Std.is(parser, ZIPAssetsParser)) {
			return;
		}
		if (maxLoadNumber > currentLoadNumber) {
			loadNext();
		}
	}

	private function loadError(msg:String):Void {
		trace("载入发生异常，错误：" + msg);
		if (canError) {
			loadDone();
		} else {
			#if cmnt
			// TODO 回调错误
			GameUtils.reportErrorLog("加载API", "加载失败：" + msg, "无", "API", ErrorLogLevel.ERROR);
			#end
			_loadStop = true;
			_parsers = [];
			_loadfilelist = [];
			currentLoadNumber = 0;
			if (_errorCallBack != null) {
				_callBack = null;
				_errorCallBack(msg);
				_errorCallBack = null;
			}
		}
	}

	/**
	 * 当加载完毕后统一处理
	 */
	private function loadDone():Void {
		this.currentLoadNumber--;
		this.currentLoadedCount++;
		loadNext();
	}

	/**
	 * 当前资源器的载入进度(精细化)
	 * @return Float
	 */
	public function getProgress():Float {
		var progress:Float = 0;
		for (base in _loadingParsers) {
			progress += base.progress;
		}
		if (progress > 0 && _loadingParsers.length > 0) {
			progress /= _loadingParsers.length;
			progress = _loadingParsers.length / getNowLoadCount() * progress;
		}
		return this.currentLoadedCount / getNowLoadCount() + progress;
	}

	/**
	 * 创建3D容器
	 * @param name
	 * @return #if zygame3d away3d.entities.ParticleGroup #else Dynamic #end
	 */
	public function create3DParticleGroup(name:String):#if zygame3d away3d.entities.ParticleGroup #else Dynamic #end {
		#if zygame3d
		return cast cast(_3dprticle.get(name), away3d.entities.ParticleGroup).clone();
		#else
		return null;
		#end
	}

	public function setMusic(id:String, data:Music):Void {
		_musics.set(id, data);
	}

	/**
	 * 资源输出
	 * @param assets
	 * @param data
	 * @param pro
	 */
	private function onAssetsOut(parser:ParserBase, type:AssetsType, data:Dynamic, pro:Float):Void {
		if (pro == 1) {
			_loadingParsers.remove(parser);
		}
		// 资源分析
		var t:Int = type;
		switch (t) {
			case SPARTICLE:
				// 3D粒子特效
				_3dprticle.set(parser.getName(), data);
			case SPINE:
				_spines.set(parser.getName(), data);
				data.id = parser.getName();
			case ZIP:
				this._zips.set(parser.getName(), data);
			case DYNAMICTEXTUREATLAS:
				this._dynamicAtlas.set(parser.getName(), data);
			case SWF:
				#if (openfl < '9.0.0')
				this._swflites.set(parser.getName(), data);
				#end
			case MAPLIVE:
				_maps.set(parser.getName(), data);
			case FNT:
				_fnts.set(parser.getName(), data);
			case MUSIC:
				_musics.set(parser.getName(), data);
			case SOUND:
				_sounds.set(parser.getName(), data);
			case TEXTUREATLAS:
				var pname:String = parser.getName();
				var textures:TextureAtlas = getTextureAtlas(pname);
				if (textures != null)
					textures.dispose();
				_textures.set(pname, data);
			case BITMAP:
				var pname:String = parser.getName();
				if (_bitmaps.exists(pname))
					getBitmapData(pname).dispose();
				_bitmaps.set(pname, data);
			case TEXT:
				_strings.set(parser.getName(), data);
			case XML:
				_xmls.set(parser.getName(), data);
			case JSON:
				_jsons.set(parser.getName(), data);
			case CDB:
				_cdbs.set(parser.getName(), data);
			case OBJ3D:
				#if zygame3d
				var pname:String = parser.getName();
				if (pname.indexOf("_") != -1)
					pname = pname.split("_")[0];
				if (_3ds.exists(pname)) {
					if (_3ds.get(pname).numChildren == 0) {
						var cur3ds = _3ds.get(pname);
						_3ds.set(pname, data);
						_3ds.get(pname).pushZLoader3D(cur3ds);
					} else
						_3ds.get(pname).pushZLoader3D(data);
				} else
					_3ds.set(pname, data);
				#end
		}
		// 进度反馈
		if (_callBack != null)
			_callBack(getProgress());
		#if debug
		trace("载入进度：" + Std.int(getProgress() * 100) + "%");
		#end
	}

	/**
	 * 获取Zip数据包
	 * @param id
	 * @return Zip
	 */
	public function getZip(id:String):Zip {
		return _zips.get(id);
	}

	/**
	 * 获取动态纹理集合
	 * @param id
	 * @return DynamicTextureAtlas
	 */
	public function getDynamicTextureAtlas(id:String):DynamicTextureAtlas {
		return _dynamicAtlas.get(id);
	}

	/**
	 * 检查压缩包中是否含有对应的文件
	 * @param id
	 * @param type
	 */
	public function existZipAssets(id:String, type:String):Bool {
		for (zip in _zips) {
			if (_zips.get(zip).exist(id + "." + type))
				return true;
		}
		return false;
	}

	/**
	 * 获取纹理集
	 * @param atalsName
	 * @return SpineTextureAtals
	 */
	public function getSpineTextureAlats(atalsName:String):SpineTextureAtals {
		return _spines.get(atalsName);
	}

	/**
	 * 获取SkeletonData
	 * @param atlasAndJson 纹理名:JSON名
	 * @return spine.SkeletonData
	 */
	public function getSpineSpriteSkeletonData(atlasAndJson:String):spine.SkeletonData {
		var names:Array<String> = atlasAndJson.split(":");
		if (getSpineTextureAlats(names[0]) == null)
			return null;
		return getSpineTextureAlats(names[0]).buildSpriteSkeletonData(names[1], haxe.Json.stringify(getObject(names[1])));
	}

	/**
	 * 获取SkeletonData(Tilemap)
	 * @param atlasAndJson 纹理名:JSON名
	 * @return spine.SkeletonData
	 */
	public function getSpineTilemapSkeletonData(atlasAndJson:String):spine.SkeletonData {
		var names:Array<String> = atlasAndJson.split(":");
		return getSpineTextureAlats(names[0]).buildTilemapSkeletonData(names[1], haxe.Json.stringify(getObject(names[1])));
	}

	/**
	 * 创建Sprite渲染器的Spine骨骼
	 * @param atalsName
	 * @param skeletonJsonName
	 * @return spine.openfl.SkeletonAnimation
	 */
	public function createSpineSpriteSkeleton(atalsName:String, skeletonJsonName:String):spine.openfl.SkeletonAnimation {
		return _spines.get(atalsName).buildSpriteSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectData(this.getObject(skeletonJsonName)));
	}

	/**
	 * 创建Tilemap渲染器的Spine骨骼
	 * @param atalsName
	 * @param skeletonJsonName
	 * @return spine.tilemap.SkeletonAnimation
	 */
	public function createSpineTilemapSkeleton(atalsName:String, skeletonJsonName:String):spine.tilemap.SkeletonAnimation {
		return _spines.get(atalsName)
			.buildTilemapSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectData(this.getObject(skeletonJsonName)));
	}

	/**
	 * 获取MovieClip对象，SWF名:SWF映射
	 * @param id
	 * @return MovieClip
	 */
	public function getMovieClip(id:String):MovieClip {
		#if (openfl >= '9.0.0')
		return null;
		#else
		var arr:Array<String> = id.split(":");
		var swf:SWFLiteLibrary = this._swflites.get(arr[0]);
		return swf.getMovieClip(arr[1]);
		#end
	}

	/**
	 * 卸载指定的Swflite对象
	 * @param id
	 */
	public function unloadSwfliteFile(id:String):Void {
		#if (openfl < '9.0.0')
		if (this._swflites.exists(id)) {
			this._swflites.get(id).unload();
			this._swflites.remove(id);
		}
		#end
	}

	/**
	 * 用于重写解析路径名称
	 * @param path
	 * @return String
	 */
	dynamic public function onPasingPathName(path:String):String {
		return StringUtils.getName(path);
	}

	/**
	 * 设置音频对象
	 * @param id
	 * @param sound
	 */
	public function setSound(id:String, sound:Sound):Void {
		_sounds.set(id, sound);
	}

	/**
	 * 加载Zip格式的精灵表
	 * @param call
	 */
	private function loadZipTextureAtlas(id:String, call:TextureAtlas->Void):Void {
		if (_textures.exists(id)) {
			call(getTextureAtlas(id));
			return;
		}
		for (zip in _zips) {
			if (_zips.get(zip).exist(id + ".png") && _zips.get(zip).exist(id + ".xml")) {
				_zips.get(zip).loadBitmapData(id, function(bitmapData:BitmapData):Void {
					var xml:Xml = getZipXml(id);
					var textureAtlas:TextureAtlas = new TextureAtlas(bitmapData, xml);
					call(textureAtlas);
				});
				break;
			}
		}
	};

	/**
	 *  获取纹理集合
	 *  @param id -
	 *  @return TextureAtlas
	 */
	public function getTextureAtlas(id:String):TextureAtlas {
		return _textures.get(id);
	}

	/**
	 *  追加纹理集合
	 *  @param id -
	 *  @param textureAtlas -
	 */
	public function putTextureAtlas(id:String, textureAtlas:TextureAtlas):Void {
		_textures.set(id, textureAtlas);
	}

	/**
	 *  获取位图数据
	 *  @param id -
	 *  @return BitmapData 这里获取的精灵表中的位图数据，将会是BitmapDataFrame对象。
	 */
	public function getBitmapData(id:String, foundAtlas:Bool = false):Dynamic {
		if (id.indexOf(":") == -1) {
			// 位图从ZIP资源包中读取
			if (_bitmaps.exists(id))
				return _bitmaps.get(id);
			else if (foundAtlas) {
				// 在图集中查找
				for (key => atlas in _textures) {
					var data = atlas.getBitmapDataFrame(id);
					if (data != null)
						return data;
				}
				// 在Spine图集中查找
				for (key => value in _spines) {
					var data = value.getBitmapDataFrame(id);
					if (data != null)
						return data;
				}
				return null;
			} else
				return null;
		} else {
			var data = getBitmapDataFrame(id);
			return data;
		}
	}

	/**
	 * 获取3DMesh对象
	 * @param id
	 * @return away3d.entities.Mesh
	 */
	public function get3DMesh(id:String):#if zygame3d away3d.entities.Mesh #else Dynamic #end
	{
		var arr:Array<String> = id.split(":");
		if (arr.length != 2) {
			_3ds.get(arr[0]).getMesh();
		}
		return _3ds.get(arr[0]).getMesh(arr[1]);
	}

	/**
	 * 根据ID获取3D的加载数据
	 * @return ZLoader3D
	 */
	public function getZLoader3D(id:String):#if zygame3d zygame.utils.load.Loader3DData.ZLoader3D #else Dynamic #end
	{
		return _3ds.get(id);
	}

	/**
	 * 设置ZLoader3D对象
	 * @param id 
	 * @param loader 
	 */
	public function setZLoader3D(id:String, loader:#if zygame3d ZLoader3D #else Dynamic #end):Void {
		_3ds.set(id, loader);
	}

	/**
	 * 创建Mesh副本
	 * @param id 
	 * @return #if zygame3d away3d.entities.Mesh #else Dynamic #end
	 */
	public function buildMesh3D(id:String):#if zygame3d away3d.entities.Mesh #else Dynamic #end
	{
		return get3DMesh(id).clone();
	}

	/**
	 * 创建3D对象
	 * @param id
	 */
	public function buildObject3D(id:String):#if zygame3d zygame.display3d.ZObject3D #else Dynamic #end
	{
		#if zygame3d
		return new zygame.display3d.ZObject3D(getZLoader3D(id));
		#else
		return null;
		#end
	}

	/**
	 * 手动设置位图
	 * @param id
	 * @param bitmapData
	 */
	public function setBitmapData(id:String, bitmapData:BitmapData):Void {
		// 存入新图时，旧图会被释放！
		if (_bitmaps.exists(id))
			zygame.utils.ZGC.disposeBitmapData(_bitmaps.get(id));
		_bitmaps.set(id, bitmapData);
	}

	/**
	 * 加载压缩文件中的位图
	 * @param id
	 * @return BitmapData
	 */
	private function loadZipBitmapData(id:String, call:BitmapData->Void = null):Void {
		for (zip in _zips) {
			if (_zips.get(zip).exist(id + ".png") || _zips.get(zip).exist(id + ".jpg")) {
				_zips.get(zip).loadBitmapData(id, call);
				break;
			}
		}
	}

	/**
	 * 缓存文本
	 * @param id 缓存ID，通过getTextAtlas获取精灵表时使用的ID标记
	 * @param text 需要缓存的文字
	 * @param fontName 缓存字体
	 * @param size 缓存文字大小
	 * @param color 缓存的颜色
	 * @param autoWarp 是否自动换行，这将会减少约1半的可用字的数量，HTML5无效化不可用（HTML5平台采取了更优的方案进行渲染）
	 */
	public function cacheText(id:String, text:String, fontName:String, size:UInt, color:UInt = 0xffffff, autoWarp:Bool = false):Void {
		#if bili
		autoWarp = false;
		#else
		autoWarp = true;
		#end
		if (fontName == null)
			fontName = ZConfig.fontName;
		var t:ZCacheTextField = _textcache.get(id);
		if (t == null) {
			trace("cacheText id(" + id + ")无纹理对象");
			t = new ZCacheTextField(id, fontName, size, color);
			// 是否自动换行
			t.cacheAutoWrap = autoWarp;
			t.text = text;
			_textcache.set(id, t);
		} else {
			// 是否自动换行
			trace("cacheText id(" + id + ")已存在旧纹理对象");
			t.cacheAutoWrap = autoWarp;
			t.text = text;
		}
	}

	/**
	 * 获取文本精灵表
	 * @param id
	 * @return TextureAtlas
	 */
	public function getTextAtlas(id:String):TextureAtlas {
		if (_textcache.exists(id))
			return _textcache.get(id).getAtlas();
		return null;
	}

	/**
	 * 获取压缩文件中的位图
	 * @param id
	 * @return BitmapData
	 */
	private function getZipXml(id:String):Xml {
		for (zip in _zips) {
			var data:Xml = _zips.get(zip).getXml(id);
			if (data != null)
				return data;
		}
		return null;
	}

	/**
	 * 获取压缩文件中的位图
	 * @param id
	 * @return BitmapData
	 */
	private function getZipJson(id:String):Dynamic {
		for (zip in _zips) {
			var data:Dynamic = _zips.get(zip).getJson(id);
			if (data != null)
				return data;
		}
		return null;
	}

	/**
	 * 获取位图文本数据
	 * @param id
	 * @return FntData
	 */
	public function getFntData(id:String):FntData {
		return _fnts.get(id);
	}

	public function getBitmapDataFrame(id:String):Frame {
		if (id.indexOf(":") == -1)
			return null;
		else {
			var arr:Array<String> = id.split(":");
			if (!_textures.exists(arr[0])) {
				// 查找Spine
				if (!_spines.exists(arr[0])) {
					// 返回异步纹理
					if (!_dynamicAtlas.exists(arr[0]))
						return null;
					else
						return getDynamicTextureAtlas(arr[0]).getBitmapDataFrame(arr[1]);
				} else {
					return _spines.get(arr[0]).getBitmapDataFrame(arr[1]);
				}
			}
			return getTextureAtlas(arr[0]).getBitmapDataFrame(arr[1]);
		}
	}

	/**
	 * 获取音乐
	 * @param id
	 * @return Sound
	 */
	public function getSound(id:String):Sound {
		return _sounds.get(id);
	}

	/**
	 * 获取音乐
	 * @param id
	 * @return Music
	 */
	public function getMusic(id:String):Music {
		return _musics.get(id);
	}

	/**
	 * 获取MapliveData数据
	 * @param id
	 * @return MapliveData
	 */
	public function getMapliveData(id:String):MapliveData {
		return _maps.get(id);
	}

	/**
	 * 获取当前播放的ID
	 * @return String
	 */
	public function getCurrentBGMusicID():String {
		return _bgid;
	}

	/**
	 * 播放背景音乐
	 * @param id
	 */
	public function playBGMusic(id:String):Void {
		_bgid = id;
		var sound:Music = getMusic(id);
		trace("playBGMusic", sound);
		@:privateAccess SoundChannelManager.current().playMusic(sound);
	}

	/**
	 * 停止背景音乐
	 */
	public function stopBGMusic():Void {
		SoundChannelManager.current().stopMusic();
	}

	/**
	 * 播放音效，如果需要操作复杂的，可使用getSound()方法进行实现
	 * @param id
	 * @param loop
	 */
	public function playSound(id:String, loop:Int = 1):SoundChannel {
		var sound:Sound = getSound(id);
		return @:privateAccess SoundChannelManager.current().playEffect(sound, loop);
	}

	/**
	 *  获取Xml格式
	 *  @param id -
	 *  @return Xml
	 */
	public function getXml(id:String):Xml {
		if (!_xmls.exists(id)) {
			_xmls.set(id, getZipXml(id));
		}
		return _xmls.get(id);
	}

	/**
	 * 设置Xml格式对象
	 * @param id
	 * @param xml
	 */
	public function setXml(id:String, xml:Xml):Void {
		_xmls.set(id, xml);
	}

	/**
	 * 获取字符串
	 * @param id
	 * @return String
	 */
	public function getString(id:String):String {
		return _strings.get(id);
	}

	/**
	 * 获取CDB的数据
	 * @param id
	 * @return CDBData
	 */
	public function getCDBData(id:String):CDBData {
		return _cdbs.get(id);
	}

	/**
	 * 删除CDB的数据
	 * @param id
	 */
	public function removeCDBData(id:String):Void {
		_cdbs.remove(id);
	}

	/**
	 *  获取JSON对象
	 *  @param id -
	 *  @return Dynamic
	 */
	public function getObject(id:String):Dynamic {
		return _jsons.get(id);
	}

	/**
	 * 设置JSON对象
	 * @param id
	 * @param data
	 */
	public function setObject(id:String, data:Dynamic):Void {
		_jsons.set(id, data);
	}

	/**
	 * 卸载MapliveData的数据
	 * @param id
	 */
	public function removeMapliveData(id:String):Void {
		var mapliveData:MapliveData = getMapliveData(id);
		if (mapliveData != null) {
			mapliveData.unloadAll();
			_maps.remove(id);
		}
	}

	/**
	 * 卸载Fnt资源
	 * @param id
	 */
	public function removeFnt(id:String):Void {
		var fnt:FntData = _fnts.get(id);
		if (fnt != null) {
			fnt.dispose();
			_fnts.remove(id);
		}
	}

	/**
	 * 卸载SpineTextureAtlas资源
	 * @param id
	 */
	public function removeSpineTextureAtlas(id:String):Void {
		var pspinetextureatlas:SpineTextureAtals = getSpineTextureAlats(id);
		if (pspinetextureatlas != null) {
			pspinetextureatlas.dispose();
			_spines.remove(id);
		}
	}

	public function removeTextureAtlas(id:String):Void {
		var ptextureatlas:TextureAtlas = getTextureAtlas(id);
		if (ptextureatlas != null) {
			ptextureatlas.dispose();
			_textures.remove(id);
		}
	}

	/**
	 * 删除音乐
	 * @param id
	 */
	public function removeMusic(id:String):Void {
		var music:Music = _musics.get(id);
		if (music != null) {
			music.close();
			_musics.remove(id);
		}
	}

	/**
	 * 删除指定ID的音频数据
	 * @param id
	 */
	public function removeSound(id:String):Void {
		var sound:Sound = _sounds.get(id);
		if (sound != null) {
			sound.close();
			_sounds.remove(id);
		}
	}

	/**
	 * 删除指定ID的位图数据
	 * @param id
	 */
	public function removeBitmapData(id:String):Void {
		var bitmap:BitmapData = _bitmaps.get(id);
		if (bitmap != null) {
			ZGC.disposeBitmapData(bitmap);
			// bitmap.dispose();
			// bitmap.disposeImage();
			_bitmaps.remove(id);
		}
	}

	/**
	 * 卸载所有资源
	 */
	public function unloadAll():Void {
		for (s in _xmls) {
			_xmls.remove(s);
		}
		for (key in _bitmaps) {
			removeBitmapData(key);
		}
		for (key in _textures) {
			removeTextureAtlas(key);
		}
		for (key in _spines) {
			removeSpineTextureAtlas(key);
		}
		for (key in _sounds) {
			removeSound(key);
		}
		for (key in _musics) {
			removeMusic(key);
		}
		for (key in _textcache) {
			removeTextCache(key);
		}
		for (key in _zips) {
			unloadAssetsZip(key);
		}
		for (key in _cdbs) {
			removeCDBData(key);
		}
	}

	/**
	 * 删除指定的缓存对象
	 * @param id
	 */
	public function removeTextCache(id:String):Void {
		trace("cacheText id(" + id + ")移除纹理缓存");
		if (_textcache.exists(id)) {
			trace("cacheText id(" + id + ")移除成功");
			_textcache.get(id).dispose();
			_textcache.remove(id);
		}
	}

	public function toString():String {
		var load:String = "";
		for (key in _spines) {
			load += key + "\n";
		}
		for (key in _sounds) {
			load += key + "\n";
		}
		for (key in _bitmaps) {
			load += key + "\n";
		}
		for (key in _jsons) {
			load += key + "\n";
		}
		for (key in _xmls) {
			load += key + "\n";
		}
		for (key in _textures) {
			load += key + "\n";
		}
		for (key in _fnts) {
			load += key + "\n";
		}
		for (key in _musics) {
			load += key + "\n";
		}
		for (key in _maps) {
			load += key + "\n";
		}
		return load;
	}
}
