import setup.SetupRun;
import pkg.PkgTools;
import task.Tasks;
import atlasxml.AtlasTools;
import atf.AtfBuild;
import python.GetPass;
import sys.io.File;
import sys.FileSystem;
import python.HttpDownload;
import haxe.Http;
import python.FileUtils;
import mini.MiniEngineBuild;
import xls.XlsBuild;
import hxml.UpdateHxml;

class Tools {
	public static var authorizationMaps:Map<String, String> = [];

	public static var webPath:String;

	public static var haxelib:String = "/Users/grtf/haxelib";

	public static var version:String = "0.0.4";

	public static function main() {
		haxelib = "/Users/" + GetPass.getUserName() + "/.haxelib";
		if (FileSystem.exists(haxelib)) {
			haxelib = File.getContent(haxelib);
			haxelib = StringTools.replace(haxelib, " ", "");
		} else {
			haxelib = FileSystem.absolutePath("");
			haxelib = haxelib.substr(0, haxelib.lastIndexOf("/zygameui"));
		}
		// 获取授权文件
		var authorization:String = null;
		if (FileSystem.exists(haxelib + "/zygameui/.dev")) {
			authorization = File.getContent(haxelib + "/zygameui/.dev");
		} else if (FileSystem.exists(haxelib + "/zygameui/.current")) {
			authorization = File.getContent(haxelib + "/zygameui/.current");
			authorization = StringTools.replace(authorization, ".", ",");
			authorization = haxelib + "/zygameui/" + authorization;
		}
		if (FileSystem.exists(authorization + "/authorization")) {
			authorization = File.getContent(authorization + "/authorization");
			var authorizationData = authorization.split("\n");
			for (s in authorizationData) {
				var arr = s.split("=");
				authorizationMaps[arr[0]] = arr[1];
			}
		}
		webPath = authorizationMaps["haxelib"];
		trace("authorization=", authorization);
		trace("haxelib:" + haxelib);
		trace("args:" + Sys.args());
		var args:Array<String> = Sys.args();
		if (args.length == 1) {
			trace("version:" + version);
			trace("帮助列表：
            -inittask 初始化VSCODE的task.json文件
            -build 用于生成不同平台命令（通用）
            -upload 库名 秘钥 :用于上传相关的库到自开发库中（需要得到授权才能够更新到自开发库）
            -updatedev 库名 :用于下载线上最新的版本到haxelib开发版本中（需要得到授权才能够更新到自开发库）
            -updatelib :用于更新所有的自有开发库（需要得到授权才能够更新到自开发库）
            -libs :显示所有库版本情况（需要得到授权）");
			return;
		}

		var command:String = args[0];
		switch (command) {
			case "setup":
				// 库初始化
				SetupRun.run();
			case "-pkg":
				// 创建一个项目包
				PkgTools.build();
			case "-inittask":
				// 初始化task.json文件
				Tasks.initTask();
			case "-updatehxml":
				// 更新库
				UpdateHxml.update(args[1]);
			case "-miniengine":
				// 生成迷你小引擎实现
				MiniEngineBuild.build(args[1]);
			case "-atf":
				// 批量生成ATF文件
				AtfBuild.build(args[1], args[2]);
			case "-build", "-final", "-debug":
				Build.run(args);
			case "-upload":
				uploadlib();
			case "-updatedev":
				updatedev();
			case "-updatelib":
				updateLib();
			case "-libs":
				showLibs();
			case "-xls":
				XlsBuild.build(args[3] + args[1], args[3] + args[2]);
			case "-atlas":
				AtlasTools.removeXmlItem(args[1]);
			case "-ogg":
				// 转换为OGG
				trace("Mp3 to Ogg...", Sys.getCwd());
				Sys.command("node", [Sys.getCwd() + "/tools/run/mp3toogg.js", args[1]]);
		}
	}

	public static function showLibs():Void {
		var onlineVersion:String = haxe.Http.requestUrl(webPath + "haxelib/version.json?" + Math.random());
		trace("\n版本库：");
		var arr:Array<String> = onlineVersion.split("\n");
		for (lib in arr) {
			var a:Array<String> = lib.split(":");
			if (a.length == 2) {
				var projectName:String = a[0];
				if (FileSystem.exists(haxelib + "/" + projectName)) {
					if (FileSystem.exists(haxelib + "/" + projectName + "/.current"))
						trace(lib + "  now:" + File.getContent(haxelib + "/" + projectName + "/.current"));
					else if (FileSystem.exists(haxelib + "/" + projectName + "/.dev")) {
						trace(lib + "  now:开发版本");
					} else {
						trace(lib + "  now:库已损坏");
					}
				} else {
					trace(lib + "  now:库不存在");
				}
			}
		}
	}

	/**
	 * 更新所有库
	 */
	public static function updateLib():Void {
		var random:Int = Std.int(Math.random() * 99999);
		var downloadPath:String = webPath;
		trace("开始更新库:" + downloadPath + "haxelib/version.json?version=" + random);
		var versionData:String = Http.requestUrl(downloadPath + "haxelib/version.json?version=" + random);
		var versoins:Array<String> = versionData.split("\n");
		trace(versoins);

		// 默认haxelib目录
		var userName:String = GetPass.getUserName();
		var haxelibConfigPath:String = "/Users/" + userName + "/.haxelib";
		trace("haxelibConfigPath=" + haxelibConfigPath);
		var haxelibPath:String = haxelib;
		if (Sys.systemName() == "Mac")
			haxelibPath = File.getContent(haxelibConfigPath);
		haxelibPath = StringTools.replace(haxelibPath, " ", "");
		trace("haxelibPath=" + haxelibPath);
		for (version in versoins) {
			var isUpdate:Bool = false;
			var arr:Array<String> = version.split(":");
			var cheakVersionPath:String = haxelibPath + "/" + arr[0] + "/.current";
			var cheakDevPath:String = haxelibPath + "/" + arr[0] + "/.dev";
			trace("检查库：" + arr);
			if (arr.length != 2)
				continue;
			if (FileSystem.exists(cheakVersionPath)) {
				var curVersion:String = File.getContent(cheakVersionPath);
				trace("curVersion:" + curVersion);
				trace("newVersion:" + arr[1]);
				if (curVersion != arr[1] && Std.parseInt(curVersion.split(".").join("")) < Std.parseInt(arr[1].split(".").join(""))) {
					trace("版本有更新，开始下载");
					isUpdate = true;
				} else {
					trace("已是最新无需更新");
				}
			} else if (FileSystem.exists(cheakDevPath)) {
				trace("newVersion:" + arr[1]);
				trace("该库为开发库");
			} else {
				trace("库不存在，开始下载");
				isUpdate = true;
			}

			if (isUpdate) {
				// 开始更新
				trace(downloadPath + "haxelib/" + arr[0] + arr[1] + ".zip" + " -> " + arr[0] + ".zip");
				var downloadZip = downloadPath + "haxelib/" + arr[0] + arr[1] + ".zip";
				var saveZip = arr[0] + ".zip";

				// v2下载实现
				var http:Http = new Http(downloadZip);
				http.onBytes = function(data) {
					File.saveBytes(saveZip, data);
					Sys.command("haxelib install " + arr[0] + ".zip");
					FileSystem.deleteFile(arr[0] + ".zip");
				};
				http.request();
			}
		}
	}

	/**
	 * 把库更新到本地的dev中
	 */
	public static function updatedev():Void {
		var args:Array<String> = Sys.args();
		var projectName:String = args[1];
		trace("正在更新库：" + projectName);
		if (FileSystem.exists(haxelib + "/" + projectName + "/.dev")) {
			var onlineVersion:String = haxe.Http.requestUrl(webPath + "haxelib/version.json?" + Math.random());
			var libs:Array<String> = onlineVersion.split("\n");
			for (i in 0...libs.length) {
				var lib:String = libs[i];
				if (lib.indexOf(projectName) != -1) {
					var downloadPath = webPath + "haxelib/" + StringTools.replace(lib, ":", "") + ".zip?" + Math.random();
					trace("正在更新" + lib + ":" + downloadPath);
					if (FileSystem.exists(haxelib + "/cache.zip"))
						FileSystem.deleteFile(haxelib + "/cache.zip");
					HttpDownload.download(downloadPath, haxelib + "/cache.zip");
					trace("同步版本");
					Sys.command("cd " + haxelib + "/" + projectName + "
                    unzip -o ../cache.zip");
					if (FileSystem.exists(haxelib + "/" + projectName + "/__MACOSX"))
						FileUtils.removeDic(haxelib + "/" + projectName + "/__MACOSX");
					trace("更新结束！");
					break;
				}
			}
		} else {
			trace(projectName + "不是你的开发库，无法更新");
		}
	}

	public static function uploadlib():Void {
		var args:Array<String> = Sys.args();
		var projectName:String = args[1];
		var projectPath:String = haxelib + "/" + projectName;
		trace("正在处理项目库：" + projectPath);
		if (FileSystem.exists(projectPath)) {
			var haxelibmsg:String = File.getContent(projectPath + "/haxelib.json");
			var data:Dynamic = haxe.Json.parse(haxelibmsg);
			var version:Int = Std.parseInt(StringTools.replace(data.version, ".", ""));
			version++;
			var v:String = Std.string(version);
			if (v.length < 3)
				while (v.length < 3)
					v = "0" + v;
			var array = v.split("");

			v = array.slice(0, array.length - 2).join("") + "." + array[array.length - 2] + "." + array[array.length - 1];
			trace("升级版本至：" + v);

			// 线上版本
			var onlineVersion:String = haxe.Http.requestUrl(webPath + "haxelib/version.json?" + Math.random());
			if (onlineVersion.indexOf(projectName) == -1)
				onlineVersion += "\n" + projectName + ":0.0.1";
			var libs:Array<String> = onlineVersion.split("\n");
			for (i in 0...libs.length) {
				var lib:String = libs[i];
				if (lib.indexOf(projectName) != -1) {
					var onlineV:String = lib.split(":")[1];

					trace("线上版本：" + onlineV + "->" + " 当前新版本：" + v);

					if (Std.parseInt(StringTools.replace(onlineV, ".", "")) >= Std.parseInt(StringTools.replace(v, ".", ""))) {
						trace("你的本地版本需大于线上版本");
						untyped exit(1);
					}

					libs[i] = projectName + ":" + v;

					var zipfiles:Array<String> = FileSystem.readDirectory(projectPath);
					zipfiles = zipfiles.filter((f) -> {
						if (f.indexOf("Export") != -1)
							return false;
						if (f.indexOf(".dev") != -1)
							return false;
						if (f.indexOf("tps") != -1)
							return false;
						if (f.indexOf(".") == 0)
							return false;
						return true;
					});

					// 上传成功后本地更改版本号
					File.saveContent(projectPath + "/../version.json", libs.join("\n"));
					File.saveContent(projectPath + "/haxelib.json", StringTools.replace(haxelibmsg, data.version, v));

					projectName += v;

					Sys.command("cd "
						+ projectPath
						+ "
                    zip -r ../"
						+ projectName
						+ ".zip "
						+ zipfiles.join(" "));

					// 开始上传
					var file = projectPath + "/../" + projectName + ".zip";
					trace("开始上传");
					// 上传到库中
					uploadOSS(file, "kengsdk_tools_res:1001/haxelib");
					uploadOSS(projectPath + "/../version.json", "kengsdk_tools_res:1001/haxelib");
					trace("上传成功：", projectName, v);
					FileSystem.deleteFile(projectPath + "/../" + projectName + ".zip");
					break;
				}
			}
		} else {
			trace("库不存在！");
		}
	}

	public static function uploadOSS(file:String, saveName:String):Void {
		var command = "haxelib run aliyun-oss-upload " + file + " " + saveName;
		trace(command);
		Sys.command(command);
	}
}
