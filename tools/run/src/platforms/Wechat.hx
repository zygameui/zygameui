package platforms;

import sys.io.File;
import sys.FileSystem;
import python.FileUtils;

/**
 * 微信编译资源处理
 */
class Wechat extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/index.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/project.config.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/leuok.bi.wx.js", dir);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/sdk", dir);
	}
}

/**
 * 4399平台
 */
class G4399 extends Wechat {}

/**
 * 快手小游戏
 */
class Ks extends Wechat {}

/**
 * Bilibili平台
 */
class Bili extends Wechat {}

/**
 * 字节跳动
 */
class Tt extends Wechat {}

/**
 * 手Q小游戏
 */
class Qqquick extends Wechat {}

/**
 * 百度小游戏
 */
class Baidu extends Wechat {}

/**
 * 梦工厂
 */
class Mgc extends Wechat {

	/**
	 * 尝试编译为MGC
	 */
	override function buildAfter() {
		super.buildAfter();
		var code = Sys.command("haxelib run lebox-build-tools");
		if(code == 0){
			trace("梦工厂包编译成功");
		}
		else 
			trace("Warring:梦工厂包编译时，需要安装lebox-build-tools库");
	}

}

/**
 * 奇虎360小游戏
 */
class Qihoo extends Wechat {
	override function buildAfter() {
		super.buildAfter();
		trace("Build qihoo path:", this.dir);
		if (FileSystem.exists(this.dir + "/game.zip"))
			FileSystem.deleteFile(this.dir + "/game.zip");
		var npmInstall:Bool = FileSystem.exists(this.dir + "/../html5/bin/tools/qihoosdk/node_modules");
		var command = "
		cd "
			+ this.dir
			+ "/../html5/bin/tools/qihoosdk"
			+ (npmInstall ? "" : "
		npm install")
			+ "
		node ./index.js -i "
			+ this.dir;
		trace(command);
		Sys.command(command);
		FileUtils.copyFile(this.dir + "/../html5/bin/tools/qihoosdk/dist/game.zip", dir);
	}
}
