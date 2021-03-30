package zygame.macro;

#if macro
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
		var zprojectData = createZProjectDataString();
		if (zprojectData == null)
			return;
		nowCwd = Sys.getCwd();
		Sys.setCwd(oldCwd);
		var xml:Xml = Xml.parse(zprojectData);
		for (item in xml.firstElement().elements()) {
			switch (item.nodeName) {
				case "assets":
					if (item.get("unparser") == "true")
						continue;
					readDir(nowCwd + item.get("path"), item.exists("rename") ? item.get("rename") : StringUtils.getName(item.get("path")));
			}
		}
	}

	public function createZProjectDataString():String {
		if (FileSystem.exists("zproject.xml"))
			return File.getContent("zproject.xml");
		if (FileSystem.exists("../zproject.xml")) {
			Sys.setCwd("../");
			return File.getContent("zproject.xml");
		}
		if (FileSystem.exists("../../zproject.xml")) {
			Sys.setCwd("../../");
			return File.getContent("zproject.xml");
		}
		if (FileSystem.exists("../../../zproject.xml")) {
			Sys.setCwd("../../../");
			return File.getContent("zproject.xml");
		}
		if (FileSystem.exists("../../../../zproject.xml")) {
			Sys.setCwd("../../../../");
			return File.getContent("zproject.xml");
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
