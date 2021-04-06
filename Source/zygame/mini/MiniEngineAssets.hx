package zygame.mini;

import zygame.utils.load.SpineTextureAtalsLoader.SpineTextureAtals;
import zygame.utils.AssetsUtils.BytesSoundLoader;
import zygame.script.ZHaxe;
import zygame.utils.ZGC;
import zygame.utils.load.TextureLoader.TextureAtlas;
import zygame.mini.MiniEngine.MiniEngineHaxe;
import openfl.display.DisplayObject;
import zygame.components.ZBuilder;
import zygame.utils.StringUtils;
import zygame.utils.ZAssets;

/**
 * 迷你小引擎的资源管理
 */
class MiniEngineAssets extends ZAssets {
	public var mainClassName:String = "Main";

	public var path:String = null;

	public var haxeMaps:Map<String, MiniEngineHaxe> = [];

	private var entryKeys:Iterator<String>;

	private var _call:Builder->Void;

	private var _parent:DisplayObject;

	/**
	 * 模拟静态属性
	 */
	public var staticData:Map<String, Dynamic> = [];

	/**
	 * 载入引入
	 */
	private var _builder:Builder;

	/**
	 * 创建APP，注意第一次调用一般为异步，第二次调用一般为同步，多次创建会重新new对象。
	 * @param parent
	 * @param call
	 */
	public function createApp(parent:DisplayObject, call:Builder->Void, mainClassName:String = "Main"):Void {
		_parent = parent;
		_call = call;
		this.mainClassName = mainClassName;
		if (entryKeys == null) {
			var zip = this.getZip(StringUtils.getName(path));
			entryKeys = zip.entrys.keys();
		}
		// 解析资源
		nextLoad();
	}

	/**
	 * 解析HaxeData
	 * @param haxeData
	 * @return Xml
	 */
	dynamic public function onParsingHaxeData(name:String, haxeData:Xml):Xml {
		return haxeData;
	}

	private function nextLoad():Void {
		if (!entryKeys.hasNext()) {
			onSuccess();
			return;
		}
		var zip = this.getZip(StringUtils.getName(path));
		var id = entryKeys.next();
		if(id.indexOf(".") == 0){
			//隐藏文件
			nextLoad();
			return;
		}
		var pngid:String = StringUtils.getName(id);
		if (zip.getJson(pngid) != null)
		{
			//默认写入
			this.setObject(pngid,zip.getJson(pngid));
		}
		if (StringTools.endsWith(id, "png") || StringTools.endsWith(id, "jpg")) {
			// 开始加载png/jpg
			zip.loadBitmapData(pngid, function(bitmapData):Void {
				// 精灵表单支持
				if (zip.getString(pngid + ".atlas") != null) {
					@:privateAccess this._spines.set(pngid, new SpineTextureAtals([pngid => bitmapData], zip.getString(pngid + ".atlas")));
				} else if (zip.getXml(pngid) != null) {
					this.putTextureAtlas(pngid, new TextureAtlas(bitmapData, zip.getXml(pngid)));
				} else
					this.setBitmapData(pngid, bitmapData);
				nextLoad();
			});
		} else if (StringTools.endsWith(id, "mp3") || StringTools.endsWith(id, "ogg")) {
			// 音频
			var sid = StringUtils.getName(id);
			zip.loadSound(sid, function(sound):Void {
				this.setSound(sid, sound);
				nextLoad();
			});
		} else if (StringTools.endsWith(id, "hx")) {
			// Haxe语言
			var hxid = StringUtils.getName(id);
			var main = zip.getHScript(hxid);
			var minihaxe = MiniEngine.parseMiniHaxe(main);
			trace("minihaxe=",minihaxe.xml.toString());
			this.setXml(hxid, this.onParsingHaxeData(hxid, minihaxe.xml));
			haxeMaps.set(hxid, minihaxe);
			for (key => value in minihaxe.vars) {
				if (value.isStatic) {
					if (staticData.get(hxid) == null)
						staticData.set(hxid, {});
					var data = Type.createInstance(value.type, []);
					Reflect.setProperty(staticData.get(hxid), value.name, data.data);
				}
			}
			for (key => value in minihaxe.functions) {
				if (value.isStatic) {
					if (staticData.get(hxid) == null)
						staticData.set(hxid, {});
					var data = new ZHaxe(value.hscript);
					data.argsName = value.args.split(",");
					Reflect.setProperty(staticData.get(hxid), value.name, data.value);
				}
			}
			nextLoad();
		} else
			nextLoad();
	}

	/**
	 * 载入完成事件
	 */
	private function onSuccess():Void {
		var builder:Builder = ZBuilder.buildXmlUI(this, mainClassName, _parent);
		cast(builder.display, MiniEngineScene).assets = this;
		cast(builder.display, MiniEngineScene).baseBuilder = builder;
		_builder = builder;
		MiniUtils.variablesAllHaxe(this, builder, mainClassName);
		_call(builder);
	}

	/**
	 * 获取当前运行的APP迷你内置小程序
	 * @return MiniEngineScene
	 */
	public function getApp():MiniEngineScene {
		if (this._builder == null)
			return null;
		return cast this._builder.display;
	}

	/**
	 * 卸载所有逻辑，内置小程序使用的内存，应由小程序自主移除。
	 */
	override function unloadAll() {
		this.entryKeys = null;
		if (_builder != null)
			_builder.variablesAllHaxeBindMiniAssets(null);
		if (getApp() != null) {
			ZGC.disposeFrameEvent(getApp());
			getApp().unload();
		}
		super.unloadAll();
		_builder = null;
	}
}
