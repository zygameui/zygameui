import platforms.BuildSuper;
import sys.io.File;
import sys.FileSystem;
import python.FileUtils;
import platforms.Wechat;
import platforms.QuickGame;
import platforms.Xiaomi;
import platforms.Meizu;
import platforms.Mmh5;
import platforms.Huawei;
import platforms.Facebook;
import platforms.Hl;
import platforms.Meituan;

class Build {
	public static var currentBuild:BuildSuper;

	private static var platforms:Array<String> = [
		"android", "ios", "oppo", "vivo", "qqquick", "html5", "4399", // H5
		"g4399", // 快游戏
		"xiaomi-zz", "xiaomi-h5", "xiaomi", "wechat", "tt", "baidu", "mgc",
		"wifi", "meizu", "mmh5", "facebook", "huawei", "qihoo", "bili", "hl", "electron", "ks", "lianxin", "mac", "meituan"
	];

	/**
	 * 运行build命令
	 * @param args
	 */
	public static function run(args:Array<String>) {
		new Build(args);
	}

	/**
	 * 是否已经编译结束
	 */
	public var isBuilded:Bool = false;

	/**
	 * 主类名
	 */
	public static var mainFileName:String = null;

	/**
	 * 当前编译的平台
	 */
	public var buildPlatform:String = null;

	public function new(args:Array<String>) {
		var buildAgs = args[1].split(":");
		Sys.setCwd(args[args.length - 1]);
		trace("BUILDING " + args, Sys.getCwd());
		if (args.length < 3)
			throw "参数不足，请参考`haxelib run zygameui -build 平台`命令\n 已支持平台：" + platforms.join(" ");
		if (platforms.indexOf(buildAgs[0]) == -1)
			throw "平台`" + args[1] + "`无效，不存在于`" + platforms.join(" ") + "`当中";
		if (!FileSystem.exists(Sys.getCwd() + "zproject.xml"))
			throw "项目不存在有效的zproject.xml配置";
		// 开始编译
		var target = buildAgs.length > 1 ? buildAgs[1] : buildAgs[0];
		var xml:Xml = Xml.parse(File.getContent(Sys.getCwd() + "zproject.xml"));
		xml.firstElement().insertChild(Xml.parse("<define name=\"" + (target == "html5" ? "html5-platform" : target) + "\"/>"), 0);
		xml.firstElement().insertChild(Xml.parse("<define name=\"zybuild\"/>"), 0);
		// 额外的参数，全部都需要定义为define
		for (i in 2...args.length - 1) {
			xml.firstElement().insertChild(Xml.parse('<define name="${args[i]}"/>'), 0);
		}
		File.saveContent(Sys.getCwd() + "project.xml", xml.toString());
		var dir:String = Sys.getCwd() + "Export/" + target;
		if (args[1] == "html5")
			dir += "/bin";
		Defines.define("zybuild");
		Defines.define(args[1]);
		action(xml.firstElement(), args, dir);
		// 获取命令
		var c = args[1];
		if (c.indexOf(":") != -1)
			c = c.substr(0, c.lastIndexOf(":"));
		switch (c) {
			case "electron":
				buildPlatform = "electron";
				buildElectron();
			case "hl":
				buildPlatform = "hl";
				buildHashlink();
			case "ios":
				buildPlatform = "ios";
				buildIos();
			case "android":
				buildPlatform = "android";
				buildAndroid();
			case "mac":
				buildPlatform = "mac";
				buildMac();
			default:
				// 默认编译HTML5
				buildPlatform = "html5";
				buildHtml5();
		}
		buildPlatformAssets(args, dir);
		isBuilded = true;
		action(xml.firstElement(), args, dir, true);
		if (currentBuild != null)
			currentBuild.buildAfter();
		// 删除多余的隐藏文件
		clear(dir);
		trace("\n\n -- 编译结束 --");
	}

	public static function clear(dir:String):Void {
		if (FileSystem.isDirectory(dir)) {
			var dirs:Array<String> = FileSystem.readDirectory(dir);
			for (d in dirs) {
				clear(dir + "/" + d);
			}
		} else if (dir.indexOf("._") != -1) {
			trace("删除", dir);
			FileSystem.deleteFile(dir);
		}
	}

	/**
	 * 编译平台资源
	 */
	public function buildPlatformAssets(args:Array<String>, dir:String):Void {
		if (args[1] == "html5")
			return;
		trace("开始编译平台资源");
		if (!FileSystem.exists(dir))
			FileSystem.createDirectory(dir);
		if (mainFileName == null)
			throw "Build.mainFileName is NULL!";
		if (buildPlatform == "html5") {
			// 通用资源拷贝
			FileUtils.copyDic("Export/html5/bin/lib", dir);
			FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/" + mainFileName + ".js", dir);
		}
		// 运行平台自定义脚本
		var platformName = args[1];
		platformName = platformName.substr(0, 1).toUpperCase() + platformName.substr(1).toLowerCase();
		var cls:Class<Dynamic> = Type.resolveClass("platforms." + platformName);
		if (cls != null) {
			trace("RUN " + platformName + " ACTION");
			currentBuild = Type.createInstance(cls, [args, dir]);
		} else {
			trace("RUN " + platformName + " FAIL");
		}
	}

	/**
	 * 编译IOS
	 */
	public static function buildIos():Void {
		trace("开始编译IOS");
		// 检查是否已经存在IOS目录
		if (FileSystem.exists("Export/ios")) {
			FileSystem.rename("Export/ios", "Export/ios_temp");
		}
		var args:Array<String> = Sys.args();
		if (args.indexOf("-debug") != -1)
			Sys.command("lime build ios -debug");
		else
			Sys.command("lime build ios");
		if (FileSystem.exists("Export/ios_temp")) {
			// 存在缓存IOS，直接更新
			FileSystem.rename("Export/ios", "Export/ios_temp1");
			FileSystem.rename("Export/ios_temp", "Export/ios");
			// 开始拷贝资源
			FileUtils.copyDic("Export/ios_temp1/" + Build.mainFileName + "/assets", "Export/ios/" + Build.mainFileName);
			// 拷贝编译配置
			FileUtils.copyDic("Export/ios_temp1/" + Build.mainFileName + "/haxe", "Export/ios/" + Build.mainFileName);
			// 拷贝图标资源
			FileUtils.copyDic("Export/ios_temp1/" + Build.mainFileName + "/Images.xcassets", "Export/ios/" + Build.mainFileName);
			FileUtils.removeDic("Export/ios_temp1");
		}
	}

	/**
	 * 编译成Android
	 */
	public static function buildAndroid():Void {
		trace("开始编译ANDROID");
		var args:Array<String> = Sys.args();
		if (args.indexOf("-final") != -1)
			Sys.command("lime build android -final");
		else if (args.indexOf("-debug") != -1)
			Sys.command("lime build android -debug");
		else
			Sys.command("lime build android");
	}

	/**
	 * 编译成Android
	 */
	public static function buildMac():Void {
		trace("开始编译MAC");
		var args:Array<String> = Sys.args();
		if (args.indexOf("-final") != -1)
			Sys.command("lime build mac -final");
		else if (args.indexOf("-debug") != -1)
			Sys.command("lime build mac -debug");
		else
			Sys.command("lime build mac");
	}

	/**
	 * 编译成Hashlink
	 */
	public static function buildHashlink():Void {
		trace("开始编译HashLink");
		var args:Array<String> = Sys.args();
		if (args.indexOf("-debug") != -1)
			Sys.command("lime build hl -debug");
		else
			Sys.command("lime build hl");
	}

	/**
	 * 编译成Electron
	 */
	public static function buildElectron():Void {
		trace("开始编译Electron");
		var args:Array<String> = Sys.args();
		if (args.indexOf("-final") != -1)
			Sys.command("lime build electron -final");
		else
			Sys.command("lime build electron");
	}

	/**
	 * 编译成HTML5
	 */
	public function buildHtml5():Void {
		trace("开始编译HTML5");
		var args:Array<String> = Sys.args();
		var code:Int = 0;
		if (args.indexOf("-final") != -1)
			code = Sys.command("lime build html5 -final");
		else
			code = Sys.command("lime build html5");
		trace("BUILDED " + code);
		if (code != 0)
			throw "编译发生了错误！";
	}

	public function action(xml:Xml, args:Array<String>, dir:String, after:Bool = false):Void {
		for (item in xml.elements()) {
			if (!Defines.cheak(item)) {
				continue;
			}
			switch (item.nodeName) {
				case "copy":
					if (after) {
						var path = dir + "/" + item.get("rename");
						var srcPath = item.get("path");
						trace("copy " + srcPath + " to " + path);
						if (FileSystem.isDirectory(srcPath))
							FileUtils.copyDic(srcPath, path);
						else
							FileUtils.copyFile(srcPath, path);
					}
				case "clear":
					if (after) {
						var path = dir + "/" + item.get("path");
						var igone = item.exists("igone") ? item.get("igone").split(",") : [];
						clearDir(path, igone);
					}
				case "define":
					if (!after)
						Defines.define(item.get("name"), item.get("value"));
				case "app":
					if (item.exists("file") && Defines.cheak(item))
						mainFileName = item.get("file");
				case "shell":
					// 执行自定义脚本使用
					var code = 0;
					if (item.get("after") == "true") {
						if (after) {
							code = Sys.command(item.get("command"));
						}
					} else if (!after)
						code = Sys.command(item.get("command"));
					if (code != 0 && item.get("try") == "true")
						throw "编译失败！";
				case "assets":
					// 拷贝指定资源到指定目录
					if (buildPlatform == "html5" && isBuilded && currentBuild != null && item.exists("cp")) {
						var cp:Array<String> = item.get("cp") != null ? item.get("cp").split(" ") : [];
						// trace("action copy:",cp,args[1]);
						if (cp.indexOf(args[1]) != -1 || cp.indexOf("all") != -1) {
							var filepath:String = item.exists("rename") ? item.get("rename") : item.get("path");
							var path = Sys.getCwd() + "Export/html5/bin/" + filepath;
							trace("CP " + path, "root=", currentBuild.root);
							if (FileSystem.isDirectory(path))
								FileUtils.copyDic(path, currentBuild.root != null ? (dir + "/" + currentBuild.root) : dir);
							else
								FileUtils.copyFile(path,
									currentBuild.root != null ? (dir + "/" + currentBuild.root + "/" + filepath) : (dir + "/" + filepath));
						}
					}
				case "include":
					// 包含XML标签
					var xmlPath = item.get("path");
					if (FileSystem.exists(xmlPath)) {
						var xml:Xml = Xml.parse(File.getContent(xmlPath));
						trace("include xml parsing:" + xmlPath);
						action(xml.firstElement(), args, dir, after);
					}
			}
			action(item, args, dir, after);
		}
	}

	private function clearDir(dir:String, igone:Array<String>) {
		if (FileSystem.exists(dir) == false)
			return;
		if (FileSystem.isDirectory(dir) == false) {
			FileSystem.deleteFile(dir);
			return;
		}
		var files = FileSystem.readDirectory(dir);
		for (file in files) {
			if (FileSystem.isDirectory(dir + "/" + file)) {
				clearDir(dir + "/" + file, igone);
			} else {
				var isClear = true;
				for (item in igone) {
					if ((dir + "/" + file).indexOf(item) != -1)
						isClear = false;
				}
				if (isClear) {
					FileSystem.deleteFile(dir + "/" + file);
				}
			}
		}
		if (FileSystem.readDirectory(dir).length == 0) {
			FileSystem.deleteDirectory(dir);
		}
	}
}
