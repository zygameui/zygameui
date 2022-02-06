package task;

import sys.io.File;
import haxe.Json;
import sys.FileSystem;

class TaskCommand {
	public var label:String;

	public var command:String;

	public var type:String = "shell";

	public var problemMatcher:Array<Dynamic> = [];

	public var group:Dynamic = {
		kind: "build"
	}

	public function new() {}
}

class Tasks {
	public static function initTask():Void {
		var newdata = {
			version: "2.0.0",
			tasks: []
		};
		var data = {
			version: "2.0.0",
			tasks: []
		};
		var dir = Sys.args()[Sys.args().length - 1];

		if (!FileSystem.exists(dir + "/.vscode")) {
			FileSystem.createDirectory(dir + "/.vscode");
		}

		if (FileSystem.exists(dir + "/.vscode/tasks.json")) {
			trace("tasks.json已存在，进行更新处理");
			var tasks = File.getContent(dir + "/.vscode/tasks.json");
			var datas = tasks.split("\n");
			for (index => value in datas) {
				if (value.indexOf("//") != -1) {
					datas[index] = "";
				}
			}
			tasks = datas.join("\n");
			data = Json.parse(tasks);
		} else {
			trace("tasks.json不存在，创建新的任务列表");
		}

		var taskCommands = [];
		for (tdata in tasks.list) {
			taskCommands.push(tdata.command);
		}

		// 开始遍历
		for (index => value in data.tasks) {
			var str:String = value.command;
			if (str.indexOf("haxelib run zygameui -updatelib") == -1 && str.indexOf("python3 tools/python/build.py") == -1) {
				if (str.indexOf("haxelib run zygameui -debug") != -1
					|| str.indexOf("haxelib run zygameui -build") != -1
					|| str.indexOf("haxelib run zygameui -final") != -1) {
					var commandArray = str.split(" ");
					var command = commandArray[commandArray.length - 1];
					if (taskCommands.indexOf(command) == -1) {
						// 说明属于自定义命令，可保留
						newdata.tasks.push(value);
					}
				} else
					newdata.tasks.push(value);
			}
		}
		var arr = [];
		// 更新新内容
		for (index => value in tasks.list) {
			if (value.command.indexOf("haxelib") == -1) {
				arr.push(value.name);
				//-build
				var c = new TaskCommand();
				c.label = value.name + "(Build)";
				c.command = "haxelib run zygameui -build " + value.command;
				newdata.tasks.push(c);
				//-final
				var c = new TaskCommand();
				c.label = value.name + "(Final)";
				c.command = "haxelib run zygameui -final " + value.command;
				newdata.tasks.push(c);
				//-debug
				if (value.command == "android" || value.command == "ios") {
					var c = new TaskCommand();
					c.label = value.name + "(Debug)";
					c.command = "haxelib run zygameui -debug " + value.command;
					newdata.tasks.push(c);
				}
			} else {
				// haxelib
				var c = new TaskCommand();
				c.label = value.name;
				c.command = value.command;
				newdata.tasks.push(c);
			}
		}
		File.saveContent(dir + ".vscode/tasks.json", Json.stringify(newdata));
		trace("支持平台列表：\n" + arr.join("\n"));
		trace("tasks.json同步" + tasks.list.length + "条编译命令");
		trace("一共" + newdata.tasks.length + "条编译命令");
	}

	public static var tasks = {
		list: [
			{
				name: "HTML5",
				command: "html5"
			},
			{
				name: "微信小游戏",
				command: "wechat"
			},
			{
				name: "快手小游戏",
				command: "ks"
			},
			{
				name: "4399游戏盒",
				command: "g4399"
			},
			{
				name: "Bilibili快游戏",
				command: "bili"
			},
			{
				name: "字节跳动快游戏",
				command: "tt"
			},
			{
				name: "手Q小游戏",
				command: "qqquick"
			},
			{
				name: "百度小游戏",
				command: "baidu"
			},
			{
				name: "梦工厂小游戏",
				command: "mgc"
			},
			{
				name: "奇虎小游戏",
				command: "qihoo"
			},
			{
				name: "Facebook小游戏",
				command: "facebook"
			},
			{
				name: "魅族快游戏",
				command: "meizu"
			},
			{
				name: "华为快游戏",
				command: "huawei"
			},
			{
				name: "小米快游戏",
				command: "xiaomi"
			},
			{
				name: "移动MMH5小游戏",
				command: "mmh5"
			},
			{
				name: "Vivo快游戏",
				command: "vivo"
			},
			{
				name: "Oppo快游戏",
				command: "oppo"
			},
			{
				name: "Wifi无极环境小游戏",
				command: "wifi"
			},
			{
				name: "豹趣H5小游戏",
				command: "html5:baoqu"
			},
			{
				name: "趣头条H5小游戏",
				command: "html5:quyouxi"
			},
			{
				name: "360奇虎快游戏",
				command: "qihoo"
			},
			{
				name: "九游UCH5小游戏",
				command: "html5:uc"
			},
			{
				name: "安卓Android",
				command: "android"
			},
			{
				name: "苹果IOS",
				command: "ios"
			},
			{
				name: "4399H5全平台兼容小游戏",
				command: "4399"
			},
			{
				name: "连信H5小游戏",
				command: "lianxin"
			},
			{
				name: "小米赚赚H5小游戏",
				command: "xiaomi-zz"
			},
			{
				name: "YY小游戏（H5）",
				command: "html5:yy"
			},
			{
				name: "更新内部haxelib库",
				command: "haxelib run zygameui -updatelib"
			},
			{
				name: "HashLink",
				command: "hl"
			},
			{
				name: "Electron",
				command: "electron"
			},
			{
				name: "生成Lime架构包",
				command: "haxelib run zygameui -pkg"
			}
		]
	};
}
