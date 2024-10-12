package zygame.utils;

import openfl.utils.ByteArray;
import haxe.Json;
import zygame.loader.parser.JSONTextureAtlas;
#if away3d
import away3d.textures.BitmapTexture;
#end
import openfl.events.TimerEvent;
import haxe.Timer;
import zygame.events.GlobalAssetsLoadEvent;
import openfl.events.EventDispatcher;
import zygame.loader.parser.AsepriteParser;
#if zygame3d
import zygame.utils.load.Loader3DData.ZLoader3D;
#end
import zygame.loader.parser.Loader3DParser;
import zygame.loader.parser.AssetsType;
import zygame.loader.parser.MP3Parser;
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
import zygame.components.base.ZConfig;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;
import zygame.utils.load.Music;
import zygame.utils.load.CDBLoader;
import zygame.utils.load.SpineTextureAtalsLoader;
#if (openfl_swf && swf)
import swf.exporters.animate.AnimateLibrary;
#end
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
	 * 全局事件侦听器，如果文件加载失败的统一入口
	 */
	public static var globalListener:EventDispatcher = new EventDispatcher();

	/**
	 * 可设置ZAssets的请求超时处理，默认为-1，-1为使用网络请求反馈，如果需要，则给timeout设置时间，单位为秒。
	**/
	public var timeout:Float = -1;

	/**
	 * 仅加载ASTC压缩纹理
	 */
	public var onlyASTCTexture:Bool = false;

	/**
	 * 最大可同时加载数量，改进默认最大载入数为20
	 */
	public var maxLoadNumber:Int = #if MAX_LOAD_COUNT Std.parseInt(Compiler.getDefine("MAX_LOAD_COUNT")) #elseif ios 20 #else 20 #end;

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
		最后响应时间
	**/
	private var _lastTime:Float = 0;

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
	private var _loadStop:Bool = true;

	private var _callBack:Float->Void;
	private var _errorCallBack:String->Void;

	/**
	 * 二进制数据
	 */
	private var _bytes:Dictionary<String, ByteArray>;

	/**
	 * 位图数据
	 */
	private var _bitmaps:Dictionary<String, BitmapData>;

	/**
	 * JSON数据
	 */
	private var _jsons:Dictionary<String, Dynamic>;

	/**
	 * XML数据
	 */
	private var _xmls:Dictionary<String, Xml>;

	/**
	 * 精灵图数据
	 */
	private var _textures:Dictionary<String, TextureAtlas>;

	/**
	 * 声音数据
	 */
	private var _sounds:Dictionary<String, Sound>;

	/**
	 * 音乐数据
	 */
	private var _musics:Dictionary<String, Music>;

	/**
	 * 字体数据
	 */
	private var _fnts:Dictionary<String, FntData>;

	/**
	 * Spine纹理数据
	 */
	private var _spines:Dictionary<String, SpineTextureAtals>;

	#if (openfl_swf && swf)
	private var _swflites:Dictionary<String, AnimateLibrary>;
	#end

	/**
	 * 压缩包资源
	 */
	private var _zips:Dictionary<String, Zip>;

	#if castle
	private var _cdbs:Dictionary<String, CDBData>;
	#end
	private var _textcache:Dictionary<String, ZCacheTextField>;
	private var _strings:Dictionary<String, String>;
	private var _3ds:Dictionary<String, #if zygame3d zygame.utils.load.Loader3DData.ZLoader3D #else Dynamic #end>;
	private var _dynamicAtlas:Dictionary<String, DynamicTextureAtlas>;
	private var _3dprticle:Dictionary<String, Dynamic>;

	#if ldtk
	private var _ldtk:Dictionary<String, zygame.ldtk.LDTKProject>;
	#end

	/**
	 * 当前播放的背景音乐
	 */
	private var _bgid:String;

	/**
	 * 响应时间
	 */
	// private var _responseTime:Float = 0;

	public function new() {
		_sounds = new Dictionary<String, Sound>();
		_bitmaps = new Dictionary<String, BitmapData>();
		_jsons = new Dictionary<String, Dynamic>();
		_xmls = new Dictionary<String, Xml>();
		_textures = new Dictionary<String, TextureAtlas>();
		_bytes = new Dictionary<String, ByteArray>();
		_musics = new Dictionary<String, Music>();
		_fnts = new Dictionary<String, FntData>();
		_spines = new Dictionary<String, SpineTextureAtals>();
		#if (openfl_swf && swf)
		_swflites = new Dictionary<String, AnimateLibrary>();
		#end
		_zips = new Dictionary<String, Zip>();
		#if castle
		_cdbs = new Dictionary<String, CDBData>();
		#end
		_strings = new Dictionary<String, String>();
		_textcache = new Dictionary();
		_3ds = new Dictionary();
		_dynamicAtlas = new Dictionary();
		_3dprticle = new Dictionary();
		#if ldtk
		_ldtk = new Dictionary();
		#end
	}

	/**
	 * 加载3D文件
	 * @param path 3D文件
	 * @param contextFiles 该3D文件关联的文件，如动画文件。
	 */
	public function load3DFile(path:String):Void {
		pushPasrers(new Loader3DParser(path));
	}

	/**
	 *  载入资源列表
	 * @param arr -
	 */
	public function loadFiles(arr:Array<String>):Void {
		for (i in 0...arr.length) {
			loadFile(arr[i]);
		}
	}

	/**
	 * 如果ASTC支持，则转换为ASTC资源路径
	 * @param path 
	 * @return String
	 */
	private function converToAstc(path:String):String {
		if (onlyASTCTexture) {
			var isPNG = StringTools.endsWith(path, ".png");
			if (isPNG) {
				path = StringTools.replace(path, ".png", ".astc");
			}
		}
		return path;
	}

	/**
	 *  载入单个文件
	 * @param path -
	 */
	public function loadFile(data:Dynamic):Void {
		if (Std.isOfType(data, ParserBase)) {
			pushPasrers(data);
			return;
		}
		if (Std.isOfType(data, String) && _loadfilelist.indexOf(data) == -1) {
			// 检查该path可载入的支持
			data = converToAstc(data);
			for (base in LoaderAssets.fileparser) {
				var cheakpath:String = data;
				var ext:String = StringUtils.getExtType(cheakpath);
				if (extPasrer.exists(ext)) {
					ext = extPasrer.get(ext);
					cheakpath = cheakpath.substr(0, cheakpath.lastIndexOf(".")) + "." + ext;
				}
				var bool = Reflect.callMethod(base, Reflect.field(base, "supportType"), [cheakpath]);
				if (bool) {
					pushPasrers(Type.createInstance(base, [data]));
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
		#if (!openfl_swf || !swf)
		throw "OpenFL9 not support SWF file.";
		#else
		pushPasrers(new SWFParser({
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
			if (Std.isOfType(loader, DynamicTextureAtlasParser) && cast(loader, DynamicTextureAtlasParser).getName() == atlasName) {
				cast(loader, DynamicTextureAtlasParser).loader.loadFile(path);
				return;
			}
		}
		var atlasLoader = new DynamicTextureAtlasParser(atlasName);
		atlasLoader.loader.loadFile(path);
		pushPasrers(atlasLoader);
	}

	/**
	 * 加载Zip资源包
	 * @param path
	 */
	public function loadAssetsZip(path:String):Void {
		pushPasrers(new ZIPAssetsParser(path));
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
	 * @param img 如果只传递图片，xml会直接识别图片资源
	 * @param config 可传递.xml或者.json文件，如果不传递，则默认使用.xml后缀
	 */
	public function loadTextures(img:String, config:String = null, isAtf:Bool = false):Void {
		img = converToAstc(img);
		var _config = config != null ? config : img.substr(0, img.lastIndexOf(".")) + ".xml";
		if (StringTools.endsWith(_config, ".xml"))
			pushPasrers(new TextureAtlasParser({
				imgpath: img,
				xmlpath: _config,
				path: _config,
				atf: isAtf
			}));
		else if (StringTools.endsWith(_config, ".json")) {
			pushPasrers(new JSONTextureAtlas(img, _config));
		}
	}

	/**
	 * 以Base64格式加载资源
	 * @param imgBase64 图片base64格式数据
	 * @param xmlString xml字符串数据
	 * @param filename 储存到assets中的映射名
	 * @param isAtf
	 */
	public function loadBase64Textures(imgBase64:String, xmlString:String, filename:String, isAtf:Bool):Void {
		pushPasrers(new TextureAtlasParser({
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
		for (index => img in texPaths) {
			texPaths[index] = converToAstc(img);
		}
		pushPasrers(new SpineParser({
			imgs: texPaths,
			atlas: texJsonPath,
			path: texJsonPath,
			base64: false
		}));
	}

	/**
	 * 加载Aseprite生成的JSONTextureAtlas精灵图
	 * @param texPath 
	 * @param jsonPath 
	 */
	public function loadAsepriteTextureAtlas(texPath:String, jsonPath:String):Void {
		pushPasrers(new AsepriteParser({
			path: texPath,
			json: jsonPath
		}));
	}

	/**
	 * 获取Aseprite的精灵图对象
	 * @return AsepriteTextureAtlas
	 */
	public function getAsepriteTextureAtlas(id:String):AsepriteTextureAtlas {
		return cast _textures.get(id);
	}

	/**
	 * 追加加载解析器，并在追加的时候，会检索是否已经存在过相同的资源，如果是则不会再次载入
	 * @param parser 
	 */
	private function pushPasrers(parser:ParserBase):Void {
		#if assets_debug
		ZLog.log("[push pasrers] ready " + parser.getName());
		#end
		for (base in _parsers) {
			if (base.equal(parser)) {
				// 队列已存在
				#if assets_debug
				ZLog.warring(["队列已经存在相同的加载资源：", parser.getName()]);
				#end
				return;
			}
		}
		// 这里需要检测资源是否已经存在，如果存在，则不再载入
		var name = StringUtils.getName(parser.getName());
		if (getBitmapData(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		if (getObject(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		if (getTextureAtlas(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		if (getSpineTextureAlats(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		if (getXml(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		if (getSound(name) != null) {
			#if assets_debug
			ZLog.log("[exsit pasrers] return " + parser.getName());
			#end
			return;
		}
		#if assets_debug
		ZLog.log("[push pasrers] " + parser.getName());
		#end
		_parsers.push(parser);
	}

	/**
	 * 加载Base64Spine纹理集资源
	 * @param texPaths 需要提供路径/base64数据，支持多纹理
	 * @param jsonData 纹理json数据
	 * @param texJsonPath 纹理json路径
	 */
	public function loadBase64SpineTextAlats(texPaths:Array<{path:String, base64data:String}>, jsonData:String, texJsonPath:String):Void {
		pushPasrers(new SpineParser({
			imgs: texPaths,
			atlas: jsonData,
			path: texJsonPath,
			base64: true
		}));
	}

	/**
	 * 获取LDTK编辑的地图数据，请注意，需要引入zygameui-ldtk库才能正常使用。
	 * @param id 
	 * @return #if ldtk zygame.ldtk.LDTKProject #else Dynamic #end
	 */
	public function getLDTKProject(id:String):#if ldtk zygame.ldtk.LDTKProject #else Dynamic #end {
		#if ldtk
		return _ldtk.get(id);
		#else
		return null;
		#end
	}

	/**
	 * 载入位图字体
	 * @param pngPath
	 * @param xmlPath
	 */
	public function loadFnt(pngPath:String, xmlPath:String):Void {
		pngPath = converToAstc(pngPath);
		pushPasrers(new FntParser({
			imgpath: pngPath,
			fntpath: xmlPath,
			path: xmlPath
		}));
	}

	/**
	 * 加载音乐
	 * @param path
	 */
	public function loadMusic(path:String):Void {
		pushPasrers(new MP3Parser({
			type: "Music",
			path: path
		}));
	}

	public function getNowLoadCount():Int {
		return _parsers.length;
	}

	public var canError:Bool = false;

	/**
	 * 是否正在加载中
	 * @return Bool
	 */
	public function isLoading():Bool {
		return !_loadStop;
	}

	/**
	 * 计时器
	**/
	private var timer:openfl.utils.Timer;

	/**
	 *  开始加载
	 * @param func - 加载进度回调
	 * @param errorCall - 错误回调
	 * @param canError - 是否允许容错加载，如果设置为true，则永远不会触发errorCall
	 */
	public function start(func:Float->Void, errorCall:String->Void = null, canError:Bool = false):Void {
		if (!_loadStop) {
			throw "ZAssets已经在载入资源中，不能再次调用start方法";
		}
		// _responseTime = Timer.stamp();
		this.canError = canError;
		_errorCallBack = errorCall;
		_callBack = func;
		_loadStop = false;
		this.currentLoadedCount = 0;
		this.currentLoadIndex = 0;
		this.currentLoadNumber = 0;
		// 加载循序排序，优先加载zip资源
		_parsers.sort((a, b) -> Std.isOfType(a, ZIPAssetsParser) ? -1 : 0);
		#if assets_debug
		ZLog.log("PARSER LOAD START:" + _parsers.toString());
		#end
		if (_parsers.length == 0) {
			// 没有任何加载资源，直接成功
			_loadStop = true;
			if (func != null)
				func(1);
			__clearCallBack();
			return;
		}
		if (timeout != -1) {
			if (timer == null) {
				timer = new openfl.utils.Timer(1000, 0);
				timer.addEventListener(TimerEvent.TIMER, onTimeOutCheck);
			}
			timer.reset();
			timer.start();
		}
		this.loadNext();
	}

	/**
		检查是否超时
	**/
	private function onTimeOutCheck(e:TimerEvent):Void {
		var time = Timer.stamp();
		var outtime = time - this._lastTime;
		if (outtime >= timeout) {
			loadError("加载超时");
		}
	}

	/**
	 * 清空所有加载状态
	 */
	public function reset():Void {
		_parsers = [];
		_loadingParsers = [];
		_loadStop = true;
		this.currentLoadedCount = 0;
		this.currentLoadIndex = 0;
		this.currentLoadNumber = 0;
	}

	/**
	 * 当加载失败后，可以通过该接口重新加载
	 */
	public function resetLoad():Void {
		_loadingParsers = [];
		_loadStop = true;
		start(_callBack, _errorCallBack);
	}

	/**
	 * 开始载入下一个资源
	 */
	private function loadNext():Void {
		_lastTime = Timer.stamp();
		if (_parsers.length <= currentLoadIndex || _loadStop) {
			// 检查是否已载入完毕
			var curprogress = getProgress();
			if (curprogress == 1 && !_loadStop) {
				this._parsers = [];
				this._loadfilelist = [];
				#if assets_debug
				ZLog.log("载入进度：" + Std.int(curprogress * 100) + "%");
				#end
				_loadStop = true;
				if (_callBack != null) {
					var cb = _callBack;
					__clearCallBack();
					cb(curprogress);
				}
				if (timer != null)
					timer.stop();
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

		#if assets_debug
		trace("载入进度：" + currentLoadIndex, currentLoadNumber, Type.getClassName(Type.getClass(parser)), _parsers.length, parser.getName());
		#end
		parser.out = onAssetsOut;
		parser.done = loadDone;
		parser.error = loadError;
		_loadingParsers.push(parser);
		parser.load(this);
		// 如果是ZIP资源，需要等待ZIP载入完毕后，再载入其他资源
		if (Std.isOfType(parser, ZIPAssetsParser)) {
			return;
		}
		if (maxLoadNumber > currentLoadNumber) {
			loadNext();
		}
	}

	private function loadError(msg:String):Void {
		ZLog.error("载入发生异常：" + msg);
		if (_loadStop) {
			return;
		}
		if (canError) {
			loadDone();
		} else {
			#if cmnt
			// TODO 回调错误
			GameUtils.reportErrorLog("加载API", "加载失败：" + msg, "无", "API", ErrorLogLevel.ERROR);
			#end

			_loadStop = true;

			// 全局加载失败事件
			if (globalListener != null && globalListener.hasEventListener(GlobalAssetsLoadEvent.LOAD_ERROR)) {
				var event = new GlobalAssetsLoadEvent(GlobalAssetsLoadEvent.LOAD_ERROR);
				event.url = msg;
				event.assets = this;
				globalListener.dispatchEvent(event);
				if (event.interceptErrorEvent) {
					ZLog.warring("Error event is intercept.");
					return;
				}
			}

			if (timer != null)
				timer.stop();
			_parsers = [];
			_loadfilelist = [];
			currentLoadNumber = 0;
			if (_errorCallBack != null) {
				_errorCallBack(msg);
			}
			__clearCallBack();
		}
	}

	/**
	 * 将回调进行清空
	 */
	private function __clearCallBack():Void {
		_errorCallBack = null;
		_callBack = null;
	}

	/**
	 * 当加载完毕后统一处理
	 */
	private function loadDone():Void {
		// this.currentLoadNumber--;
		this.currentLoadedCount++;
		loadNext();
	}

	/**
	 * 当前资源器的载入进度(精细化)
	 * @return Float
	 */
	public function getProgress():Float {
		return currentLoadedCount / currentLoadNumber;
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

	public function putSpineTextureAtlas(name:String, spineAtlas:SpineTextureAtals):Void {
		_spines.set(name, spineAtlas);
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
			case BYTES:
				_bytes.set(parser.getName(), data);
			case LDTK:
				// LDTK编辑器生成的地图数据
				#if ldtk
				_ldtk.set(parser.getName(), data);
				#end
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
				#if (openfl_swf && swf)
				this._swflites.set(parser.getName(), data);
				#end
			case FNT:
				_fnts.set(parser.getName(), data);
			case MUSIC:
				_musics.set(parser.getName(), data);
			case SOUND:
				_sounds.set(parser.getName(), data);
			case TEXTUREATLAS:
				var pname:String = parser.getName();
				this.putTextureAtlas(pname, data);
			case BITMAP:
				var pname:String = parser.getName();
				setBitmapData(pname, data);
			case TEXT:
				_strings.set(parser.getName(), data);
			case XML:
				_xmls.set(parser.getName(), data);
			case JSON:
				_jsons.set(parser.getName(), data);
			#if castle
			case CDB:
				_cdbs.set(parser.getName(), data);
			#end
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
		#if assets_debug
		trace(parser.getName(), "loaded", "载入进度：" + Std.int(getProgress() * 100) + "%");
		#end
		// 如果已经加载停止了，则直接释放已有的资源
		if (_loadStop) {
			this.unloadAllByName(parser.getName());
		}
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
		if (atlasAndJson.indexOf(":") == -1)
			atlasAndJson = atlasAndJson + ":" + atlasAndJson;
		var names:Array<String> = atlasAndJson.split(":");
		if (getSpineTextureAlats(names[0]) == null)
			return null;
		return getSpineTextureAlats(names[0]).buildSpriteSkeletonDataByJson(names[1], getObject(names[1]));
	}

	/**
	 * 获取SkeletonData(Tilemap)
	 * @param atlasAndJson 纹理名:JSON名
	 * @return spine.SkeletonData
	 */
	public function getSpineTilemapSkeletonData(atlasAndJson:String):spine.SkeletonData {
		if (atlasAndJson.indexOf(":") == -1)
			atlasAndJson = atlasAndJson + ":" + atlasAndJson;
		var names:Array<String> = atlasAndJson.split(":");
		return getSpineTextureAlats(names[0]).buildTilemapSkeletonDataByJson(names[1], getObject(names[1]));
	}

	/**
	 * 创建Sprite渲染器的Spine骨骼
	 * @param atalsName
	 * @param skeletonJsonName
	 * @return spine.openfl.SkeletonAnimation
	 */
	public function createSpineSpriteSkeleton(atalsName:String, skeletonJsonName:String):spine.openfl.SkeletonAnimation {
		var jsonData = this.getObject(skeletonJsonName);
		if (jsonData == null) {
			jsonData = this.getBytes(skeletonJsonName);
			if (jsonData == null)
				throw "Spine缺少json对象：" + skeletonJsonName;
		}
		#if spine_haxe
		// TODO 这里可以改进性能
		return _spines.get(atalsName).buildSpriteSkeleton(skeletonJsonName, jsonData);
		#else
		return _spines.get(atalsName).buildSpriteSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectJsonData(jsonData));
		#end
	}

	/**
	 * 创建Tilemap渲染器的Spine骨骼
	 * @param atalsName
	 * @param skeletonJsonName
	 * @return spine.tilemap.SkeletonAnimation
	 */
	public function createSpineTilemapSkeleton(atalsName:String, skeletonJsonName:String):spine.tilemap.SkeletonAnimation {
		var jsonData = this.getObject(skeletonJsonName);
		if (jsonData == null)
			throw "Spine缺少json对象：" + skeletonJsonName;
		#if spine_haxe
		return _spines.get(atalsName).buildTilemapSkeleton(skeletonJsonName, jsonData);
		#else
		return _spines.get(atalsName).buildTilemapSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectJsonData(jsonData));
		#end
	}

	/**
	 * 获取MovieClip对象，SWF名:SWF映射
	 * @param id
	 * @return MovieClip
	 */
	public function getMovieClip(id:String):MovieClip {
		#if (!openfl_swf || !swf)
		return null;
		#else
		var arr:Array<String> = id.split(":");
		var swf:AnimateLibrary = this._swflites.get(arr[0]);
		return swf.getMovieClip(arr[1]);
		#end
	}

	/**
	 * 卸载指定的Swflite对象
	 * @param id
	 */
	public function unloadSwfliteFile(id:String):Void {
		#if (openfl_swf && swf)
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
	 * @param id -
	 *  @return TextureAtlas
	 */
	public function getTextureAtlas(id:String):TextureAtlas {
		return _textures.get(id);
	}

	/**
	 *  追加纹理集合
	 * @param id -
	 * @param textureAtlas -
	 */
	public function putTextureAtlas(id:String, textureAtlas:TextureAtlas):Void {
		var textures:TextureAtlas = getTextureAtlas(id);
		if (textures != null)
			textures.dispose();
		_textures.set(id, textureAtlas);
	}

	#if away3d
	public var bitmapDataTexture3D:Map<String, BitmapTexture> = [];
	#end

	/**
	 * 获取away3d可用的纹理
	 * @param id 
	 * @return Dynamic
	 */
	public function getTexture3D(id:String):#if away3d BitmapTexture #else Dynamic #end {
		#if away3d
		if (bitmapDataTexture3D.exists(id))
			return bitmapDataTexture3D.get(id);
		var bitmapData = getBitmapData(id);
		if (bitmapData == null)
			return null;
		var texture = away3d.utils.Cast.bitmapTexture(bitmapData);
		bitmapDataTexture3D.set(id, texture);
		return texture;
		#else
		return null;
		#end
	}

	/**
	 *  获取位图数据
	 * @param id -
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
			t = new ZCacheTextField(id, fontName, size, color);
			// 是否自动换行
			t.cacheAutoWrap = autoWarp;
			t.text = text;
			_textcache.set(id, t);
		} else {
			// 是否自动换行
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
	 * 获取压缩文件中的文本
	 * @param id 
	 * @return Dynamic
	 */
	private function getZipString(id:String):String {
		for (zip in _zips) {
			var data:String = _zips.get(zip).getString(id);
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
		@:privateAccess SoundChannelManager.current.playMusic(sound);
	}

	/**
	 * 停止背景音乐
	 */
	public function stopBGMusic():Void {
		SoundChannelManager.current.stopMusic();
	}

	/**
	 * 播放音效，如果需要操作复杂的，可使用getSound()方法进行实现
	 * @param id
	 * @param loop
	 */
	public function playSound(id:String, loop:Int = 1):SoundChannel {
		var sound:Sound = getSound(id);
		return @:privateAccess SoundChannelManager.current.playEffect(sound, loop);
	}

	/**
	 *  获取Xml格式
	 * @param id -
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

	#if castle
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
	#end

	/**
	 *  获取JSON对象
	 * @param id -
	 *  @return Dynamic
	 */
	public function getObject(id:String):Dynamic {
		return _jsons.get(id);
	}

	/**
	 * 根据ID获得二进制
	 * @param id 
	 * @return ByteArray
	 */
	public function getBytes(id:String):ByteArray {
		return _bytes.get(id);
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
	 * 根据名称卸载所有相关的资源
	**/
	public function unloadAllByName(name:String):Void {
		__unloadAll(name);
	}

	/**
	 * 卸载所有资源
	 */
	public function unloadAll():Void {
		__unloadAll();
		__clearCallBack();
	}

	private function __unloadAll(name:String = null):Void {
		for (s in _xmls) {
			if (name == null || name == s)
				_xmls.remove(s);
		}
		for (b in _bytes) {
			_bytes.remove(b);
		}
		for (key in _bitmaps) {
			if (name == null || name == key)
				removeBitmapData(key);
		}
		for (key in _textures) {
			if (name == null || name == key)
				removeTextureAtlas(key);
		}
		for (key in _spines) {
			if (name == null || name == key)
				removeSpineTextureAtlas(key);
		}
		for (key in _sounds) {
			if (name == null || name == key)
				removeSound(key);
		}
		for (key in _musics) {
			if (name == null || name == key)
				removeMusic(key);
		}
		for (key in _textcache) {
			if (name == null || name == key)
				removeTextCache(key);
		}
		for (key in _zips) {
			if (name == null || name == key)
				unloadAssetsZip(key);
		}
		#if castle
		for (key in _cdbs) {
			if (name == null || name == key)
				removeCDBData(key);
		}
		#end
		for (key => value in _jsons) {
			_jsons.remove(key);
		}
	}

	/**
	 * 删除指定的缓存对象
	 * @param id
	 */
	public function removeTextCache(id:String):Void {
		if (_textcache.exists(id)) {
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
		return load;
	}

	public function getParsers():Array<ParserBase> {
		return _parsers;
	}
}
