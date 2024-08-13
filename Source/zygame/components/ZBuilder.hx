package zygame.components;

import zygame.components.data.CacheBuilderData;
#if hscript
import hscript.Interp;
import hscript.Parser;
#end
import zygame.utils.ZLog;
import zygame.components.data.MixColorData;
import zygame.components.base.IBuilder;
import zygame.components.style.XmlStyle;
#if feathersui
import zygame.feathersui.FListView;
#end
#if openfl_console
import com.junkbyte.console.Cc;
#end
import zygame.display.batch.BStack;
import zygame.media.base.Sound;
import zygame.utils.load.SpineTextureAtalsLoader.SpineTextureAtals;
import haxe.Exception;
import zygame.components.ZBitmapLabel;
import zygame.mini.MiniEngineAssets;
import zygame.mini.MiniEngineScene;
import zygame.shader.engine.ZShader;
import zygame.components.data.AnimationData;
import zygame.display.batch.BAnimation;
import zygame.utils.StringUtils;
import zygame.utils.load.Frame;
import zygame.components.base.ToggleButton;
import zygame.utils.load.TextureLoader.TextureAtlas;
import haxe.macro.Compiler;
import zygame.utils.Lib;
import zygame.display.batch.ImageBatchs;
import openfl.display.DisplayObjectContainer;
import zygame.utils.ZAssets;
import openfl.display.Tilemap;
import zygame.display.batch.BButton;
import zygame.components.ZLabel;
import openfl.display.Tile;
import zygame.display.batch.BLabel;
import openfl.display.TileContainer;
import zygame.components.ZButton;
import zygame.display.batch.BBox;
import zygame.components.ZBox;
import zygame.components.ZList;
import zygame.display.batch.BSpine;
import zygame.script.ZHaxe;
import openfl.display.DisplayObject;
import zygame.components.ZAnimation;
import zygame.utils.load.Atlas;

/**
 * UI创建器
 */
class ZBuilder {
	private static var igone:Array<String> = ["left", "right", "top", "bottom", "centerX", "centerY"];

	private static var classMaps:Map<String, Dynamic>;

	private static var parsingMaps:Map<String, Dynamic->String->String->Void>;

	private static var createMaps:Map<String, Xml->Array<Dynamic>>;

	private static var addMaps:Map<String, Dynamic->Dynamic->Xml->Void>;

	private static var endMaps:Map<String, Dynamic->Void>;

	private static var baseAssetsList:Array<ZAssets> = [];

	/**
	 * 定义值
	 */
	private static var defineMaps:Map<String, String>;

	/**
	 * Builder全局定义
	 */
	public static var builderDefine:Map<String, Dynamic> = [];

	/**
	 * 使用默认UI
	 * 按钮使用圆角九宫格图，其余使用边框图
	 */
	private static var useDefault:Bool = Compiler.getDefine("use_default_ui") == "1";

	private static var defalutAssets:ZAssets;

	public static function init():Void {
		#if use_default_ui
		defalutAssets = new ZAssets();
		BitmapData.loadFromBase64("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAAA3NCSVQICAjb4U/gAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAbFBMVEUAAADf39/j4+Pl5eXq6urr6+v4+Pj4+Pj4+Pj6+vr8/Pz8/Pz9/f39/f39/f39/f39/f39/f39/f39/f38/Pz8/Pz8/Pz8/Pz8/Pz+/v7+/v78/Pz8/Pz8/Pz+/v7+/v7+/v7+/v7+/v7////37Ig9AAAAI3RSTlMACAkKDA0jJCUyV1iIiYqYmZqbnMjJz9DR6Onq6/T19vj5+nYITrIAAAFPSURBVFjD7ZbdboQgEIVVEFzhao1P4Ps/Up+gm/ZmMSqgtZu2cdv1zLRpYn+cG1GGTzgwwyTJ1pYuX6TKc6XEczMOg/dD+BRAG6OuOwfnejYgNXX2sXs8nScMEC9PVR3TW3wjQ+QADke74qBlDDRAV4dVjzwfIgXIqhK4SNECHS7CGQuXaUyCAaomtqrWGGBTaq8tBOSGPG5lDgGKBCgI0IyQ0QggGACBAAUDUEANGACoQcYAZF/oYdrfAIwMtxEBPAPgEaBjADoEiAxARICeAeihBgMtAdTAtyTAQUBCXT7J5HCgx0AktZMjTqJzeAGOSjWTVxKcgQdP5qoYxGrKaB87RrILXqzkZofHL+oDW9+4X6Z7aosWg4rSvltHODsyUK5rJD3XSPryaernGqkPyS+web7Na/tuk5wo337d/Od74RtEbLacwW677fZT7AltvVXi+MMwkQAAAABJRU5ErkJggg==",
			"image/png")
			.onComplete((bdata) -> {
				defalutAssets.putTextureAtlas("ui", new TextureAtlas(bdata, Xml.parse('<?xml version="1.0" encoding="UTF-8"?>
            <TextureAtlas imagePath="dui.png">
                <SubTexture name="button" x="2" y="2" width="37" height="37"/>
                <SubTexture name="other" x="2" y="41" width="9" height="9"/>
            </TextureAtlas>
            ')));
				defalutAssets.getTextureAtlas("ui").bindScale9("button", "16 17 17 16");
				defalutAssets.getTextureAtlas("ui").bindScale9("other", "4 4 4 3");
			});
		#end

		classMaps = new Map();
		parsingMaps = new Map();
		createMaps = new Map();
		addMaps = new Map();
		endMaps = new Map();
		defineMaps = new Map();
		// fetherui组件支持
		#if feathersui
		bind(FListView);
		#end
		//
		bind(VBBox);
		bind(HBBox);
		bind(zygame.components.ZAnimation);
		bind(zygame.components.ZBitmapLabel);
		bind(zygame.components.ZBox);
		bind(zygame.components.ZButton);
		bind(zygame.components.ZImage);
		bind(zygame.components.ZInputLabel);
		bind(zygame.components.ZLabel);
		bind(zygame.components.ZList);
		bind(zygame.components.ZQuad);
		bind(zygame.components.ZScroll);
		bind(zygame.display.batch.TouchImageBatchsContainer);
		bind(zygame.display.batch.BButton);
		bind(zygame.display.batch.BDisplayObject);
		bind(zygame.display.batch.BDisplayObjectContainer);
		bind(zygame.display.batch.BImage);
		bind(zygame.display.batch.BLabel);
		bind(zygame.display.batch.BScale9Image);
		bind(zygame.display.batch.BSprite);
		bind(zygame.display.batch.BTouchSprite);
		bind(zygame.display.batch.ImageBatchs);
		bind(zygame.display.batch.BBox);
		bind(zygame.display.batch.BAnimation);
		bind(MiniEngineScene);
		bind(BScale9Button);
		bind(VBox);
		bind(HBox);
		bind(ZHaxe);
		bind(ZSound); // 绑定音频组件
		bind(ZShader); // 绑定着色器
		bind(ZInt);
		bind(ZBool);
		bind(ZString);
		bind(ZFloat);
		bind(ZArray);
		bind(ZObject);
		bind(ZAnimation);
		bind(ZTween);
		bind(NativeZBitmapLabel);
		bind(ZSpine);
		bind(BSpine);
		bind(ZStack);
		bind(BStack);
		bind(ZParticles);
		bind(ZCacheBitmapLabel);

		// 解析方法解析
		bindParsing(ZParticles, "src", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, zygame.components.ZParticles).dataProvider = value;
		});
		bindParsing(ZImage, "mouseEnabled", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, zygame.components.ZImage).display.mouseEnabled = value == "true";
			cast(ui, zygame.components.ZImage).mouseEnabled = cast(ui, zygame.components.ZImage).display.mouseEnabled;
		});
		bindParsing(zygame.components.ZImage, "src", function(ui:Dynamic, name:String, value:String):Void {
			var values = value.split(":");
			if (values.length >= 3) {
				// 解析绑定九宫格数据
				cast(getBaseTextureAtlas(values[0]), TextureAtlas).bindScale9(values[1], values[2]);
				values.pop();
				value = values.join(":");
			}
			if (value.indexOf("http") == 0 || getBaseBitmapData(value) == null)
				cast(ui, zygame.components.ZImage).dataProvider = value;
			else
				cast(ui, zygame.components.ZImage).dataProvider = getBaseBitmapData(value);
		});
		bindParsing(zygame.display.batch.BImage, "src", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, zygame.display.batch.BImage).setFrame(getBaseBitmapData(value));
		});
		bindParsing(zygame.display.batch.BScale9Image, "src", function(ui:Dynamic, name:String, value:String):Void {
			var values = value.split(":");
			if (values.length >= 3) {
				// 解析绑定九宫格数据
				cast(getBaseTextureAtlas(values[0]), TextureAtlas).bindScale9(values[1], values[2]);
			}
			var bitmap:Frame = cast getBaseBitmapData(value);
			cast(ui, zygame.display.batch.BScale9Image).setFrame(bitmap);
		});
		bindParsing(zygame.display.batch.BButton, "src", function(ui:Dynamic, name:String, value:String):Void {
			var arr:Array<String> = value.split(":");
			cast(ui, zygame.display.batch.BButton).skin = zygame.display.batch.BButton.createButtonFrameSkin(cast getBaseTextureAtlas(arr[0]),
				getBaseBitmapData(value));
			cast(ui, zygame.display.batch.BButton).updateComponents();
		});
		bindParsing(zygame.components.ZButton, "src", function(ui:Dynamic, name:String, value:String):Void {
			var values = value.split(":");
			if (values.length >= 3) {
				// 解析绑定九宫格数据
				cast(getBaseTextureAtlas(values[0]), TextureAtlas).bindScale9(values[1], values[2]);
			}
			cast(ui, zygame.components.ZButton).skin = zygame.components.ZButton.createSkin(getBaseBitmapData(value));
			cast(ui, zygame.components.ZButton).updateComponents();
		});

		// 动画原生
		bindParsing(ZAnimation, "src", function(ui:Dynamic, name:String, value:String):Void {
			var anData:AnimationData = cast(ui, ZAnimation).dataProvider;
			if (anData == null) {
				anData = new AnimationData(12);
			}
			var array = value.split(",");
			for (key => value2 in array) {
				if (value2.indexOf(":") != -1) {
					// 图集支持
					var valueArray:Array<String> = value2.split(":");
					var textureAtlas:TextureAtlas = cast getBaseTextureAtlas(valueArray[0]);
					anData.addFrame(textureAtlas.getBitmapDataFrame(valueArray[1]));
				} else {
					anData.addFrame(getBaseBitmapData(value));
				}
			}
			cast(ui, ZAnimation).dataProvider = anData;
		});
		bindParsing(ZAnimation, "loop", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZAnimation).loop = Std.parseInt(value);
		});
		bindParsing(ZAnimation, "play", function(ui:Dynamic, name:String, value:String):Void {
			if (value == "true")
				cast(ui, ZAnimation).play(cast(ui, ZAnimation).loop);
			else
				cast(ui, ZAnimation).stop();
		});
		bindParsing(ZAnimation, "fps", function(ui:Dynamic, name:String, value:String):Void {
			var anData:AnimationData = cast(ui, ZAnimation).dataProvider;
			if (anData == null) {
				anData = new AnimationData(12);
				cast(ui, ZAnimation).dataProvider = anData;
			}
			anData.fps = Std.parseInt(value);
		});

		// 动画批渲染
		bindParsing(BAnimation, "src", function(ui:Dynamic, name:String, value:String):Void {
			var anData:AnimationData = cast(ui, BAnimation).dataProvider;
			if (anData == null) {
				anData = new AnimationData(12);
			}
			if (value.indexOf(",") != -1) {
				var array = value.split(",");
				for (key => value2 in array) {
					if (value2.indexOf(":") != -1) {
						// 图集支持
						var valueArray:Array<String> = value2.split(":");
						var textureAtlas:TextureAtlas = cast getBaseTextureAtlas(valueArray[0]);
						anData.addFrame(textureAtlas.getBitmapDataFrame(valueArray[1]));
					}
				}
			} else {
				var array = value.split(":");
				var textureAtlas:TextureAtlas = cast getBaseTextureAtlas(array[0]);
				anData.addFrames(textureAtlas.getBitmapDataFrames(array[1]));
			}
			cast(ui, BAnimation).dataProvider = anData;
		});
		bindParsing(BAnimation, "play", function(ui:Dynamic, name:String, value:String):Void {
			if (value == "true")
				cast(ui, BAnimation).play(cast(ui, BAnimation).loop);
			else
				cast(ui, BAnimation).stop();
		});
		bindParsing(BAnimation, "loop", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BAnimation).loop = Std.parseInt(value);
		});
		bindParsing(BAnimation, "fps", function(ui:Dynamic, name:String, value:String):Void {
			var anData:AnimationData = cast(ui, BAnimation).dataProvider;
			if (anData == null) {
				anData = new AnimationData(12);
				cast(ui, BAnimation).dataProvider = anData;
			}
			anData.fps = Std.parseInt(value);
		});
		bindParsing(BScale9Button, "src", function(ui:Dynamic, name:String, value:String):Void {
			var arr:Array<String> = value.split(":");
			if (arr.length >= 3) {
				// 解析绑定九宫格数据
				cast(getBaseTextureAtlas(arr[0]), TextureAtlas).bindScale9(arr[1], arr[2]);
			}
			cast(ui, BScale9Button).skin = zygame.display.batch.BButton.createButtonFrameSkin(cast getBaseTextureAtlas(arr[0]), getBaseBitmapData(value));
			cast(ui, BScale9Button).updateComponents();
		});
		bindParsing(ZHaxe, "args", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZHaxe).argsName = value.split(",");
		});
		bindParsing(BScale9Button, "content", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BScale9Button).setContent(getBaseBitmapData(value));
		});
		bindParsing(zygame.components.ZButton, "content", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, zygame.components.ZButton).setContent(getBaseBitmapData(value));
		});
		bindParsing(BButton, "content", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BButton).setContent(getBaseBitmapData(value));
		});
		bindParsing(BLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BLabel).updateText(value);
		});
		bindParsing(ZButton, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZButton).setText(value);
		});
		bindParsing(ZButton, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZButton).setTextColor(Std.parseInt(value));
		});
		bindParsing(ZButton, "stroke", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZButton).setTextStroke(Std.parseInt(value));
		});
		bindParsing(ZLabel, "mixColor", function(ui:Dynamic, name:String, value:String):Void {
			var array = value.split(",");
			cast(ui, ZButton).mixColor = new MixColorData(Std.parseInt(array[0]), Std.parseInt(array[1]));
		});
		bindParsing(ZButton, "offest", function(ui:Dynamic, name:String, value:String):Void {
			var args = value.split(",");
			cast(ui, ZButton).setTextPos(Std.parseInt(args[0]), Std.parseInt(args[1]));
		});
		bindParsing(ZLabel, "stroke", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).stroke(Std.parseInt(value));
		});
		bindParsing(ZLabel, "wordWrap", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).setWordWrap(value == "true");
		});
		bindParsing(ZLabel, "mixColor", function(ui:Dynamic, name:String, value:String):Void {
			var array = value.split(",");
			cast(ui, ZLabel).mixColor = new MixColorData(Std.parseInt(array[0]), Std.parseInt(array[1]));
		});
		bindParsing(ZLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).dataProvider = value;
		});
		bindParsing(ZButton, "size", function(ui:Dynamic, name:String, value:String):Void {
			zygame.utils.Lib.nextFrameCall(cast(ui, ZButton).setTextSize, [Std.parseInt(value)]);
		});
		bindParsing(BLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(BLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, BLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(ZLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(ZInputLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZInputLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(ZInputLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZInputLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(ZLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(ZBitmapLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZBitmapLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(ZBitmapLabel, "fontName", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZBitmapLabel).setFontName(value);
		});
		bindParsing(ZBitmapLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZBitmapLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(ZBitmapLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZBitmapLabel).dataProvider = value;
		});
		bindParsing(ZCacheBitmapLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZCacheBitmapLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(ZCacheBitmapLabel, "fontName", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZCacheBitmapLabel).setFontName(value);
		});
		bindParsing(ZCacheBitmapLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZCacheBitmapLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(ZCacheBitmapLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZCacheBitmapLabel).dataProvider = value;
		});
		bindParsing(ZInputLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZInputLabel).dataProvider = value;
		});
		bindParsing(NativeZBitmapLabel, "color", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, NativeZBitmapLabel).setFontColor(Std.parseInt(value));
		});
		bindParsing(NativeZBitmapLabel, "size", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, NativeZBitmapLabel).setFontSize(Std.parseInt(value));
		});
		bindParsing(NativeZBitmapLabel, "text", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, NativeZBitmapLabel).dataProvider = value;
		});
		bindParsing(ZList, "src", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZList).createImageBatch(cast getBaseTextureAtlas(value));
		});
		bindParsing(ZList, "itemRenderType", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZList).itemRenderType = cast Type.resolveClass(value);
		});

		// 绑定解析
		bindCreate(ZSound, function(xml:Xml):Array<Dynamic> {
			return [xml.get("src"), xml.get("music") == "true"];
		});
		bindCreate(ZSpine, function(xml:Xml):Array<Dynamic> {
			var target = __getParentDefineValue(xml, xml.get("src"));
			if (target != null) {
				var data = target.split(":");
				return [
					data[0],
					data[1],
					xml.get("tilemap") == "true",
					xml.get("native") == "true",
					!xml.exists("isLoop") || xml.get("isLoop") == "true"
				];
			}
			return [];
		});
		bindCreate(BSpine, function(xml:Xml):Array<Dynamic> {
			var target = xml.get("src");
			if (target != null) {
				var data = target.split(":");
				return [data[0], data[1]];
			}
			return [];
		});
		bindCreate(ZBitmapLabel, function(xml:Xml):Array<Dynamic> {
			var a:Atlas = getBaseTextureAtlas(xml.get("src"));
			return [a];
		});
		bindCreate(NativeZBitmapLabel, function(xml:Xml):Array<Dynamic> {
			var a:Atlas = getBaseTextureAtlas(xml.get("src"));
			return [a];
		});
		bindCreate(zygame.display.batch.TouchImageBatchsContainer, function(xml:Xml):Array<Dynamic> {
			var a:Atlas = getBaseTextureAtlas(xml.get("src"));
			return [a];
		});
		bindCreate(ImageBatchs, function(xml:Xml):Array<Dynamic> {
			var a:Atlas = getBaseTextureAtlas(xml.get("src"));
			return [a];
		});
		bindCreate(BLabel, function(xml:Xml):Array<Dynamic> {
			var a:Atlas = getBaseTextureAtlas(xml.get("src"));
			return [a];
		});
		bindCreate(ZHaxe, function(xml:Xml):Array<Dynamic> {
			return [xml.firstChild().nodeValue];
		});
		bindCreate(ZShader, function(xml:Xml):Array<Dynamic> {
			return [xml];
		});
		bindCreate(ZInt, function(xml:Xml):Array<Dynamic> {
			return [Std.parseInt(xml.get("value"))];
		});
		bindCreate(ZFloat, function(xml:Xml):Array<Dynamic> {
			return [Std.parseFloat(xml.get("value"))];
		});
		bindCreate(ZBool, function(xml:Xml):Array<Dynamic> {
			return [(xml.get("value") == "true")];
		});
		bindCreate(ZString, function(xml:Xml):Array<Dynamic> {
			return [(xml.get("value"))];
		});
		bindCreate(ZTween, function(xml:Xml):Array<Dynamic> {
			return [xml];
		});

		#if (html5 && !final)
		// bindCreate(ZLabel, function(xml:Xml):Array<Dynamic> {
		// 	if (!xml.exists("height")) {
		// 		ZLog.warring("ZLabel应该包含height属性，避免布局计算存在误差问题:" + xml.toString());
		// 	}
		// 	return [];
		// });
		#end

		// 绑定添加
		bindAdd(zygame.display.batch.TouchImageBatchsContainer, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, zygame.display.batch.TouchImageBatchsContainer).getBatchs().addChild(obj);
		});
		bindAdd(BButton, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, BButton).box.addChild(obj);
		});
		bindAdd(BScale9Button, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, BScale9Button).box.addChild(obj);
		});
		bindAdd(ZButton, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, ZButton).box.addChild(obj);
		});
		bindAdd(VBBox, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, VBBox).addLayout(obj);
		});
		bindAdd(HBBox, function(obj:Dynamic, parent:Dynamic, xml:Xml):Void {
			cast(parent, HBBox).addLayout(obj);
		});

		// 绑定结束
		bindEnd(VBBox, function(obj:Dynamic):Void {
			cast(obj, VBBox).updateLayout();
		});
		bindEnd(HBBox, function(obj:Dynamic):Void {
			cast(obj, HBBox).updateLayout();
		});
		bindEnd(VBox, function(obj:Dynamic):Void {
			cast(obj, VBox).updateLayout();
		});
		bindEnd(HBox, function(obj:Dynamic):Void {
			cast(obj, HBox).updateLayout();
		});
		bindEnd(ZStack, function(obj:Dynamic):Void {
			@:privateAccess cast(obj, ZStack).updateDisplay();
		});
		bindEnd(BStack, function(obj:Dynamic):Void {
			@:privateAccess cast(obj, BStack).updateDisplay();
		});
	}

	private static function getDynamicTextureAtlas(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getDynamicTextureAtlas(value);
			if (atlas != null)
				return atlas;
		}
		return null;
	}

	/**
	 * 判断是否存在对应的zip资源包
	 * @param name 
	 * @param ext 
	 * @return ZAssets
	 */
	public static function getZipAssetsByExsit(name:String, type:String):ZAssets {
		for (assets in baseAssetsList) {
			if (assets.existZipAssets(name, type))
				return assets;
		}
		return null;
	}

	/**
	 * 判断png/xml等资源是否存在
	 * @param file 
	 * @return Bool
	 */
	public static function existFile(file:String):Bool {
		var type = StringUtils.getExtType(file);
		var filename = StringUtils.getName(file);
		for (assets in baseAssetsList) {
			switch (type) {
				case "png", "astc":
					var bitmap = assets.getBitmapData(filename);
					if (bitmap != null)
						return true;
				case "xml":
					if (assets.getXml(StringUtils.getName(file)) != null)
						return true;
			}
		}
		return false;
	}

	public static function getBaseObject(value:String):Dynamic {
		for (assets in baseAssetsList) {
			var data:Dynamic = assets.getObject(value);
			if (data != null)
				return data;
		}
		return null;
	}

	/**
	 * 创建Sprite渲染器的Spine骨骼
	 * @param atalsName
	 * @param skeletonJsonName
	 * @return spine.openfl.SkeletonAnimation
	 */
	public static function createSpineSpriteSkeleton(atalsName:String, skeletonJsonName:String):spine.openfl.SkeletonAnimation {
		var atlas:SpineTextureAtals = cast ZBuilder.getBaseTextureAtlas(atalsName);
		if (atlas == null)
			return null;
		if (ZBuilder.getBaseObject(skeletonJsonName) == null)
			throw "SkeletonJsonName " + skeletonJsonName + " is null.";
		return atlas.buildSpriteSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectJsonData(ZBuilder.getBaseObject(skeletonJsonName)));
	}

	public static function createSpineTilemapSkeleton(atalsName:String, skeletonJsonName:String):spine.tilemap.SkeletonAnimation {
		var atlas:SpineTextureAtals = cast ZBuilder.getBaseTextureAtlas(atalsName);
		if (atlas == null)
			return null;
		if (ZBuilder.getBaseObject(skeletonJsonName) == null)
			throw "SkeletonJsonName " + skeletonJsonName + " is null.";
		return atlas.buildTilemapSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectJsonData(ZBuilder.getBaseObject(skeletonJsonName)));
	}

	public static function getBaseTextureAtlas(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getTextureAtlas(value);
			if (atlas != null)
				return atlas;
		}
		var atlas = getFntData(value);
		if (atlas == null)
			atlas = getTextAtlas(value);
		if (atlas == null)
			atlas = getDynamicTextureAtlas(value);
		if (atlas == null)
			atlas = getSpineAtlas(value);
		if (atlas == null && useDefault)
			return defalutAssets.getTextureAtlas("ui");
		return atlas;
	}

	private static function getFntData(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getFntData(value);
			if (atlas != null)
				return atlas;
		}
		return null;
	}

	private static function getTextAtlas(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getTextAtlas(value);
			if (atlas != null)
				return atlas;
		}
		return null;
	}

	public static function getBaseSound(value:String):Sound {
		for (assets in baseAssetsList) {
			var sound = assets.getSound(value);
			if (sound != null)
				return sound;
		}
		return null;
	}

	public static function findById(b:Builder, id:String):Dynamic {
		if (b == null)
			return null;
		if (b.ids == null)
			return null;
		return b.ids.get(id);
	}

	private static function getSpineAtlas(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getSpineTextureAlats(value);
			if (atlas != null)
				return atlas;
		}
		return null;
	}

	private static function getXml(value:String):Xml {
		for (assets in baseAssetsList) {
			var xml:Xml = assets.getXml(value);
			if (xml != null)
				return xml;
		}
		return null;
	}

	/**
	 * 获取纹理图功能
	 * @return BitmapData
	 */
	public static function getBaseBitmapData(name:String):Dynamic {
		var bitmap:Dynamic = null;
		for (assets in baseAssetsList) {
			bitmap = assets.getBitmapData(name);
			if (bitmap != null)
				break;
		}
		return bitmap;
	}

	public static function getBaseXml(name:String):Xml {
		var xml:Xml = null;
		for (assets in baseAssetsList) {
			xml = assets.getXml(name);
			if (xml != null)
				break;
		}
		return xml;
	}

	/**
	 * 定义布局全局值
	 * @param defineName 定义名
	 * @param defineValue 定义的值字符串格式
	 */
	public static function defineValue(defineName:String, defineValue:String = null):Void {
		defineMaps.set(defineName, defineValue);
	}

	/**
	 * 删除定义全局值
	 * @param defineName
	 */
	public static function removeDefineValue(defineName:String):Void {
		defineMaps.remove(defineName);
	}

	/**
	 * 绑定资源
	 * @param assets
	 */
	public static function bindAssets(assets:ZAssets):Void {
		if (assets == null)
			return;
		if (baseAssetsList.indexOf(assets) == -1)
			baseAssetsList.push(assets);
	}

	/**
	 * xml样式功能
	 */
	private static var __xmlStyle:XmlStyle = new XmlStyle();

	/**
	 * 根据xml名称绑定样式
	 * @param name 
	 */
	public static function bindStyleByXml(name:String):Void {
		var xml = getXml(name);
		if (xml != null) {
			__xmlStyle.addXml(name, xml);
		}
	}

	/**
	 * 绑定样式
	 * @param styleName 
	 * @param data 
	 */
	public static function bindStyle(styleName:String, data:Dynamic):Void {
		//
	}

	/**
	 * 解除绑定资源
	 * @param assets
	 */
	public static function unbindAssets(assets:ZAssets):Void {
		baseAssetsList.remove(assets);
	}

	/**
	 * 获取基础的对象
	 * @return ZAssets
	 */
	@:deprecated("getBaseAssets 不再支持单个assets，允许绑定多个assets资源")
	public static function getBaseAssets():ZAssets {
		return null;
	}

	/**
	 * 绑定解析组件
	 * @param class
	 */
	public static function bind(obj:Dynamic):Void {
		var className:String = null;
		if (Std.isOfType(obj, String))
			className = obj;
		else
			className = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		classMaps.set(className, Std.isOfType(obj, String) ? Type.resolveClass(obj) : obj);
	}

	/**
	 * 绑定自定义构造参数
	 * @param obj
	 * @param fun
	 */
	public static function bindCreate(obj:Class<Dynamic>, fun:Xml->Array<Dynamic>):Void {
		var className:String = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		createMaps.set(className, fun);
	}

	/**
	 * 绑定结束后执行的内容
	 * @param obj
	 * @param fun
	 */
	public static function bindEnd(obj:Class<Dynamic>, fun:Dynamic->Void):Void {
		var className:String = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		endMaps.set(className, fun);
	}

	/**
	 * 绑定添加方式
	 * @param obj
	 * @param fun
	 */
	public static function bindAdd(obj:Class<Dynamic>, fun:Dynamic->Dynamic->Xml->Void):Void {
		var className:String = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		addMaps.set(className, fun);
	}

	/**
	 * 绑定解析处理
	 * @param obj
	 * @param key
	 * @param fun
	 */
	public static function bindParsing(obj:Dynamic, key:String, fun:Dynamic->String->String->Void):Void {
		var className:String = null;
		if (Std.isOfType(obj, String))
			className = obj;
		else
			className = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		parsingMaps.set(className + "." + key, fun);
	}

	/**
	 * 场景一个资源Bundler生成器
	 * @return AssetsBuilder
	 */
	public static function createAssetsBuilder(xmlPath:String, parent:Dynamic):AssetsBuilder {
		var a = new AssetsBuilder(xmlPath, parent);
		#if openfl_console
		Cc.watch(a, xmlPath);
		#end
		return a;
	}

	/**
	 * 缓存构建器数据
	 */
	public static var cacheBuilderData:Map<String, CacheBuilderData> = [];

	/**
	 * 直接查找绑定的资源，同时生成XML对象
	 * @param xmlfileName
	 * @param parent
	 * @return Builder
	 */
	public static function buildXmlUiFind(xmlfileName:String, parent:Dynamic):Builder {
		var xml = getXml(xmlfileName);
		if (xml == null)
			throw xmlfileName + "配置资源未加载";
		// 使用副本
		xml = Xml.parse(xml.toString());
		// var cache = cacheBuilderData.exists(xmlfileName) ? cacheBuilderData.get(xmlfileName).copy() : new CacheBuilderData();
		// TODO 如果这里做缓存，对界面存在一定的不兼容性
		var cache = null;
		var builder:Builder = new Builder();
		if (parent is IBuilder) {
			var map = cast(parent, IBuilder).onDefineValues();
			if (map != null)
				for (key => value in map) {
					builder.defineValue(key, value);
				}
		}

		#if zygameui15
		var parentXml:Xml = Reflect.getProperty(parent, "parentXml");
		if (parentXml != null) {
			// 需要绑定
			var fxml = xml.firstElement();
			for (key in parentXml.attributes()) {
				switch (key) {
					case "id", "centerX", "centerY", "left", "right", "bottom", "top", "y", "x", "scaleX", "scaleY", "width", "height", "alpha", "visible":
						continue;
				}
				fxml.set(key, parentXml.get(key));
			}
		}
		#end

		#if openfl_console
		Cc.watch(builder, xmlfileName);
		#end
		buildui(xml.firstElement(), parent, builder, null, null, null, cache);
		builder.bindBuilder();
		if (Std.isOfType(builder.display, BuilderRootDisplay)) {
			var root = cast(builder.display, BuilderRootDisplay);
			root.builder = builder;
			root.onInitBuilder();
		}
		if (cache != null) {
			cacheBuilderData.set(xmlfileName, cache);
			cache.record = false;
		}
		return builder;
	}

	/**
	 * 绑定资源，同时生成XML对象
	 * @param assets
	 * @param xmlfileName
	 * @param parent
	 * @return Buffer
	 */
	public static function buildXmlUI(assets:ZAssets, xmlfileName:String, parent:Dynamic):Builder {
		// 是否已经主动绑定在资源列表中，如果是，则一直保留在资源列表中，否则作为临时使用后移除。
		var isInAssets = baseAssetsList.indexOf(assets) != -1;
		if (!isInAssets)
			bindAssets(assets);
		var xml = assets.getXml(xmlfileName);
		var builder:Builder = new Builder();
		if (parent is IBuilder) {
			var map = cast(parent, IBuilder).onDefineValues();
			if (map != null)
				for (key => value in map) {
					builder.defineValue(key, value);
				}
		}
		buildui(xml.firstElement(), parent, builder);
		builder.bindBuilder();
		if (Std.isOfType(builder.display, BuilderRootDisplay)) {
			var root = cast(builder.display, BuilderRootDisplay);
			root.builder = builder;
			root.onInitBuilder();
		}
		if (!isInAssets)
			unbindAssets(assets);
		return builder;
	}

	/**
	 * 生成UI组件
	 * @param xml
	 * @return Dynamic
	 */
	public static function build(xml:Xml, parent:Dynamic = null, superInit:ZBuilder->Void = null, defalutArgs:Array<Dynamic> = null):Builder {
		var builder:Builder = new Builder();
		if (parent is IBuilder) {
			var map = cast(parent, IBuilder).onDefineValues();
			if (map != null)
				for (key => value in map) {
					builder.defineValue(key, value);
				}
		}
		buildui(xml.firstElement(), parent, builder, superInit, defalutArgs);
		builder.bindBuilder();
		if (Std.isOfType(builder.display, BuilderRootDisplay)) {
			var root = cast(builder.display, BuilderRootDisplay);
			root.builder = builder;
			root.onInitBuilder();
		}
		return builder;
	}

	private static function __getParentDefineValue(xml:Xml, value:String):String {
		if (value == null)
			return null;
		if (value.indexOf("::") == 0 && value.lastIndexOf("::") == value.length - 2) {
			var defineKey = StringTools.replace(value, "::", "");
			if (defineMaps.exists(defineKey))
				value = defineMaps.get(defineKey);
		} else if (value.indexOf("${") == 0 && value.lastIndexOf("}") == value.length - 1) {
			// 访问父节点的参数
			var parentKey = StringTools.replace(value, "${", "");
			parentKey = StringTools.replace(parentKey, "}", "");
			var parentXml = xml.parent;
			while (true) {
				if (parentXml.nodeType == Document)
					break;
				var parentValue = parentXml.get(parentKey);
				if (parentValue != null) {
					value = parentValue;
					break;
				}
				parentXml = parentXml.parent;
			}
		}
		return value;
	}

	/**
	 * 检测if和unless逻辑
	 * @param xml 
	 * @return Bool
	 */
	public static function checkIfUnless(xml:Xml, otherDefines:Map<String, String> = null):Bool {
		if (xml.exists("if")) {
			var isExists:Bool = false;
			var array:Array<String> = xml.get("if").split(" ");
			for (ifstr in array) {
				if (defineMaps.exists(ifstr) || (otherDefines != null && otherDefines.exists(ifstr))) {
					isExists = true;
					break;
				}
			}
			if (!isExists)
				return false;
		}
		if (xml.exists("unless")) {
			// 这里永远是或判断
			var isExists:Bool = false;
			var array:Array<String> = xml.get("unless").split(" ");
			for (ifstr in array) {
				if (defineMaps.exists(ifstr) || (otherDefines != null && otherDefines.exists(ifstr))) {
					isExists = true;
					break;
				}
			}
			if (isExists)
				return false;
		}
		return true;
	}

	/**
	 * 根据XML创建UI
	 * @param xml xml本体
	 * @param parent 添加父节点容器
	 * @param builder 
	 * @param superInit 
	 * @param defalutArgs 
	 * @param idpush ID追加
	 * @return Dynamic
	 */
	private static function buildui(xml:Xml, parent:Dynamic, builder:Builder, superInit:ZBuilder->Void = null, defalutArgs:Array<Dynamic> = null,
			idpush:String = null, cacheBuild:CacheBuilderData = null):Dynamic {
		if (defalutArgs == null)
			defalutArgs = [];
		// 定义判断
		if (xml.get("load") == "true") {
			// 如果存在load = true的情况下，意味着当前组件仅加载
			return null;
		}
		if (xml.exists("if")) {
			var isExists:Bool = false;
			var array:Array<String> = xml.get("if").split(" ");
			for (ifstr in array) {
				if (defineMaps.exists(ifstr) || @:privateAccess builder.defines.exists(ifstr)) {
					isExists = true;
					break;
				}
			}
			if (!isExists)
				return null;
		}
		if (xml.exists("unless")) {
			var isExists:Bool = false;
			var array:Array<String> = xml.get("unless").split(" ");
			for (ifstr in array) {
				if (defineMaps.exists(ifstr) || @:privateAccess builder.defines.exists(ifstr)) {
					isExists = true;
					break;
				}
			}
			if (isExists)
				return null;
		}
		// 模板功能
		if (xml.nodeName == "template") {
			// 需要将parent修改
			var bindName = xml.get("name");
			if (bindName != null) {
				parent = builder.ids.get(bindName);
				if (parent == null)
					return null;
			}
			for (item in xml.elements()) {
				buildui(item, parent, builder, superInit, defalutArgs, idpush);
			}
			return null;
		}

		__xmlStyle.apply(xml);
		var tween:String = null;
		var className:String = xml.nodeName;
		var childxml = getXml(className);
		if (childxml != null && childxml.firstElement().exists("classed")) {
			className = childxml.firstElement().get("classed");
		}
		var ui:Dynamic = null;
		var base:Class<Dynamic> = null;
		if (!classMaps.exists(className)) {
			base = Type.resolveClass(className);
		} else
			base = classMaps.get(className);
		if (base == null) {
			// 当无法找到类型时，可在XML中查找
			if (childxml != null) {
				var newchildxml = Xml.parse(childxml.toString());
				for (attr in xml.attributes()) {
					switch (attr) {
						case "id":
						default:
							newchildxml.firstElement().set(attr, xml.get(attr));
					}
				}
				ui = ZBuilder.buildui(newchildxml.firstElement(), parent, builder, null, null, xml.get("id"));
			} else if (xml.exists("extends")) {
				// 如果找不到的时候，会有一个默认的extends
				className = xml.get("extends");
				if (!classMaps.exists(className)) {
					base = Type.resolveClass(className);
				} else
					base = classMaps.get(className);
				#if igonre_extends_error
				if (base == null) {
					ui = new ZBox();
				} else {
					ui = Type.createInstance(base, createMaps.exists(className) ? createMaps.get(className)(xml) : defalutArgs);
				}
				#else
				if (base == null) {
					throw "Extends Class name " + className + " is not find!";
				}
				ui = Type.createInstance(base, createMaps.exists(className) ? createMaps.get(className)(xml) : defalutArgs);
				#end
			} else {
				#if !igonre_extends_error
				throw "Class name " + className + " is not define xml assets!";
				#else
				return null;
				#end
			}
		} else {
			ui = Type.createInstance(base, createMaps.exists(className) ? createMaps.get(className)(xml) : defalutArgs);
			try {
				Reflect.setProperty(ui, "parentXml", xml);
			} catch (e:Exception) {}
		}
		if (!Std.isOfType(ui, DisplayObject) && !Std.isOfType(ui, Tile)) {
			// 着色器
			if (Std.isOfType(ui, ZShader)) {
				try {
					if (Std.isOfType(parent, DisplayObject)) {
						cast(parent, DisplayObject).shader = ui;
					} else if (Std.isOfType(parent, Tile)) {
						cast(parent, Tile).shader = ui;
					}
				} catch (e:Exception) {
					ZLog.exception(e);
					if (Std.isOfType(parent, DisplayObject)) {
						cast(parent, DisplayObject).shader = null;
					} else if (Std.isOfType(parent, Tile)) {
						cast(parent, Tile).shader = null;
					}
				}
			}
			// 不是可视化对象
			var idname:String = xml.get("id");
			if (idname != null) {
				builder.ids.set((idpush != null ? idpush + "_" : "") + idname, ui);
				if (Std.isOfType(ui, ZHaxe)) {
					cast(ui, ZHaxe).bindBuilder(builder);
					if (idname == "super") {
						cast(ui, ZHaxe).call();
					} else if (xml.exists("args"))
						cast(ui, ZHaxe).argsName = xml.get("args").split(",");
				} else if (Std.isOfType(ui, ZTween)) {
					cast(ui, ZTween).bindBuilder(builder, idpush);
				}
			} else
				throw "Create " + className + " not define id.";
			if (builder.display == null) {
				builder.display = ui;
				// 继续编译
				var items:Iterator<Xml> = xml.elements();
				while (items.hasNext()) {
					var itemxml:Xml = items.next();
					buildui(itemxml, ui, builder, idpush);
				}
			}
			// 赋值处理
			for (name in xml.attributes()) {
				if (name == "id")
					continue;
				var value = xml.get(name);
				var att:Dynamic = getProperty(ui, name);
				var parsingName:String = className + "." + name;
				if (name == "tween") {
					// 过渡动画实现
				} else if (parsingMaps.exists(parsingName)) {
					parsingMaps.get(parsingName)(ui, name, value);
				} else if (Std.isOfType(att, Float) && value.indexOf("0x") == -1) {
					if (value.indexOf("%") != -1) {
						var bfb:Float = Std.parseFloat(value.substr(0, value.lastIndexOf("%")));
						bfb = bfb / 100 * getProperty(parent, name);
						setProperty(ui, name, bfb);
					} else
						setProperty(ui, name, Std.parseFloat(value));
				} else if (Std.isOfType(att, Int)) {
					setProperty(ui, name, Std.parseInt(value));
				} else if (Std.isOfType(att, Bool)) {
					setProperty(ui, name, xml.get(name) == "true");
				} else if (Std.isOfType(att, String) || att == null) {
					setProperty(ui, name, xml.get(name));
				}
			}
			return ui;
		}

		if (builder.display == null)
			builder.display = ui;

		var parentClassName:String = parent != null ? Type.getClassName(Type.getClass(parent)) : null;
		if (parentClassName != null)
			parentClassName = parentClassName.substr(parentClassName.lastIndexOf(".") + 1);
		if (parentClassName != null && addMaps.exists(parentClassName))
			addMaps.get(parentClassName)(ui, parent, xml);
		else if (Std.isOfType(parent, ImageBatchs))
			cast(parent, ImageBatchs).addChild(ui);
		else if (Std.isOfType(parent, DisplayObjectContainer))
			cast(parent, DisplayObjectContainer).addChild(ui);
		else if (Std.isOfType(parent, TileContainer)) {
			cast(parent, TileContainer).addTileAt(ui, cast(parent, TileContainer).numTiles);
		} else if (Std.isOfType(parent, Tilemap))
			cast(parent, Tilemap).addTile(ui);
		var attrIterator:Iterator<String> = xml.attributes();
		var attr:Array<String> = [];
		for (item in attrIterator) {
			attr.push(item);
		}
		attr.sort((a, b) -> return a == "text" || a == "src" ? 1 : -1);
		while (attr.length > 0) {
			var name:String = attr.shift();
			if (name == "id") {
				var idname = (idpush != null ? idpush + "_" : "") + xml.get(name);
				builder.ids.set(idname, ui);
				if (!xml.exists("name"))
					setProperty(ui, "name", xml.get(name));
				continue;
			}
			if (igone.indexOf(name) != -1)
				continue;
			var value:String = xml.get(name);
			// 宏定义值
			if (value != null) {
				value = __getParentDefineValue(xml, value);
			}

			var att:Dynamic = getProperty(ui, name);
			var parsingName:String = className + "." + name;
			if (name.indexOf(":") == 0) {
				// 访问当前Builder对象
				var nameKey = name.substr(1);
				#if hscript
				if (builder.display.parent != null) {
					var script = value;
					try {
						var hscript:Parser = new Parser();
						var interp:Interp = new Interp();
						var scripts = script.split(".");
						if (!builder.ids.exists(scripts[0])) {
							script = "this." + script;
							interp.variables.set("this", builder.display.parent);
						}
						for (key => value in builder.ids) {
							interp.variables.set(key, value);
						}
						var expr = hscript.parseString(script);
						var exprValue = interp.execute(expr);
						if (Reflect.isFunction(exprValue))
							setProperty(ui, nameKey, createCallFunc(builder.display.parent, exprValue, []));
						else
							setProperty(ui, nameKey, exprValue);
					} catch (e:Exception) {
						ZLog.error("Invalid expr '" + script + "'");
						ZLog.exception(e);
					}
				}
				#else
				if (builder.display.parent != null) {
					var v = Reflect.getProperty(builder.display.parent, value);
					if (Reflect.isFunction(v)) {
						setProperty(ui, nameKey, createCallFunc(builder.display.parent, v, []));
					} else {
						setProperty(ui, nameKey, v);
					}
				} else {
					setProperty(ui, nameKey, builder.ids.get(value));
				}
				#end
			} else if (name == "tween") {
				// 过渡动画实现
				tween = value;
			} else if (parsingMaps.exists(parsingName)) {
				parsingMaps.get(parsingName)(ui, name, value);
			} else if (Std.isOfType(att, Float) && value.indexOf("0x") == -1) {
				if (value.indexOf("%") != -1) {
					var bfb:Float = Std.parseFloat(value.substr(0, value.lastIndexOf("%")));
					bfb = bfb / 100 * getProperty(parent, name);
					setProperty(ui, name, bfb);
				} else
					setProperty(ui, name, Std.parseFloat(value));
			} else if (Std.isOfType(att, Int)) {
				setProperty(ui, name, Std.parseInt(value));
			} else if (Std.isOfType(att, Bool)) {
				setProperty(ui, name, xml.get(name) == "true");
			} else if (Std.isOfType(att, String) || att == null) {
				setProperty(ui, name, xml.get(name));
			}
		}
		try {
			// 对齐算法
			if (parent != null) {
				if (cacheBuild == null || cacheBuild.record) {
					align(ui, parent, xml.get("left"), xml.get("right"), xml.get("top"), xml.get("bottom"), xml.get("centerX"), xml.get("centerY"));
					if (cacheBuild != null)
						cacheBuild.addMatrix(ui);
				} else {
					cacheBuild.applyMatrix(ui);
				}
			}
		} catch (e:Exception) {
			throw "Align error:" + xml.toString() + " Exception:" + e.message + "\n" + e.stack.toString();
		}
		var items:Iterator<Xml> = xml.elements();
		while (items.hasNext()) {
			var itemxml:Xml = items.next();
			buildui(itemxml, ui, builder, null, null, idpush, cacheBuild);
		}
		if (endMaps.exists(className)) {
			endMaps.get(className)(ui);
		}
		#if !zide
		// 让父节点绑定当前容器的宽高
		if (xml.get("parentBind") == "true") {
			setProperty(parent, "width", getProperty(ui, "width"));
			setProperty(parent, "height", getProperty(ui, "height"));
		}
		#end
		// 对齐算法
		if (parent != null) {
			if (cacheBuild == null || cacheBuild.record) {
				align(ui, parent, xml.get("left"), xml.get("right"), xml.get("top"), xml.get("bottom"), xml.get("centerX"), xml.get("centerY"));
				if (cacheBuild != null)
					cacheBuild.addMatrix(ui);
			} else {
				cacheBuild.applyMatrix(ui);
			}
		}

		// 动画最后赋值实现
		if (tween != null) {
			var tweenXml = ZBuilder.getBaseXml(tween);
			if (tweenXml != null) {
				setProperty(ui, "tween", new ZTween(tweenXml));
			}
		}
		return ui;
	}

	private static function createCallFunc(target:Dynamic, func:Dynamic, args:Array<Dynamic>):Void->Void {
		return () -> {
			Reflect.callMethod(target, func, args);
		};
	}

	/**
	 * Align参数的百分比支持
	 * @return Int
	 */
	private static function alignPercentage(#if (cpp || hl) parent:Dynamic #else parent:DisplayObject #end, key:String, value:String):Int {
		if (value.indexOf("%") != -1) {
			// 百分比计算
			var parentValue:Float = cast getProperty(parent, key);
			return Std.int(Std.parseInt(StringTools.replace(value, "%", "")) / 100 * parentValue);
		}
		return Std.parseInt(value);
	}

	private static function align(#if (cpp || hl) obj:Dynamic, parent:Dynamic #else obj:DisplayObject, parent:DisplayObject #end, leftPx:Dynamic = null,
			rightPx:Dynamic = null, topPx:Dynamic = null, bottomPx:Dynamic = null, centerX:Dynamic = null, centerY:Dynamic = null):Void {
		if (Std.isOfType(leftPx, String))
			leftPx = alignPercentage(parent, "width", leftPx);
		if (Std.isOfType(rightPx, String))
			rightPx = alignPercentage(parent, "width", rightPx);
		if (Std.isOfType(topPx, String))
			topPx = alignPercentage(parent, "height", topPx);
		if (Std.isOfType(bottomPx, String))
			bottomPx = alignPercentage(parent, "height", bottomPx);
		if (Std.isOfType(centerX, String))
			centerX = alignPercentage(parent, "width", centerX);
		if (Std.isOfType(centerY, String))
			centerY = alignPercentage(parent, "height", centerY);

		var objWidth:Float = 0;
		var objHeight:Float = 0;
		var parentWidth:Float = 0;
		var parentHeight:Float = 0;

		// var bounds = obj.getBounds(obj.parent);
		// var objWidth:Float = getProperty(obj, "width");
		// var objHeight:Float = getProperty(obj, "height");
		// var parentWidth:Float = getProperty(parent, "width");
		// var parentHeight:Float = getProperty(parent, "height");
		if (leftPx != null && rightPx != null) {
			parentWidth = getProperty(parent, "width");
			setProperty(obj, "x", leftPx);
			setProperty(obj, "width", parentWidth - rightPx - leftPx);
		} else if (leftPx != null && centerX != null) {
			parentWidth = getProperty(parent, "width");
			setProperty(obj, "x", leftPx);
			setProperty(obj, "width", parentWidth / 2 + centerX - leftPx);
		} else if (rightPx != null && centerX != null) {
			parentWidth = getProperty(parent, "width");
			setProperty(obj, "x", parentWidth / 2 + centerX);
			setProperty(obj, "width", parentWidth / 2 - centerX - rightPx);
		} else if (leftPx != null)
			setProperty(obj, "x", leftPx);
		else if (rightPx != null) {
			objWidth = getProperty(obj, "width");
			parentWidth = getProperty(parent, "width");
			setProperty(obj, "x", parentWidth - rightPx - objWidth);
		} else if (centerX != null) {
			objWidth = getProperty(obj, "width");
			parentWidth = getProperty(parent, "width");
			setProperty(obj, "x", parentWidth / 2 + centerX - objWidth / 2);
		}

		if (topPx != null && bottomPx != null) {
			parentHeight = getProperty(parent, "height");
			setProperty(obj, "y", topPx);
			setProperty(obj, "height", parentHeight - topPx - bottomPx);
		} else if (topPx != null && centerY != null) {
			parentHeight = getProperty(parent, "height");
			setProperty(obj, "y", topPx);
			setProperty(obj, "height", parentHeight / 2 + centerY - topPx);
		} else if (bottomPx != null && centerY != null) {
			parentHeight = getProperty(parent, "height");
			setProperty(obj, "y", parentHeight / 2 + centerY);
			setProperty(obj, "height", parentHeight / 2 - bottomPx - centerY);
		} else if (topPx != null) {
			setProperty(obj, "y", topPx);
		} else if (bottomPx != null) {
			objHeight = getProperty(obj, "height");
			parentHeight = getProperty(parent, "height");
			setProperty(obj, "y", parentHeight - bottomPx - objHeight);
		} else if (centerY != null) {
			objHeight = getProperty(obj, "height");
			parentHeight = getProperty(parent, "height");
			setProperty(obj, "y", parentHeight / 2 + centerY - objHeight / 2);
		}
	}

	private static function setProperty(data:Dynamic, key:String, value:Dynamic):Void {
		#if html5
		if (untyped data["set_" + key] != null)
			untyped data["set_" + key](value);
		else
			untyped data[key] = value;
		#else
		#if (cpp || hl)
		try {
			Reflect.setProperty(data, key, value);
		} catch (e:Dynamic) {}
		#else
		Reflect.setProperty(data, key, value);
		#end
		#end
	}

	private static function getProperty(data:Dynamic, key:String):Dynamic {
		#if html5
		if (data == null) {
			throw "data is null,fieds is " + key;
		}
		if (untyped data["get_" + key] != null)
			return untyped data["get_" + key]();
		else
			return untyped data[key];
		#else
		return Reflect.getProperty(data, key);
		#end
	}
}

/**
 * 异步资源载入构造结果
 */
class AssetsBuilder extends Builder {
	/**
	 * AssetsBuilder请求超时设置，默认为不启动（-1）
	 * 如果需要超时处理，请设置`AssetsBuilder.defalutTimeout`，单位为秒。
	 */
	public static var defalutTimeout:Float = -1;

	/**
	 * 资源管理对象
	 */
	public var assets:ZAssets;

	/**
	 * 当前页面构造的路径
	 */
	public var viewXmlPath:String = null;

	private var _viewParent:Dynamic;

	/**
	 * 必须需要的资源列表
	 */
	public var needAssetsList:Map<String, Bool> = [];

	/**
	 * 解析必须需要的资源加载
	 * @param xml 
	 */
	private function parserNeedAssets(xml:Xml):Void {
		if (xml.nodeType == Document) {
			parserNeedAssets(xml.firstElement());
			return;
		}
		for (item in xml.elements()) {
			// 检查
			var id = null;
			if (item.exists("src")) {
				var src = item.get("src");
				if (src.indexOf(":") != -1) {
					// 精灵图
					id = src.split(":")[0];
				} else {
					// 单图
					id = src;
				}
			}
			if (ZBuilder.checkIfUnless(item, this.defines)) {
				needAssetsList.set(item.nodeName, true);
				needAssetsList.set(id, true);
			} else {
				if (id != null && !needAssetsList.exists(id)) {
					needAssetsList.set(id, false);
				}
			}
			parserNeedAssets(item);
		}
	}

	/**
	 * 是否需要加载此资源
	 * @param id 
	 * @return Bool
	 */
	private function hasLoad(id:String):Bool {
		var name = StringUtils.getName(id);
		if (needAssetsList.exists(name)) {
			if (!needAssetsList.get(name)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 预备构造xml时的处理，当设置此方法，允许在完成`ZBuilder.buildui`之前对XML配置进行修改，此方法会逐个将XML子对象返回：
	 * ```haxe
	 * this.buildXmlContent = function(xml){
	 * 	switch(xml.get("id")){
	 * 		case "a":
	 * 			xml.set("src","b");
	 *  }
	 * }
	 * ```
	 */
	public var buildXmlContent:Xml->Void;

	/**
	 * 该对象一般由ZBuilderScene自动构造，无需自已创建
	 * @param path 页面XML配置路径
	 * @param parent 绑定的构造对象
	 */
	public function new(path:String, parent:Dynamic) {
		super();
		viewXmlPath = path;
		_viewParent = parent;
		// 默认超时为15秒
		assets = new ZAssets();
		assets.timeout = defalutTimeout;
	}

	/**
	 * 加载资源列表，可以在ZBuilderScene.onLoad时机进行载入
	 * @param files 文件列表：png/json/xml/mp3等
	 * @return AssetsBuilder
	 */
	public function loadFiles(files:Array<String>):AssetsBuilder {
		assets.loadFiles(files);
		return this;
	}

	/**
	 * 加载精灵图，可以在ZBuilderScene.onLoad时机进行载入
	 * @param img 纹理图路径
	 * @param xml 纹理配置路径
	 * @param isAtf 是否为ATF纹理
	 * @return AssetsBuilder
	 */
	public function loadTextures(img:String, xml:String, isAtf:Bool = false):AssetsBuilder {
		assets.loadTextures(img, xml, isAtf);
		return this;
	}

	/**
	 * 加载Spine，可以在ZBuilderScene.onLoad时机进行载入
	 * @param pngs Spine图片路径列表
	 * @param atlas Spine纹理配置路径
	 * @return AssetsBuilder
	 */
	public function loadSpine(pngs:Array<String>, atlas:String):AssetsBuilder {
		assets.loadSpineTextAlats(pngs, atlas);
		return this;
	}

	/**
	 * 当需要尺寸自适配时触发
	 */
	public var onSizeChange:Dynamic;

	/**
	 * 是否停止构造XML上下文
	 */
	private var _stopBuildXmlContent:Bool = false;

	/**
	 * 停止构造XML上下文，当触发了这个方法后，`buildXmlContent`将停止工作。
	 */
	public function stopBuildXmlContent():Void {
		_stopBuildXmlContent = true;
	}

	private function _buildXmlContent(xml:Xml):Void {
		if (_stopBuildXmlContent)
			return;
		buildXmlContent(xml);
		for (item in xml.elements()) {
			_buildXmlContent(item);
		}
	}

	/**
	 * 准备载入的纹理资源
	 */
	public var readyTextures:Array<{
		png:String,
		xml:String
	}> = null;

	/**
	 * 准备载入的单资源配置
	 */
	public var readFiles:Array<String> = null;

	/**
	 * 准备载入的Spine资源
	 */
	public var readSpines:Array<{png:String, atlas:String}> = null;

	/**
	 * 开始构造当前页面内容
	 * @param cb 构造完成回调，其中布尔值会告知成功与失败
	 * @param onloaded 当资源加载完成提前回调，该时机在完成构造之前
	 */
	public function build(cb:Bool->Void, onloaded:Void->Void = null) {
		var isNewXmlPath = false;
		var existXml:Xml = null;
		if (!ZBuilder.existFile(viewXmlPath)) {
			isNewXmlPath = true;
			assets.loadFile(viewXmlPath);
		} else {
			existXml = ZBuilder.getBaseXml(StringUtils.getName(viewXmlPath));
		}
		if (isNewXmlPath) {
			assets.start((f) -> {
				if (f == 1) {
					// 资源加载完毕
					// 这里需要剔除不需要加载的资源，例如if unless
					buildAllAssets(isNewXmlPath, existXml, cb, onloaded);
				}
			});
		} else {
			buildAllAssets(isNewXmlPath, existXml, cb, onloaded);
		}
		return this;
	}

	private var __created:Bool = false;

	private function buildAllAssets(isNewXmlPath:Bool, existXml:Xml, cb:Bool->Void, onloaded:Void->Void = null):Void {
		var viewxml = assets.getXml(StringUtils.getName(viewXmlPath)) ?? existXml;
		if (viewxml == null) {
			ZLog.error("无法解析XML资源：" + viewXmlPath + ", 一般可能是加载此资源的时候`ZBuilder.existFile`判断存在，后被释放掉；同时可能是因为`ZBuilder.bindAssets`错误绑定的原因导致的错误。");
			cb(false);
			return;
		}
		this.parserNeedAssets(viewxml);
		if (readFiles != null)
			for (f in readFiles) {
				if (hasLoad(f) && !zygame.components.ZBuilder.existFile(f)) {
					this.loadFiles([f]);
				}
			}
		if (readSpines != null)
			for (s in readSpines) {
				if (hasLoad(s.png) && zygame.components.ZBuilder.getBaseTextureAtlas(zygame.utils.StringUtils.getName(s.png)) == null) {
					this.loadSpine([s.png], s.atlas);
				}
			}
		if (readyTextures != null)
			for (item in readyTextures) {
				if (hasLoad(item.png)
					&& zygame.components.ZBuilder.getBaseTextureAtlas(zygame.utils.StringUtils.getName(item.png)) == null)
					this.loadTextures(item.png, item.xml);
			}
		assets.start((f) -> {
			onProgress(f);
			if (f == 1) {
				if (__created) {
					throw "已经被创建过了！";
				}
				ZBuilder.bindAssets(assets);
				if (onloaded != null)
					onloaded();
				if (buildXmlContent != null) {
					// 使用一个全新的xml进行处理
					// if (!isNewXmlPath)
					viewxml = Xml.parse(viewxml.toString());
					_buildXmlContent(viewxml.firstElement());
				}
				// 分辨率自适配
				// 需要同时配置了hdwidth、hdheight值，会进行屏幕适配
				if (onSizeChange != null && viewxml.firstElement().exists("hdwidth") && viewxml.firstElement().exists("hdheight")) {
					// todo 是否需要兼容强制横幅、缩放取整支持
					onSizeChange(Std.parseFloat(viewxml.firstElement().get("hdwidth")), Std.parseFloat(viewxml.firstElement().get("hdheight")), true);
				}
				@:privateAccess ZBuilder.buildui(viewxml.firstElement(), _viewParent, this);
				__created = true;
				_viewParent = null;
				ZBuilder.unbindAssets(assets);
				cb(true);
			}
		}, (msg) -> {
			cb(false);
		});
	}

	/**
	 * 加载进度回调
	 * ```haxe
	 * builder.onProgress = function(f){
	 * 	if(f == 1){
	 * 		// ok
	 *  }
	 * }
	 * ```
	 * @param f 
	 */
	dynamic public function onProgress(f:Float):Void {}

	/**
	 * 释放
	 */
	override public function dispose():Void {
		super.dispose();
		if (assets == null)
			return;
		assets.unloadAll();
		assets = null;
	}
}

/**
 * 构造结果，可以在这里找到所有定义了id的角色对象
 */
class Builder {
	/**
	 * 构造成功的渲染对象
	 */
	public var display:Dynamic = null;

	/**
	 * 构造配置中的允许访问的id映射
	 */
	public var ids:Map<String, Dynamic>;

	/**
	 * 定义列表
	 */
	private var defines:Map<String, String> = [];

	/**
	 * 定义参数
	 * @param key 
	 * @param value 
	 */
	public function defineValue(key:String, ?value:String):Void {
		this.defines.set(key, value);
	}

	/**
	 * 取消定义
	 * @param key 
	 */
	public function undefine(key:String):Void {
		this.defines.remove(key);
	}

	/**
	 * 构造一个建造显示对象
	 */
	public function new() {
		ids = new Map();
	}

	/**
	 * 根据类型获取对象
	 * @param id 对象id
	 * @param type 对象类型
	 * @return T
	 */
	public function get<T:Dynamic>(id:String, type:Class<T>):Null<T> {
		return ids.get(id);
	}

	/**
	 * 可根据ID获取方法，如ZHaxe.call以及ZTween.play方法
	 * @param id 方法id
	 * @return Dynamic
	 */
	public function getFunction(id:String):Dynamic {
		var data:Dynamic = ids.get(id);
		if (Std.isOfType(data, ZHaxe))
			return cast(data, ZHaxe).call;
		if (Std.isOfType(data, ZTween))
			return cast(data, ZTween).play;
		return null;
	}

	/**
	 * 绑定创建器对象
	 */
	public function bindBuilder():Void {
		for (key => value in ids) {
			if (Std.isOfType(value, ZHaxe)) {
				cast(value, ZHaxe).bindBuilder(this);
			}
		}
	}

	/**
	 * 绑定Haxe方法映射
	 * @param func 方法名称
	 * @param data 方法调用
	 */
	public function variablesAllHaxe(func:String, data:Dynamic):Void {
		if (ids == null)
			return;
		for (key => value in ids) {
			#if hscript
			if (Std.isOfType(value, ZHaxe)) {
				cast(value, ZHaxe).interp.variables.set(func, data);
			}
			#end
		}
	}

	/**
	 * 绑定Haxe方法中使用的miniAssets资源对象
	 * @param miniAssets 内置mini引擎对象
	 */
	public function variablesAllHaxeBindMiniAssets(miniAssets:MiniEngineAssets):Void {
		if (ids == null)
			return;
		for (key => value in ids) {
			#if hscript
			if (Std.isOfType(value, ZHaxe)) {
				cast(value, ZHaxe).interp.miniAssets = miniAssets;
			}
			#end
		}
	}

	/**
	 * 释放当前建造对象
	 */
	public function dispose():Void {
		if (ids != null) {
			for (key => value in ids) {
				if (Std.isOfType(value, ZTween)) {
					cast(value, ZTween).stop();
				}
				if (Std.isOfType(value, ZImage)) {
					cast(value, ZImage).destroy();
				}
				if (Std.isOfType(value, ZSound)) {
					cast(value, ZSound).stop();
				}
			}
			// 如果这里不进行释放，是否可以解决空访问的问题
			// ids = null;
			// display = null;
		}
	}

	/**
	 * 释放当前建造对象的页面
	 */
	public function disposeView():Void {
		if (this.display != null && Std.isOfType(this.display, DisplayObject) && cast(this.display, DisplayObject).parent != null) {
			cast(this.display, DisplayObject).parent.removeChild(cast(this.display, DisplayObject));
		}
		this.dispose();
	}
}

/**
 * ZBuilder生成的root对象扩展基类
 * 使用`ZBuilder.build`生成时，当rootNode类型继承了`BuilderRootDisplay`时，会自动调用`onInitBuilder`方法以及builder属性。
 */
interface BuilderRootDisplay {
	/**
	 * 默认引用
	 */
	public var builder:Builder;

	/**
	 * ZBuilder完成后，触发的Builder事件，应从onInit转移到这里进行实现初始化逻辑
	 * @param builder
	 */
	public function onInitBuilder():Void;
}
