package zygame.macro;

import zygame.utils.ZLog;
import haxe.Exception;
#if macro
import haxe.Timer;
import haxe.macro.ExprTools;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import zygame.utils.StringUtils;
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * 为ZBuilderScene以及任何类中在onInit自动创建布局，在ZBuilderScene对象下，会创建异步加载流程访问；而在其他类会默认同步访问。
 */
class AutoBuilder {
	#if macro
	@:persistent public static var firstProjectData(get, never):ZProjectData;
	@:persistent private static var _firstProjectData:ZProjectData;

	/**
	 * 缓存字段处理，当发生文件时间变更时，则更新
	 */
	@:persistent private static var _cacheFields:Map<String, {
		mtime:Float,
		isCreateInit:Bool,
		fields:Array<Field>
	}> = [];

	static function get_firstProjectData():ZProjectData {
		if (_firstProjectData == null) {
			_firstProjectData = new ZProjectData();
		}
		return _firstProjectData;
	}

	/**
	 * 自动构造
	 * @param xmlPath
	 * @param bindBuilder
	 * @param embed 是否资源嵌入
	 * @return Array<Field>
	 */
	macro public static function build(xmlPath:String, bindBuilder:String = null, embed:Bool = false, ?builderXmlPathExpr:Expr):Array<Field> {
		var project:ZProjectData = firstProjectData;
		var path = project.assetsPath.get(StringUtils.getName(xmlPath) + ".xml");
		if (path == null) {
			throw "Xml file '" + xmlPath + "' is not exists!";
		}

		// trace("parseing ", xmlPath);
		if (_cacheFields.exists(xmlPath)) {
			var cache = _cacheFields.get(xmlPath);
			var time = FileSystem.stat(path);
			if (cache.mtime == time.mtime.getTime()) {
				var fields = Context.getBuildFields();
				if (cache.isCreateInit) {
					var inits = fields.filter(f -> f.name == "onInit");
					if (inits.length > 0) {
						inits[0].access = [APrivate];
						inits[0].name = "onInitCreated";
					}
				}
				return fields.concat(cache.fields);
			}
		}

		var fields = Context.getBuildFields();

		var cacheFields = new Array<Field>();

		var builder:ZBuilderData = new ZBuilderData(path, project);

		bindBuilder = bindBuilder == null ? "assetsBuilder" : bindBuilder;

		var superClass:String = Context.getLocalClass().get().superClass.t.toString();
		// 是否为ZBuilderScene构造
		var isZBuilderScene:Bool = superClass == "zygame.components.ZBuilderScene";
		if (!isZBuilderScene) {
			superClass = Context.getLocalClass().get().superClass.t.get().superClass.t.toString();
			isZBuilderScene = superClass == "zygame.components.ZBuilderScene";
		}

		// 路径移除
		path = StringTools.replace(project.getAssetsRenamePath(StringUtils.getName(xmlPath) + ".xml"), Sys.getCwd(), "");
		var textures:Array<{png:String, xml:String}> = [];
		var spines:Array<{png:String, atlas:String}> = [];
		var files:Array<String> = [];

		// 开始遍历所需资源
		for (file in builder.assetsLoads) {
			if (project.assetsPath.exists(file + ".png") && project.assetsPath.exists(file + ".atlas")) {
				spines.push({
					png: StringTools.replace(project.getAssetsRenamePath(file + ".png"), Sys.getCwd(), ""),
					atlas: StringTools.replace(project.getAssetsRenamePath(file + ".atlas"), Sys.getCwd(), "")
				});
				if (project.assetsPath.exists(file + ".json")) {
					files.push(StringTools.replace(project.getAssetsRenamePath(file + ".json"), Sys.getCwd(), ""));
				}
			} else if (project.assetsPath.exists(file + ".png") && project.assetsPath.exists(file + ".xml")) {
				textures.push({
					png: StringTools.replace(project.getAssetsRenamePath(file + ".png"), Sys.getCwd(), ""),
					xml: StringTools.replace(project.getAssetsRenamePath(file + ".xml"), Sys.getCwd(), "")
				});
			} else if (project.assetsPath.exists(file + ".png")) {
				// 单图加载
				files.push(StringTools.replace(project.getAssetsRenamePath(file + ".png"), Sys.getCwd(), ""));
				// 可能包含一个粒子资源
				if (project.assetsPath.exists(file + ".json")) {
					// JSON加载
					files.push(StringTools.replace(project.getAssetsRenamePath(file + ".json"), Sys.getCwd(), ""));
				}
			} else if (project.assetsPath.exists(file + ".jpg")) {
				// 单图加载
				files.push(StringTools.replace(project.getAssetsRenamePath(file + ".jpg"), Sys.getCwd(), ""));
			} else if (project.assetsPath.exists(file + ".xml")) {
				// 单XML加载
				files.push(StringTools.replace(project.getAssetsRenamePath(file + ".xml"), Sys.getCwd(), ""));
			}
			if (project.assetsPath.exists(file + ".json")) {
				// 单JSON加载
				files.push(StringTools.replace(project.getAssetsRenamePath(file + ".json"), Sys.getCwd(), ""));
			} else if (project.assetsPath.exists(file + ".mp3")) {
				// 单MP3加载
				files.push(StringTools.replace(project.getAssetsRenamePath(file + ".mp3"), Sys.getCwd(), ""));
			}
		}

		var isCreateInit:Bool = false;

		if (!isZBuilderScene && bindBuilder == "assetsBuilder") {
			for (f in fields) {
				if (f.name == "onInit") {
					isCreateInit = true;
					f.access = [APrivate];
					f.name = "onInitCreated";
					break;
				}
			}
			var assetsBuilder = {
				name: bindBuilder,
				doc: null,
				meta: [],
				access: [APublic],
				kind: FVar(macro :zygame.components.ZBuilder.Builder),
				pos: Context.currentPos()
			}
			cacheFields.push(assetsBuilder);
		}

		// 需要额外新增一个parentXml的属性，来绑定父节点参数
		var parentXml:Field = {
			name: "parentXml",
			doc: "当通过`AutoBuilder`构造的UI架构，都会附带一个parentXml，当该对象不为null时，则会将该对象的属性继承到当前组件中",
			access: [APublic],
			kind: FVar(macro :Xml),
			pos: Context.currentPos()
		}

		var exprValue = ExprTools.toString(builderXmlPathExpr);

		var builderXmlPath:Field = {
			name: "builderXmlPath",
			doc: "当通过`AutoBuilder`构造的UI架构，都会附带builerXmlPath，可以修改builerXmlPath属性，更改加载的创建的布局的实现",
			access: [APublic],
			kind: exprValue != "null" ? FVar(macro :String, builderXmlPathExpr) : FVar(macro :String, macro $v{path}),
			pos: Context.currentPos()
		}

		cacheFields.push(parentXml);
		cacheFields.push(builderXmlPath);

		if (bindBuilder == "assetsBuilder") {
			var autoNewBuilder = {
				name: isZBuilderScene ? "new" : "onInit",
				doc: null,
				meta: [],
				access: isZBuilderScene ? [APublic] : [APublic, AOverride],
				kind: FFun({
					args: [],
					ret: macro :Void,
					expr: isZBuilderScene ? macro {
						super(builderXmlPath);
						this.$bindBuilder.readyTextures = $v{textures};
						this.$bindBuilder.readFiles = $v{files};
						this.$bindBuilder.readSpines = $v{spines};
					} : isCreateInit ? macro {
						super.onInit();
						if ($v{embed}) {
							this.$bindBuilder = zygame.components.ZBuilder.build(Xml.parse($v{builder.content}), this);
						} else {
							this.$bindBuilder = zygame.components.ZBuilder.buildXmlUiFind(zygame.utils.StringUtils.getName(builderXmlPath), this);
						}
						this.onInitCreated();
					} : macro {
						super.onInit();
						if ($v{embed}) {
							this.$bindBuilder = zygame.components.ZBuilder.build(Xml.parse($v{builder.content}), this);
						} else {
							this.$bindBuilder = zygame.components.ZBuilder.buildXmlUiFind(zygame.utils.StringUtils.getName(builderXmlPath), this);
						}
					}
				}),
				pos: Context.currentPos()
			};
			cacheFields.push(autoNewBuilder);
		}

		// 追加属性创建
		for (key => value in builder.ids) {
			if (project.assetsPath.exists(value + ".xml")) {
				// XML定义
				var nodexml:Xml = Xml.parse(File.getContent(project.assetsPath.get(value + ".xml")));
				createGetCall(cacheFields, key, nodexml.firstElement().nodeName, bindBuilder);
			} else
				createGetCall(cacheFields, key, value, bindBuilder);
		}

		// 缓存处理
		try {
			var time = FileSystem.stat(path);
			_cacheFields.set(xmlPath, {
				mtime: time.mtime.getTime(),
				isCreateInit: isCreateInit,
				fields: cacheFields
			});
		} catch (e:Exception) {
			ZLog.exception(e);
		}
		return fields.concat(cacheFields);
	}

	public static function getType(typeName:String):Dynamic {
		if (typeName.indexOf(".") != -1) {
			var pkg = typeName.split(".");
			return TPath({
				pack: pkg.slice(0, pkg.length - 1),
				name: pkg[pkg.length - 1]
			});
		} else if (typeName == "VBox" || typeName == "HBox") {
			switch (typeName) {
				case "VBox":
					return macro :zygame.components.ZBox.VBox;
				case "HBox":
					return macro :zygame.components.ZBox.HBox;
			}
		} else if (typeName.indexOf("F") == 0) {
			return TPath({
				pack: ["zygame", "feathersui"],
				name: typeName
			});
		} else if (typeName.indexOf("Z") != -1) {
			if (typeName == "ZHaxe") {
				return TPath({
					pack: ["zygame", "script"],
					name: typeName
				});
			}
			if (typeName == "ZShader") {
				return TPath({
					pack: ["zygame", "shader", "engine"],
					name: typeName
				});
			}
			return TPath({
				pack: ["zygame", "components"],
				name: typeName
			});
		} else if (typeName.indexOf("ImageBatchs") != -1 || typeName.indexOf("B") != -1) {
			if (typeName == "BScale9Button")
				return macro :zygame.display.batch.BButton.BScale9Button;
			else if (typeName == "HBBox")
				return macro :zygame.display.batch.BBox.HBBox;
			else if (typeName == "VBBox")
				return macro :zygame.display.batch.BBox.VBBox;
			else
				return TPath({
					pack: ["zygame", "display", "batch"],
					name: typeName
				});
		}
		return null;
	}

	public static function createGetCall(fields:Array<Field>, id:String, type:String, buildAttr):Void {
		var t = getType(type);
		var myFunc:Function = {
			expr: macro return zygame.components.ZBuilder.findById(this.$buildAttr, ($v{id})),
			// expr: macro return (this.$buildAttr == null || this.$buildAttr.ids == null) ? null : this.$buildAttr.ids.get($v{id}), // actual value
			ret: t, // ret = return type
			args: [] // no arguments here
		}
		var propertyField:Field = {
			name: id,
			meta: [
				{
					name: ":keep",
					pos: Context.currentPos()
				}
			],
			access: [Access.APublic],
			kind: FieldType.FProp("get", "null", myFunc.ret),
			pos: Context.currentPos()
		};
		// create: `private inline function get_$fieldName() return $value`
		var getterField:Field = {
			name: "get_" + id,
			meta: [
				{
					name: ":keep",
					pos: Context.currentPos()
				}
			],
			access: [Access.APrivate, Access.AInline],
			kind: FieldType.FFun(myFunc),
			pos: Context.currentPos()
		};

		// append both fields
		fields.push(propertyField);
		fields.push(getterField);
	}
	#end
}
