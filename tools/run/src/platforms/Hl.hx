package platforms;

import sys.io.File;

class Hl extends BuildSuper {
	override function buildAfter() {
		super.buildAfter();
		// 修改对应的COMMAND命令
		var mainFile = Sys.getCwd() + "Export/hl/bin/" + Build.mainFileName + ".app/Contents/MacOS/" + Build.mainFileName;
		File.copy(mainFile, mainFile + "_content");
		// 准备一份新的启动文件
		File.saveContent(mainFile, "
        work_path=$(dirname $0)
        cd ${work_path}
        ./" + Build.mainFileName + "_content
        ");
	}
}
