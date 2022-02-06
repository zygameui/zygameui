package project;

import sys.io.File;
import sys.FileSystem;

class ProjectUtils {
	/**
	 * Main.hx文件内容
	 */
	public static var mainCode:String = 'package;

    import zygame.core.Start;
    
    class Main extends Start {
        public function new() {
            super(1920 ,1080 ,false);
        }
    
        override function onInit() {
            super.onInit();
            // 代码初始化入口
        }
    }
    ';

	public static function create(projectName:String):Void {
		var args = Sys.args();
		Sys.setCwd(args[args.length - 1]);
		if (projectName == null)
			throw "需要提供projectName的参数：haxelib zygameui -create PROJECT_NAME";
		if (FileSystem.exists(projectName)) {
			trace("发现存在相同目录：" + Sys.getCwd() + "/" + projectName + "，是否进行直接删除覆盖？（y/n）");
			var line = Sys.stdin().readLine();
			switch (line.toLowerCase()) {
				case "n":
					trace("拒绝，已退出");
				case "y":
					// 清空目录
					Sys.command("rm -rf " + projectName);
			}
		}
		Sys.command("haxelib run openfl create project " + projectName);
		Sys.setCwd(Sys.getCwd() + "/" + projectName);
		var xmlContent = File.getContent("project.xml");
		xmlContent = StringTools.replace(xmlContent, "openfl", "zygameui");
		File.saveContent("project.xml", xmlContent);
		File.copy("project.xml", "zproject.xml");
		File.saveContent("Source/Main.hx", mainCode);
		// 初始化项目
		Sys.command("haxelib run zygameui -inittask");
		trace("创建结束");
	}
}
