package atf;

import python.FileUtils;
import sys.io.File;
import sys.FileSystem;

class AtfBuild {
	public static function build(path:String, out:String):Void {
		trace("ATF", Sys.args());
		var tools = Sys.getCwd();
		var args = Sys.args();
		Sys.setCwd(args[args.length - 1]);
		if (!FileSystem.exists(out)) {
			FileSystem.createDirectory(out);
		}
		var dir:Array<String> = FileSystem.readDirectory(path);
		for (file in dir) {
			if (file.indexOf(".") == 0 || !StringTools.endsWith(file, ".png"))
				continue;
			// -c p 这里生成的是IOS的配置
			Sys.command("echo `sips -g pixelHeight -g pixelWidth " + path + "/" + file + "` > " + out + "/cache.txt");
			var size = File.getContent(out + "/cache.txt").split(" ");
			var filename:String = size[2] + "x" + size[4];
			filename = StringTools.replace(filename, "\n", "");
			filename = StringTools.replace(filename, "\r", "");
			var atf = StringTools.replace(file, ".png", "");
			Sys.command(tools + "/tools/atftools/png2atf -n 0,0 -c p -i " + path + "/" + file + " -o " + out + "/" + filename);
			var cmd = "cd " + out + "
            zip -q -m -o " + atf + ".zip " + filename;
			Sys.command(cmd);
		}
	}
}
