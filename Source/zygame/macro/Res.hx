package zygame.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

class Res {
	macro public static function init():Array<Field> {
		var c = macro class R {
			public function new() {}
		}
		var number:String = "0123456789.";
		var ext:Array<String> = ["png", "jpg", "xml", "json"];
		var project = AutoBuilder.firstProjectData;
		var atlas:Map<String, {name:String, png:String, xml:String}> = [];
		var maps:Map<String, Array<{name:String, rpath:String}>> = [];
		for (key => value in project.assetsPath) {
			var valueKey = StringTools.replace(key, "-", "_");
			var array = valueKey.split(".");
			if (number.indexOf(key.charAt(0)) != -1 || ext.indexOf(array[1]) == -1)
				continue;
			if (project.assetsPath.exists(array[0] + ".xml") && project.assetsPath.exists(array[0] + ".png")) {
				// 精灵图解析
				if (!atlas.exists(array[0])) {
					atlas.set(array[0], {
						name: array[0],
						png: project.assetsRenamePath.get(array[0] + ".png"),
						xml: project.assetsRenamePath.get(array[0] + ".xml")
					});
				}
			} else {
				// 普通文件解析
				var values = maps.get(array[1]);
				if (values == null) {
					values = [];
					maps.set(array[1], values);
				}
				values.push({
					name: array[0],
					rpath: project.assetsRenamePath.get(key)
				});
			}
		}

		// 精灵表
		var args:Array<Field> = [];
		var atlasObject:Dynamic = {};
		for (key => value in atlas) {
			var kvalue = Reflect.getProperty(value, key);
			args.push({
				name: value.name,
				doc: null,
				meta: [],
				access: [APublic],
				kind: FVar(macro:{name:String, png:String, xml:String}),
				pos: Context.currentPos()
			});
			Reflect.setProperty(atlasObject, value.name, value);
		}
		var t = TAnonymous(args);
		c.fields.push({
			name: "atlas",
			doc: null,
			meta: [],
			access: [APublic, AStatic],
			kind: FVar(t, macro $v{atlasObject}),
			pos: Context.currentPos()
		});
		// 普通文件
		for (key => value in maps) {
			var args:Array<Field> = [];
			var keys = value;
			var obj:Dynamic = {};
			for (index in keys) {
				var kvalue = Reflect.getProperty(value, key);
				args.push({
					name: index.name,
					doc: null,
					meta: [],
					access: [APublic],
					kind: FVar(macro:{name:String, url:String}),
					pos: Context.currentPos()
				});
				Reflect.setProperty(obj, index.name, {
					name: index.name,
					url: index.rpath
				});
			}
			var t = TAnonymous(args);
			c.fields.push({
				name: key,
				doc: null,
				meta: [],
				access: [APublic, AStatic],
				kind: FVar(t, macro $v{obj}),
				pos: Context.currentPos()
			});
		}
		Context.defineType(c);
		return Context.getBuildFields();
	}
}
