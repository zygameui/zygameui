package zygame.macro;

import zygame.utils.StringUtils;
import haxe.macro.Context;
import haxe.macro.Expr;
#if macro
import sys.io.File;
#end
import haxe.Json;

/**
 * 自动构造JSON的属性访问关系
 */
class JSONData {
	/**
	 * 内嵌一个JSON动态类型，但不会进行解析类
	 * @param jsonPath 
	 */
	public macro static function embed(jsonPath:String) {
		var rootJsonPath = jsonPath;
		var project:ZProjectData = new ZProjectData();
		jsonPath = project.assetsPath.get(StringUtils.getName(jsonPath) + ".json");
		if (jsonPath == null)
			jsonPath = rootJsonPath;
		var data = File.getContent(jsonPath);
		return macro haxe.Json.parse($v{data});
	}

	/**
	 * 创建一个自定义JSON类型：{data:[obj,obj,obj]}，会自动解析第一层，以及数组的第二层数据
	 * @param jsonPath json文件路径
	 * @param indexNames 索引名，支持多索引名，可用于快速查找
	 * @param typeNames 类型名，可用于索引分类，一般用于相同ID的类型使用
	 */
	public macro static function create(jsonPath:String, indexNames:Array<String> = null, typeNames:Array<String> = null) {
		var rootJsonPath = jsonPath;
		var project:ZProjectData = new ZProjectData();
		jsonPath = project.assetsPath.get(StringUtils.getName(jsonPath) + ".json");
		if (jsonPath == null)
			jsonPath = rootJsonPath;
		var data:Json = Json.parse(File.getContent(jsonPath));
		var name = StringUtils.getName(jsonPath);
		var t = null;
		name = "AutoJson" + name.charAt(0).toUpperCase() + name.substr(1).toLowerCase();
		var c = macro class $name {
			public function new() {}
		}
		// doc文档
		var doc = Reflect.getProperty(data, "doc");
		var keys = Reflect.fields(data);
		for (index => value in keys) {
			if (value == "doc") // doc为动态文档，可过滤
				continue;
			var keyValue = Reflect.getProperty(data, value);
			var newField = null;
			if (Std.isOfType(keyValue, Array)) {
				var isDynamicArray:Bool = false;
				var arr:Array<Dynamic> = cast keyValue;
				for (index => value in arr) {
					if (!Std.isOfType(value, String)) {
						isDynamicArray = true;
						break;
					}
				}
				if (!isDynamicArray) {
					newField = {
						name: value,
						doc: null,
						meta: [],
						access: [APublic],
						kind: FVar(macro:Array<String>, macro $v{keyValue}),
						pos: Context.currentPos()
					};
				} else {
					var getData:Dynamic = keyValue[0];
					if (t == null)
						t = getType(getData, Context.currentPos(), doc);
					// 将数组储存
					newField = {
						name: value,
						doc: null,
						meta: [],
						access: [APublic],
						kind: FVar(macro:Array<$t>, macro $v{keyValue}),
						pos: Context.currentPos()
					};
					// 新增get{value}At(index)的方法，进行获取
					var funcName = "get" + value.charAt(0).toUpperCase() + value.substr(1).toLowerCase();
					// 通过索引获取，格式：get{属性名}By{索引名}
					if (indexNames != null) {
						for (indexName in indexNames) {
							var mapName = value + "_" + indexName + "_Maps";
							var getIndexMap = {
								name: mapName,
								doc: null,
								meta: [],
								access: [APrivate],
								kind: FVar(macro:Map<String, Dynamic>),
								pos: Context.currentPos()
							};
							c.fields.push(getIndexMap);
							var callName = funcName + "By" + indexName.charAt(0).toUpperCase() + indexName.substr(1).toLowerCase();
							var getIndexNamCall = {
								name: callName,
								doc: "根据" + indexName + "索引获取数据",
								meta: [],
								access: [APublic],
								kind: FFun({
									args: [{name: "name", type: macro:Dynamic}],
									ret: t,
									expr: macro {
										if (this.$mapName == null) {
											this.$mapName = [];
											var array:Array<Dynamic> = cast this.$value;
											for (item in array) {
												this.$mapName.set(Std.string(Reflect.getProperty(item, $v{indexName})), item);
											}
										}
										return this.$mapName.get(Std.string(name));
									}
								}),
								pos: Context.currentPos()
							};
							c.fields.push(getIndexNamCall);
						}
					}

					// 通过类型索引获取，格式：get{属性名}sBy{索引名}
					if (typeNames != null) {
						for (typeName in typeNames) {
							var mapName = value + "_" + typeName + "_TypeMaps";
							var getIndexMap = {
								name: mapName,
								doc: "根据" + typeName + "索引获取相同的数据列表",
								meta: [],
								access: [APrivate],
								kind: FVar(macro:Map<String, Array<$t>>),
								pos: Context.currentPos()
							};
							c.fields.push(getIndexMap);
							var callName = funcName + "ArrayBy" + typeName.charAt(0).toUpperCase() + typeName.substr(1).toLowerCase();
							var getIndexNamCall = {
								name: callName,
								doc: null,
								meta: [],
								access: [APublic],
								kind: FFun({
									args: [{name: "name", type: macro:Dynamic}],
									ret: macro:Array<$t>,
									expr: macro {
										if (this.$mapName == null) {
											this.$mapName = [];
											var array:Array<Dynamic> = cast this.$value;
											for (item in array) {
												var type:String = Reflect.getProperty(item, $v{typeName});
												var array:Array<$t> = this.$mapName.get(type);
												if (array == null) {
													array = [];
													this.$mapName.set(Std.string(type), array);
												}
												array.push(item);
											}
										}
										return this.$mapName.get(Std.string(name));
									}
								}),
								pos: Context.currentPos()
							};
							c.fields.push(getIndexNamCall);
						}
					}
				}
			} else {
				newField = {
					name: value,
					doc: null,
					meta: [],
					access: [APublic],
					kind: FVar(getType(keyValue, Context.currentPos(), doc), macro $v{keyValue}),
					pos: Context.currentPos()
				};
			}
			if (newField != null)
				c.fields.push(newField);
		}
		Context.defineType(c);
		var cls = {
			pack: [],
			name: name
		};
		return macro new $cls();
	}

	/**
	 * 获取类型
	 * @param value 
	 * @param pos 
	 * @return Dynamic
	 */
	static function getType(value:Dynamic, pos:Dynamic, doc:Dynamic):Dynamic {
		if (Std.isOfType(value, Bool))
			return macro:Bool;
		if (Std.isOfType(value, Int) || Std.isOfType(value, Float))
			return macro:Float;
		else if (Std.isOfType(value, Array)) {
			var v = value[0];
			var t = getType(v, pos, doc);
			return macro:Array<$t>;
		} else if (Std.isOfType(value, String))
			return macro:String;
		var args:Array<Field> = [];
		var keys = Reflect.fields(value);
		for (key in keys) {
			var kvalue = Reflect.getProperty(value, key);
			args.push({
				name: key,
				doc: doc != null ? Reflect.getProperty(doc, key) : null,
				meta: [],
				access: [APublic],
				kind: FVar(getType(kvalue, pos, doc)),
				pos: pos
			});
		}
		var t = TAnonymous(args);
		return macro:$t;
	}
}
