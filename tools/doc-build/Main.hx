import sys.io.File;
import sys.FileSystem;

class Main {
	static function main() {
		var path = Sys.programPath();
		path = path.substr(0, path.lastIndexOf("/"));
		trace("path=", path);
		Sys.setCwd(path);
		Sys.setCwd("../../../");
		trace(Sys.getCwd());
		var importAll:Array<String> = [];
		parseDir("Source", importAll);
		trace("包名列表：", importAll.join("\n"));
		// 创建构造目录
		var buildPath = path + "/build";
		if (FileSystem.exists(buildPath)) {
			Sys.command("rm -rf " + buildPath);
		}
		FileSystem.createDirectory(buildPath);
		// 构造项目配置
		Sys.setCwd(buildPath);
		FileSystem.createDirectory("src");
		File.saveContent("src/Main.hx", 'package;\n${importAll.join("\n")}\nclass Main extends Start{}');
		File.saveContent("project.xml", File.getContent("../../project.xml"));
        var code = Sys.command("lime build html5");
        if(code == 0){
            // 构造完成
            Sys.command("haxelib run dox -i bin -o ../../../../docs -in zygame -in KengSDK -in UMengSDK -in qq -in wx");
        }
        else{
            trace("doc.xml创建失败");
        }
	}

	public static function parseDir(dir:String, importAll:Array<String>):Void {
		var files = FileSystem.readDirectory(dir);
		for (file in files) {
			var path = dir + "/" + file;
			if (FileSystem.isDirectory(path)) {
				// 如果是目录，则继续搜索
				parseDir(path, importAll);
			} else {
				// 读取hx文件，并解析
				if (file.indexOf(".hx") != -1 && file.indexOf("-") == -1) {
					var haxe = File.getContent(path);
					var packageName:String = "";
					if (haxe.indexOf("package") != -1) {
						packageName = haxe.substr(haxe.indexOf("package ") + 8);
						packageName = packageName.substr(0, packageName.indexOf(";"));
						packageName = StringTools.replace(packageName, " ", "");
					}
					importAll.push("import "+packageName + "." + StringTools.replace(file, ".hx", ";"));
				}
			}
		}
	}
}
