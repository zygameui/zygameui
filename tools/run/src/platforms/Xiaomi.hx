package platforms;

import sys.FileSystem;
import sys.io.File;
import python.FileUtils;

class Xiaomi extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/sign", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/main.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/manifest.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/package.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/pkgicon.png", dir);
	}

	override function buildAfter() {
		super.buildAfter();
		Sys.setCwd(dir);
		if (!FileSystem.exists("node_moules"))
			Sys.command(" npm install;");
		// FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/webpack-conf.js", dir + "/node_modules/quickgame-cli/lib/webpack-conf.js");
		Sys.command("npm run release;");
	}
}
