package pkg;

import sys.io.File;
import python.FileUtils;
import sys.FileSystem;

/**
 * 用于生成依赖多xml的project.xml，将它所有的配置变成一个独立的包，便于一次性打包实现。
 */
class PkgTools {
	public static function build():Void {
		trace("打包参数：", Sys.args());
		var projectDir = Sys.args()[1];
		var path = projectDir + "/zproject.xml";
		if (!FileSystem.exists(path))
			throw "项目不存在zproject.xml";
		// 开始创建项目包
		var pkgDir = projectDir + "/Export/pkg";
		FileUtils.removeDic(pkgDir);
		FileUtils.createDir(pkgDir);
		// 开始解析zproject.xml
		var zproject = new ZProjectData(path);
		File.saveContent(pkgDir + "/zproject.xml", "<project><haxedef name='pkgtools'/>" + zproject.getData() + "</project>");
		// 分析资源并拷贝
		copyAssets(zproject);
		// 分析模板
		copyTemplate(zproject);
		// 分析包绑定
		copyPkg(zproject);
		// 分析代码并拷贝
		copySource(zproject);
	}

	/**
	 * 将配置中所需要的资源全部拷贝
	 * @param zproject 
	 */
	private static function copyPkg(zproject:ZProjectData):Void {
		var projectDir = Sys.args()[1];
		for (obj in zproject.pkgBind) {
			trace("Pkg:" + obj.path);
			if (FileSystem.isDirectory(obj.path)) {
				var files = FileSystem.readDirectory(obj.path);
				for (file in files) {
					if (FileSystem.isDirectory(obj.path + "/" + file))
						FileUtils.copyDic(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo);
					else
						FileUtils.copyFile(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo + "/" + file);
				}
			} else {
				FileUtils.copyFile(obj.path, projectDir + "/Export/pkg/" + obj.copyTo);
			}
			trace(projectDir + "/" + obj.copyTo);
		}
		for (i in zproject.includes) {
			copyPkg(i);
		}
	}

	/**
	 * 将配置中所需要的资源全部拷贝
	 * @param zproject 
	 */
	private static function copyTemplate(zproject:ZProjectData):Void {
		var projectDir = Sys.args()[1];
		for (obj in zproject.templateBind) {
			trace("Template:" + obj.path);
			if (FileSystem.isDirectory(obj.path)) {
				var files = FileSystem.readDirectory(obj.path);
				for (file in files) {
					if (FileSystem.isDirectory(obj.path + "/" + file))
						FileUtils.copyDic(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo);
					else
						FileUtils.copyFile(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo + "/" + file);
				}
			} else {
				FileUtils.copyFile(obj.path, projectDir + "/Export/pkg/" + obj.copyTo);
			}
			trace(projectDir + "/" + obj.copyTo);
		}
		for (i in zproject.includes) {
			copyTemplate(i);
		}
	}

	private static function copySource(zproject:ZProjectData):Void {
		var projectDir = Sys.args()[1];
		for (obj in zproject.sourceBind) {
			trace("Source:" + obj.path);
			if (FileSystem.isDirectory(obj.path)) {
				var files = FileSystem.readDirectory(obj.path);
				for (file in files) {
					if (FileSystem.isDirectory(obj.path + "/" + file))
						FileUtils.copyDic(obj.path + "/" + file, projectDir + "/Export/pkg/source");
					else
						FileUtils.copyFile(obj.path + "/" + file, projectDir + "/Export/pkg/source" + "/" + file);
				}
			} else {
				FileUtils.copyFile(obj.path, projectDir + "/Export/pkg/source");
			}
		}
		for (i in zproject.includes) {
			copySource(i);
		}
	}

	/**
	 * 将配置中所需要的资源全部拷贝
	 * @param zproject 
	 */
	private static function copyAssets(zproject:ZProjectData):Void {
		var projectDir = Sys.args()[1];
		for (obj in zproject.assetsBind) {
			trace("Assets:" + obj.path);
			if (FileSystem.isDirectory(obj.path)) {
				var files = FileSystem.readDirectory(obj.path);
				for (file in files) {
					if (FileSystem.isDirectory(obj.path + "/" + file))
						FileUtils.copyDic(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo);
					else
						FileUtils.copyFile(obj.path + "/" + file, projectDir + "/Export/pkg/" + obj.copyTo + "/" + file);
				}
			} else {
				FileUtils.copyFile(obj.path, projectDir + "/Export/pkg/" + obj.copyTo);
			}
			trace(projectDir + "/" + obj.copyTo);
		}
		for (i in zproject.includes) {
			copyAssets(i);
		}
	}
}
