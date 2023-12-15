package zygame.macro;

import zygame.utils.ZLog;
#if macro
import sys.io.Process;
import sys.io.File;
import zygame.utils.StringUtils;
import sys.FileSystem;
#end

/**
 * zproject配置数据
 */
class ZProjectData {
	#if macro
	@:persistent public static var haxelibPath:Map<String, String> = [];

	public var assetsPath:Map<String, String> = [];
	public var assetsRenamePath:Map<String, String> = [];
	public var nowCwd:String = "";

	public function new() {
		var oldCwd = Sys.getCwd();
		var zprojectPath = createZProjectDataString();
		if (zprojectPath == null)
			return;
		// if (!FileSystem.exists(".macro")) {
		// 	FileSystem.createDirectory(".macro");
		// }
		nowCwd = Sys.getCwd();
		Sys.setCwd(oldCwd);
		this.readXml(nowCwd + "/" + zprojectPath, nowCwd);
	}

	public function readXml(xmlpath:String, rootPath:String):Void {
		var xml:Xml = Xml.parse(File.getContent(xmlpath));
		for (item in xml.firstElement().elements()) {
			switch (item.nodeName) {
				case "assets":
					if (item.get("unparser") == "true") {
						continue;
					}
					var dirPath = rootPath + item.get("path");
					var renameDirPath = item.exists("rename") ? item.get("rename") : StringUtils.getName(item.get("path"));
					readDir(dirPath, renameDirPath);
				case "include":
					if (item.get("bind") == "true") {
						var path = item.get("path");
						var parentPath = rootPath + path;
						parentPath = parentPath.substr(0, parentPath.lastIndexOf("/") + 1);
						if (FileSystem.exists(path))
							readXml(path, parentPath);
					}
				case "haxelib":
					if (item.get("bind") == "true") {
						if (!haxelibPath.exists(item.get("name"))) {
							var proess:Process = new Process("haxelib path " + item.get("name"));
							var proessData = proess.stdout.readAll().toString();
							haxelibPath.set(item.get("name"), StringTools.replace(proessData, "\n", " "));
							proess.kill();
						}
						var array = haxelibPath.get(item.get("name")).split(" ");
						var haxepath = null;
						for (s in array) {
							var low = s.toLowerCase();
							var lowlibname = item.get("name").toLowerCase();
							if (low.indexOf(lowlibname) != -1) {
								haxepath = s;
								break;
							}
						}
						ZLog.log("读取路径：" + haxepath + "../include.xml");
						readXml(haxepath + "../include.xml", haxepath + "../");
					}
			}
		}
	}

	public function createZProjectDataString():String {
		if (FileSystem.exists("zproject.xml"))
			return ("zproject.xml");
		if (FileSystem.exists("../zproject.xml")) {
			Sys.setCwd("../");
			return ("zproject.xml");
		}
		if (FileSystem.exists("../../zproject.xml")) {
			Sys.setCwd("../../");
			return ("zproject.xml");
		}
		if (FileSystem.exists("../../../zproject.xml")) {
			Sys.setCwd("../../../");
			return ("zproject.xml");
		}
		if (FileSystem.exists("../../../../zproject.xml")) {
			Sys.setCwd("../../../../");
			return ("zproject.xml");
		}
		return null;
	}

	public function readDir(path:String, rename:String):Void {
		if (path == "" || path == null)
			return;
		if (FileSystem.isDirectory(path)) {
			var dir:Array<String> = FileSystem.readDirectory(path);
			for (file in dir) {
				readDir(path + "/" + file, rename + "/" + file);
			}
		} else {
			var id = StringUtils.getName(path) + "." + StringUtils.getExtType(path);
			if (id.indexOf(".") != 0) {
				assetsRenamePath.set(id, rename);
				var curPath = assetsPath.get(id);
				if (assetsPath.exists(id) && curPath != path) {} else {
					assetsPath.set(id, path);
				}
			}
		}
	}
	#end
}
