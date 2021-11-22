package zygame.macro;

import zygame.utils.StringUtils;

/**
 * 通过预加载宏工具加载资源，可以自动识别页面所需的所有资源，无需再手动添加、分析页面所需的资源
 */
class ZAssetsUtils {
	/**
	 * 预加载页面资源
	 * @param assets 资源载入器
	 * @param xmlid 页面文件名
	 * @return Dynamic
	 */
	macro public static function preload(assets:Dynamic, xmlid:String):Dynamic {
		var project:ZProjectData = AutoBuilder.firstProjectData;
		var path = project.assetsPath.get(StringUtils.getName(xmlid) + ".xml");
		if (path != null) {
			// 是一个XML配置，进行读取
			var builder:ZBuilderData = new ZBuilderData(path, project);
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
			return macro {
				for (item in $v{files}) {
					${assets}.loadFile(item);
				}
				for (item in $v{spines}) {
					${assets}.loadSpineTextAlats([item.png], item.atlas);
					${assets}.loadFiles([item.json]);
				}
				for (item in $v{textures}) {
					${assets}.loadTextures(item.png, item.xml);
				}
			}
		}
		return null;
	}
}
