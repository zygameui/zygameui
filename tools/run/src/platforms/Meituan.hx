package platforms;

import sys.FileSystem;
import python.FileUtils;

/**
 * 美团小游戏编译
 */
class Meituan extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/mgc.config.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/index.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/project.config.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/leuok.bi.wx.js", dir);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/sdk", dir);
	}

	override function buildAfter() {
		super.buildAfter();
		Sys.setCwd(dir);
		// 编译流程
		trace("美团小游戏打包开始");
		Sys.command("mgc debug");
	}
}
