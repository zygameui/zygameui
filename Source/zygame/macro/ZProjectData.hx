package zygame.macro;

import haxe.Timer;
import haxe.Json;
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
	public var assetsPath:Map<String, String> = [];
	public var assetsRenamePath:Map<String, String> = [];
	public var nowCwd:String = "";

	public function new() {
		var oldCwd = Sys.getCwd();
		var zprojectPath = createZProjectDataString();
		if (zprojectPath == null)
			return;
		if (!FileSystem.exists(".macro")) {
			FileSystem.createDirectory(".macro");
		}

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
						readXml(path, parentPath);
					}
				case "haxelib":
					if (item.get("bind") == "true") {
						if (!FileSystem.exists(".macro")) {
							FileSystem.createDirectory(".macro");
						}
						if (!FileSystem.exists(".macro/" + item.get("name") + "_path")) {
							Sys.command("echo `haxelib path " + item.get("name") + "` > .macro/" + item.get("name") + "_path");
						}
						var array = File.getContent(".macro/" + item.get("name") + "_path").split(" ");
						var haxepath = null;
						for (s in array) {
							if (s.indexOf(item.get("name")) != -1) {
								haxepath = s;
								break;
							}
						}
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
				if (assetsPath.exists(id) && curPath != path) {
					// trace("File duplicate:" + path + " in (" + curPath + ")");
				} else {
					assetsPath.set(id, path);
				}
			}
		}
	}
	#end
}
