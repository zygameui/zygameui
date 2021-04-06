package zygame.components;

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

		// 解析方法解析
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
			anData.fps.fps = Std.parseInt(value);
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
			anData.fps.fps = Std.parseInt(value);
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
			zygame.utils.Lib.nextFrameCall(cast(ui, ZButton).setText, [value]);
		});
		bindParsing(ZLabel, "stroke", function(ui:Dynamic, name:String, value:String):Void {
			cast(ui, ZLabel).stroke(Std.parseInt(value));
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
	}

	private static function getDynamicTextureAtlas(value:String):Atlas {
		for (assets in baseAssetsList) {
			var atlas:Atlas = assets.getDynamicTextureAtlas(value);
			if (atlas != null)
				return atlas;
		}
		return null;
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
		return atlas.buildSpriteSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectData(ZBuilder.getBaseObject(skeletonJsonName)));
	}

	public static function createSpineTilemapSkeleton(atalsName:String, skeletonJsonName:String):spine.tilemap.SkeletonAnimation {
		var atlas:SpineTextureAtals = cast ZBuilder.getBaseTextureAtlas(atalsName);
		if (atlas == null)
			return null;
		return atlas.buildTilemapSkeleton(skeletonJsonName, spine.utils.JSONVersionUtils.getSpineObjectData(ZBuilder.getBaseObject(skeletonJsonName)));
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
		// 不再支持缺省值功能
		// if (bitmap == null && useDefault) {
		// 	// 获取缺省值
		// 	if (Std.is(ui, BToggleButton) || Std.is(ui, ToggleButton))
		// 		return defalutAssets.getBitmapData("ui:button");
		// 	return defalutAssets.getBitmapData("ui:other");
		// }
		return bitmap;
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
		if (Std.is(obj, String))
			className = obj;
		else
			className = Type.getClassName(obj);
		className = className.substr(className.lastIndexOf(".") + 1);
		classMaps.set(className, Std.is(obj, String) ? Type.resolveClass(obj) : obj);
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
		if (Std.is(obj, String))
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
		return new AssetsBuilder(xmlPath, parent);
	}

	/**
	 * 直接查找绑定的资源，同时生成XML对象
	 * @param xmlfileName
	 * @param parent
	 * @return Builder
	 */
	public static function buildXmlUiFind(xmlfileName:String, parent:Dynamic):Builder {
		var xml = getXml(xmlfileName);
		if (xml == null)
			throw xmlfileName + "配置不存在";
		var builder:Builder = new Builder();
		buildui(xml.firstElement(), parent, builder);
		builder.bindBuilder();
		if (Std.is(builder.display, BuilderRootDisplay)) {
			var root = cast(builder.display, BuilderRootDisplay);
			root.builder = builder;
			root.onInitBuilder();
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
		buildui(xml.firstElement(), parent, builder);
		builder.bindBuilder();
		if (Std.is(builder.display, BuilderRootDisplay)) {
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
		buildui(xml.firstElement(), parent, builder, superInit, defalutArgs);
		builder.bindBuilder();
		if (Std.is(builder.display, BuilderRootDisplay)) {
			var root = cast(builder.display, BuilderRootDisplay);
			root.builder = builder;
			root.onInitBuilder();
		}
		return builder;
	}

	private static function __getParentDefineValue(xml:Xml, value:String):String {
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
			idpush:String = null):Dynamic {
		if (defalutArgs == null)
			defalutArgs = [];
		// 定义判断
		if (xml.exists("if")) {
			var isExists:Bool = false;
			var array:Array<String> = xml.get("if").split(" ");
			for (ifstr in array) {
				if (defineMaps.exists(ifstr)) {
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
				if (!defineMaps.exists(ifstr)) {
					isExists = true;
					break;
				}
			}
			if (!isExists)
				return null;
		}
		var className:String = xml.nodeName;
		var ui:Dynamic = null;
		var base:Class<Dynamic> = null;
		if (!classMaps.exists(className)) {
			base = Type.resolveClass(className);
		} else
			base = classMaps.get(className);
		if (base == null) {
			// 当无法找到类型时，可在XML中查找
			var childxml = getXml(className);
			if (childxml != null) {
				for (attr in xml.attributes()) {
					switch (attr) {
						case "id":
						default:
							childxml.firstElement().set(attr, xml.get(attr));
					}
				}
				ui = ZBuilder.buildui(childxml.firstElement(), parent, builder, null, null, xml.get("id"));
			} else
				throw "Class name " + className + " is not define xml assets!";
		} else {
			ui = Type.createInstance(base, createMaps.exists(className) ? createMaps.get(className)(xml) : defalutArgs);
		}
		if (!Std.is(ui, DisplayObject) && !Std.is(ui, Tile)) {
			// 着色器
			if (Std.is(ui, ZShader)) {
				try {
					if (Std.is(parent, DisplayObject)) {
						cast(parent, DisplayObject).shader = ui;
					} else if (Std.is(parent, Tile)) {
						cast(parent, Tile).shader = ui;
					}
				} catch (e:Exception) {
					trace("异常：", e.message + "\n" + e.stack);
					if (Std.is(parent, DisplayObject)) {
						cast(parent, DisplayObject).shader = null;
					} else if (Std.is(parent, Tile)) {
						cast(parent, Tile).shader = null;
					}
				}
			}
			// 不是可视化对象
			var idname:String = xml.get("id");
			if (idname != null) {
				builder.ids.set((idpush != null ? idpush + "_" : "") + idname, ui);
				if (Std.is(ui, ZHaxe)) {
					if (idname == "super") {
						cast(ui, ZHaxe).bindBuilder(builder);
						cast(ui, ZHaxe).call();
					} else if (xml.exists("args"))
						cast(ui, ZHaxe).argsName = xml.get("args").split(",");
				} else if (Std.is(ui, ZTween)) {
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
				if (parsingMaps.exists(parsingName)) {
					parsingMaps.get(parsingName)(ui, name, value);
				} else if (Std.is(att, Float) && value.indexOf("0x") == -1) {
					if (value.indexOf("%") != -1) {
						var bfb:Float = Std.parseFloat(value.substr(0, value.lastIndexOf("%")));
						bfb = bfb / 100 * getProperty(parent, name);
						setProperty(ui, name, bfb);
					} else
						setProperty(ui, name, Std.parseFloat(value));
				} else if (Std.is(att, Int)) {
					setProperty(ui, name, Std.parseInt(value));
				} else if (Std.is(att, Bool)) {
					setProperty(ui, name, xml.get(name) == "true");
				} else if (Std.is(att, String) || att == null) {
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
		else if (Std.is(parent, ImageBatchs))
			cast(parent, ImageBatchs).addChild(ui);
		else if (Std.is(parent, DisplayObjectContainer))
			cast(parent, DisplayObjectContainer).addChild(ui);
		else if (Std.is(parent, TileContainer)) {
			cast(parent, TileContainer).addTile(ui);
		} else if (Std.is(parent, Tilemap))
			cast(parent, Tilemap).addTile(ui);
		var attr:Iterator<String> = xml.attributes();
		while (attr.hasNext()) {
			var name:String = attr.next();
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
			if (parsingMaps.exists(parsingName)) {
				parsingMaps.get(parsingName)(ui, name, value);
			} else if (Std.is(att, Float) && value.indexOf("0x") == -1) {
				if (value.indexOf("%") != -1) {
					var bfb:Float = Std.parseFloat(value.substr(0, value.lastIndexOf("%")));
					bfb = bfb / 100 * getProperty(parent, name);
					setProperty(ui, name, bfb);
				} else
					setProperty(ui, name, Std.parseFloat(value));
			} else if (Std.is(att, Int)) {
				setProperty(ui, name, Std.parseInt(value));
			} else if (Std.is(att, Bool)) {
				setProperty(ui, name, xml.get(name) == "true");
			} else if (Std.is(att, String) || att == null) {
				setProperty(ui, name, xml.get(name));
			}
		}
		try {
			// 对齐算法
			if (parent != null)
				align(ui, parent, xml.get("left"), xml.get("right"), xml.get("top"), xml.get("bottom"), xml.get("centerX"), xml.get("centerY"));
		} catch (e:Exception) {
			throw "Align error:" + xml.toString() + " Exception:" + e.message + "\n" + e.stack.toString();
		}
		var items:Iterator<Xml> = xml.elements();
		while (items.hasNext()) {
			var itemxml:Xml = items.next();
			buildui(itemxml, ui, builder, idpush);
		}
		if (endMaps.exists(className)) {
			endMaps.get(className)(ui);
		}
		// 对齐算法
		if (parent != null)
			align(ui, parent, xml.get("left"), xml.get("right"), xml.get("top"), xml.get("bottom"), xml.get("centerX"), xml.get("centerY"));
		return ui;
	}

	private static function align(#if (cpp || hl) obj:Dynamic, parent:Dynamic #else obj:DisplayObject, parent:DisplayObject #end, leftPx:Dynamic = null,
			rightPx:Dynamic = null, topPx:Dynamic = null, bottomPx:Dynamic = null, centerX:Dynamic = null, centerY:Dynamic = null):Void {
		if (Std.is(leftPx, String))
			leftPx = Std.parseInt(leftPx);
		if (Std.is(rightPx, String))
			rightPx = Std.parseInt(rightPx);
		if (Std.is(topPx, String))
			topPx = Std.parseInt(topPx);
		if (Std.is(bottomPx, String))
			bottomPx = Std.parseInt(bottomPx);
		if (Std.is(centerX, String))
			centerX = Std.parseInt(centerX);
		if (Std.is(centerY, String))
			centerY = Std.parseInt(centerY);

		// var bounds = obj.getBounds(obj.parent);
		var objWidth:Float = getProperty(obj, "width");
		var objHeight:Float = getProperty(obj, "height");

		var parentWidth:Float = getProperty(parent, "width");
		var parentHeight:Float = getProperty(parent, "height");
		if (leftPx != null && rightPx != null) {
			setProperty(obj, "x", leftPx);
			setProperty(obj, "width", parentWidth - rightPx - leftPx);
		} else if (leftPx != null && centerX != null) {
			setProperty(obj, "x", leftPx);
			setProperty(obj, "width", parentWidth / 2 + centerX - leftPx);
		} else if (rightPx != null && centerX != null) {
			setProperty(obj, "x", parentWidth / 2 + centerX);
			setProperty(obj, "width", parentWidth / 2 - centerX - rightPx);
		} else if (leftPx != null)
			setProperty(obj, "x", leftPx);
		else if (rightPx != null)
			setProperty(obj, "x", parentWidth - rightPx - objWidth);
		else if (centerX != null)
			setProperty(obj, "x", parentWidth / 2 + centerX - objWidth / 2);

		if (topPx != null && bottomPx != null) {
			setProperty(obj, "y", topPx);
			setProperty(obj, "height", parentHeight - topPx - bottomPx);
		} else if (topPx != null && centerY != null) {
			setProperty(obj, "y", topPx);
			setProperty(obj, "height", parentHeight / 2 + centerY - topPx);
		} else if (bottomPx != null && centerY != null) {
			setProperty(obj, "y", parentHeight / 2 + centerY);
			setProperty(obj, "height", parentHeight / 2 - bottomPx - centerY);
		} else if (topPx != null) {
			setProperty(obj, "y", topPx);
		} else if (bottomPx != null)
			setProperty(obj, "y", parentHeight - bottomPx - objHeight);
		else if (centerY != null)
			setProperty(obj, "y", parentHeight / 2 + centerY - objHeight / 2);
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
		} catch (e:Dynamic) {
			// trace(data,"set fail:",key,value);
		}
		#else
		Reflect.setProperty(data, key, value);
		#end
		#end
	}

	private static function getProperty(data:Dynamic, key:String):Dynamic {
		#if html5
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
	public var assets:ZAssets = new ZAssets();

	public var viewXmlPath:String = null;

	private var _viewParent:Dynamic;

	public function new(path:String, parent:Dynamic) {
		super();
		viewXmlPath = path;
		_viewParent = parent;
	}

	public function loadFiles(files:Array<String>):AssetsBuilder {
		assets.loadFiles(files);
		return this;
	}

	public function loadTextures(img:String, xml:String, isAtf:Bool = false):AssetsBuilder {
		assets.loadTextures(img, xml, isAtf);
		return this;
	}

	public function loadSpine(pngs:Array<String>, atlas:String):AssetsBuilder {
		assets.loadSpineTextAlats(pngs, atlas);
		return this;
	}

	public function build(cb:Bool->Void, onloaded:Void->Void = null) {
		assets.loadFile(viewXmlPath);
		assets.start((f) -> {
			onProgress(f);
			if (f == 1) {
				ZBuilder.bindAssets(assets);
				if (onloaded != null)
					onloaded();
				@:privateAccess ZBuilder.buildui(assets.getXml(StringUtils.getName(viewXmlPath)).firstElement(), _viewParent, this);
				_viewParent = null;
				ZBuilder.unbindAssets(assets);
				cb(true);
			}
		}, (msg) -> {
			cb(false);
		});
		return this;
	}

	dynamic public function onProgress(f:Float):Void {}

	/**
	 * 释放
	 */
	override public function dispose():Void {
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
	public var display:Dynamic = null;

	public var ids:Map<String, Dynamic>;

	public function new() {
		ids = new Map();
	}

	/**
	 * 根据类型获取对象
	 * @param id
	 * @param type
	 * @return T
	 */
	public function get<T:Dynamic>(id:String, type:Class<T>):Null<T> {
		return ids.get(id);
	}

	/**
	 * 可根据ID获取方法，如ZHaxe.call以及ZTween.play方法
	 * @param id
	 * @return Dynamic
	 */
	public function getFunction(id:String):Dynamic {
		var data:Dynamic = ids.get(id);
		if (Std.is(data, ZHaxe))
			return cast(data, ZHaxe).call;
		if (Std.is(data, ZTween))
			return cast(data, ZTween).play;
		return null;
	}

	/**
	 * 绑定创建器对象
	 */
	public function bindBuilder():Void {
		for (key => value in ids) {
			if (Std.is(value, ZHaxe)) {
				cast(value, ZHaxe).bindBuilder(this);
			}
		}
	}

	/**
	 * 绑定Haxe方法映射
	 * @param key
	 * @param data
	 */
	public function variablesAllHaxe(func:String, data:Dynamic):Void {
		if (ids == null)
			return;
		for (key => value in ids) {
			#if hscript
			if (Std.is(value, ZHaxe)) {
				cast(value, ZHaxe).interp.variables.set(func, data);
			}
			#end
		}
	}

	/**
	 * 绑定Haxe方法中使用的miniAssets资源对象
	 * @param miniAssets
	 */
	public function variablesAllHaxeBindMiniAssets(miniAssets:MiniEngineAssets):Void {
		if (ids == null)
			return;
		for (key => value in ids) {
			#if hscript
			if (Std.is(value, ZHaxe)) {
				cast(value, ZHaxe).interp.miniAssets = miniAssets;
			}
			#end
		}
	}

	public function dispose():Void {
		if (ids != null) {
			for (key => value in ids) {
				if (Std.is(value, ZTween)) {
					cast(value, ZTween).stop();
				}
			}
			ids = null;
			display = null;
		}
	}

	public function disposeView():Void {
		if (this.display != null && Std.is(this.display, DisplayObject) && cast(this.display, DisplayObject).parent != null) {
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
