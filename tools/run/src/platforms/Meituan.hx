package platforms;

import haxe.io.Path;
import sys.FileSystem;
import python.FileUtils;

/**
 * 美团小游戏编译
 */
class Meituan extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		var sub_game = Path.join([dir, "sub_game"]);
		FileUtils.createDir(sub_game);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/" + Build.mainFileName + ".js", sub_game);
		FileSystem.deleteFile(Path.join([dir, Build.mainFileName + ".js"]));
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/sub_game/game.js", Path.join([sub_game, "game.js"]));
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/mgc.config.js", new Path(dir).dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/index.js", sub_game);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/project.config.json", sub_game);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", sub_game);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/leuok.bi.wx.js", sub_game);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/sdk", sub_game);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/lib", sub_game);
		FileUtils.removeDic(Sys.getCwd() + "Export/html5/bin/lib");
	}

	override function buildAfter() {
		super.buildAfter();
		Sys.setCwd(dir + "/../");
		// 编译流程
		trace("美团小游戏打包开始");
		Sys.command("
		unset http_proxy
		unset https_proxy
		mgc debug");
	}
}
