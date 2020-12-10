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

	public function new() {
		if(FileSystem.exists("zproject.xml") == false)
			return;
		var xml:Xml = Xml.parse(File.getContent("zproject.xml"));
		for (item in xml.firstElement().elements()) {
			switch (item.nodeName) {
				case "assets":
					if(item.get("unparser") == "true")
						continue;
					readDir(Sys.getCwd() + item.get("path"),item.exists("rename")?item.get("rename"):StringUtils.getName(item.get("path")));
			}
		}
	}

	public function readDir(path:String,rename:String):Void {
		if (path == "" || path == null)
			return;
		if (FileSystem.isDirectory(path)) {
			var dir:Array<String> = FileSystem.readDirectory(path);
			for (file in dir) {
                readDir(path + "/" + file,rename + "/" + file);
			}
        }
        else
        {
			assetsRenamePath.set(StringUtils.getName(path)  + "." + StringUtils.getExtType(path),rename);
            assetsPath.set(StringUtils.getName(path)  + "." + StringUtils.getExtType(path),path);
        }
	}
	#end
}
