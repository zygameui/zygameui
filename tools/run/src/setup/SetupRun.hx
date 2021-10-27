package setup;

import sys.io.File;
import sys.io.Process;

/**
 * 初始化命令流程
 * 1、自动化下载include里所描述的所需文件
 */
class SetupRun {
	public static function run():Void {
		// 解析include.xml配置
		trace(Sys.getCwd());
		var xml:Xml = Xml.parse(File.getContent("include.xml"));
		for (item in xml.firstElement().elements()) {
			switch (item.nodeName) {
				case "haxelib":
					var haxelibname = item.get("name");
					var haxelibversion = item.get("version");
					if (haxelibversion == null)
						haxelibversion = "";
					else
						haxelibname += ":" + haxelibversion;
					trace("check haxelib " + haxelibname);
					if (exsitHaxelib(haxelibname)) {
						trace("haxelib " + haxelibname + " exist");
					} else {
						if (haxelibversion != null)
							haxelibname = StringTools.replace(haxelibname, ":", " ");
						Sys.command("haxelib install " + haxelibname);
					}
			}
		}
	}

	/**
	 * 判断是否存在这个Haxelib库
	 * @param name 
	 * @return Bool
	 */
	public static function exsitHaxelib(name:String):Bool {
		var code = Sys.command("haxelib path " + name);
		return code == 0;
	}
}
