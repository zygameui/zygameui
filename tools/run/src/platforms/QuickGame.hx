package platforms;

import sys.io.Process;
import python.FileUtils;
import sys.FileSystem;

/**
 * 通用快游戏引擎编译处理
 */
class QuickGame extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.createDir(dir + "/src");
		FileUtils.createDir(dir + "/engine");
		FileUtils.copyFile(args[2] + "Export/html5/bin/" + Build.mainFileName + ".js", dir + "/engine");
		FileUtils.copyFile(args[2] + "Export/html5/bin/game.js", dir + "/src");
		FileUtils.copyFile(args[2] + "Export/html5/bin/manifest.json", dir + "/src");
		FileUtils.copyFile(args[2] + "Export/html5/bin/package.json", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/zygameui-dom.js", dir + "/src");
		FileUtils.copyDic(args[2] + "Export/html5/bin/vivosrc", dir + "/src");
		FileUtils.copyDic(args[2] + "Export/html5/bin/config", dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/sign", dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/lib", dir + "/src");
		FileUtils.copyFile(args[2] + "Export/html5/bin/pkgicon.png", dir + "/src");
	}

	override public function run(cName:String):Void {
		Sys.command("cd Export/" + cName + "
        npm install
        npm run build
        ");
	}
}

class Vivo extends QuickGame {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		this.root = "src";
	}

	override function buildAfter() {
		super.buildAfter();
		this.run("vivo");
	}
}

class Oppo extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/main.js", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/manifest.json", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/icon.png", dir);
		// FileUtils.copyDic(args[2]+"Export/html5/bin/subcontract",dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/res", dir);
		FileUtils.copyFile(args[2] + "Export/html5/bin/lib/pako.min", dir + "/lib");
		FileUtils.copyDic(args[2] + "Export/html5/bin/release", dir + "/sign");
		FileUtils.copyFile(args[2] + "Export/html5/bin/pkgicon.png", dir);
		FileUtils.copyDic(args[2] + "Export/html5/bin/sdk", dir);
	}

	override function buildAfter() {
		super.buildAfter();
		// source ~/.bash_profile
		// source ~/.zprofile
		trace("开始oppo构造");
		var p = new Process("haxelib", ["path", "oppo-rpk-core"]);
		var data = p.stdout.readAll().toString();
		p.kill();
		var paths = data.split("\n")[0];
		paths = StringTools.replace(paths, "/src/", "/");
		trace("oppo config:", data);
		var code = Sys.command("cd Export/oppo
            " + paths + "tools/pkgtools/lib/bin/quickgame pack release");
		if (code != 0)
			throw "Build error:" + code;
	}
}

/**
 * WIFI万能钥匙 连尚小程序
 */
class Wifi extends Oppo {
	override function buildAfter() {
		if (FileSystem.exists("Export/wifi/game.cpk"))
			FileSystem.deleteFile("Export/wifi/game.cpk");
		Sys.command("cd Export/wifi
        zip -r game.cpk ./*");
	}
}
