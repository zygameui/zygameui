package zygame.macro;

import haxe.macro.Context;
import zygame.utils.StringUtils;

using StringTools;

/**
 * 通过预加载宏工具加载资源，可以自动识别页面所需的所有资源，无需再手动添加、分析页面所需的资源
 */
class ZAssetsUtils {
	#if macro
	private static function getAssetsData(path:String, xmlid:String, project:ZProjectData, ifUnless:Bool = false):{
		files:Array<String>,
		spines:Array<{
			png:String,
			json:String,
			atlas:String
		}>,
		textures:Array<{
			png:String,
			xml:String
		}>
	} {
		// 是一个XML配置，进行读取
		var builder:ZBuilderData = new ZBuilderData(path, project, ifUnless);
		var textures:Array<{png:String, xml:String}> = [];
		var spines:Array<{png:String, atlas:String, json:String}> = [];
		var files:Array<String> = [project.assetsRenamePath.get(StringUtils.getName(xmlid) + ".xml")];
		// 开始遍历所需资源
		for (file in builder.assetsLoads) {
			if (project.assetsPath.exists(file + ".png")
				&& project.assetsPath.exists(file + ".json")
				&& project.assetsPath.exists(file + ".atlas")) {
				spines.push({
					png: StringTools.replace(project.assetsRenamePath.get(file + ".png"), Sys.getCwd(), ""),
					atlas: StringTools.replace(project.assetsRenamePath.get(file + ".atlas"), Sys.getCwd(), ""),
					json: StringTools.replace(project.assetsRenamePath.get(file + ".json"), Sys.getCwd(), "")
				});
			} else if (project.assetsPath.exists(file + ".png") && project.assetsPath.exists(file + ".xml")) {
				textures.push({
					png: StringTools.replace(project.assetsRenamePath.get(file + ".png"), Sys.getCwd(), ""),
					xml: StringTools.replace(project.assetsRenamePath.get(file + ".xml"), Sys.getCwd(), "")
				});
			} else if (project.assetsPath.exists(file + ".png")) {
				// 单图加载
				files.push(StringTools.replace(project.assetsRenamePath.get(file + ".png"), Sys.getCwd(), ""));
				// 可能包含一个粒子资源
				if (project.assetsPath.exists(file + ".json")) {
					// JSON加载
					files.push(StringTools.replace(project.assetsRenamePath.get(file + ".json"), Sys.getCwd(), ""));
				}
			} else if (project.assetsPath.exists(file + ".jpg")) {
				// 单图加载
				files.push(StringTools.replace(project.assetsRenamePath.get(file + ".jpg"), Sys.getCwd(), ""));
			} else if (project.assetsPath.exists(file + ".xml")) {
				// 单XML加载
				files.push(StringTools.replace(project.assetsRenamePath.get(file + ".xml"), Sys.getCwd(), ""));
			} else if (project.assetsPath.exists(file + ".mp3")) {
				// 单MP3加载
				files.push(StringTools.replace(project.assetsRenamePath.get(file + ".mp3"), Sys.getCwd(), ""));
			}
		}
		return {
			files: files,
			spines: spines,
			textures: textures
		}
	}
	#end

	/**
	 * 预加载页面资源
	 * @param assets 资源载入器
	 * @param xmlid 页面文件名
	 * @param ifUnless 是否仅加载符合if、unless条件的资源，默认为`false`
	 * @return Dynamic
	 */
	macro public static function preload(assets:Dynamic, xmlid:String, ifUnless:Bool = false):Dynamic {
		var project:ZProjectData = AutoBuilder.firstProjectData;
		var path = project.assetsPath.get(StringUtils.getName(xmlid) + ".xml");
		if (path != null) {
			// 是一个XML配置，进行读取
			var config = getAssetsData(path, xmlid, project, ifUnless);
			return macro {
				for (item in $v{config.files}) {
					${assets}.loadFile(item);
				}
				for (item in $v{config.spines}) {
					${assets}.loadSpineTextAlats([item.png], item.atlas);
					${assets}.loadFiles([item.json]);
				}
				for (item in $v{config.textures}) {
					${assets}.loadTextures(item.png, item.xml);
				}
			}
		}
		return null;
	}

	/**
	 * 预加载页面资源
	 * @param assets 资源载入器
	 * @param xmlid 页面文件名
	 * @return Dynamic
	 */
	macro public static function remove(assets:Dynamic, xmlid:String):Dynamic {
		var project:ZProjectData = AutoBuilder.firstProjectData;
		var path = project.assetsPath.get(StringUtils.getName(xmlid) + ".xml");
		if (path != null) {
			// 是一个XML配置，进行读取
			var config = getAssetsData(path, xmlid, project);
			return macro {
				for (item in $v{config.files}) {
					if (StringTools.endsWith(item, ".png")) {
						${assets}.removeBitmapData(zygame.utils.StringUtils.getName(item));
					}
				}
				for (item in $v{config.spines}) {
					${assets}.removeSpineTextureAtlas(zygame.utils.StringUtils.getName(item.png));
				}
				for (item in $v{config.textures}) {
					${assets}.removeTextureAtlas(zygame.utils.StringUtils.getName(item.png));
				}
			}
		}
		return null;
	}
}
