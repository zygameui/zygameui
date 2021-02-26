package platforms;

import sys.FileSystem;
import python.FileUtils;

class Meizu extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/index-meizu.html", dir + "/index.html");
		FileUtils.copyFile(args[2] + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/manifest.json", dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/sign", dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/image", dir);
		// 兼容打包工具的ICON
		FileUtils.copyFile(args[2] + "Export/html5/bin/pkgicon.png", dir);
		var oldDir = Sys.getCwd();
		Sys.setCwd(dir);
		var npmInstall:Bool = FileSystem.exists(this.dir + "/../html5/bin/tools/meizu-build/node_modules");
		// 需要安装
		var command = 'cd "' + this.dir + '/../html5/bin/tools/meizu-build' + '" ' + (!npmInstall ? '&& npm install' : '')
			+ ' && node bundle.js release --sourcePath ' + this.dir + ' --outputPath ' + this.dir + '/../ --sign release';
		trace(command);
		Sys.command(command);
		Sys.setCwd(oldDir);
	}
}
