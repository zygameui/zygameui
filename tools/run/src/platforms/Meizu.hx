package platforms;

import python.FileUtils;

class Meizu extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
        FileUtils.copyFile(args[2] + "Export/html5/bin/index.html", dir);
        FileUtils.copyFile(args[2] + "Export/html5/bin/zygameui-dom.js", dir);
        var oldDir = Sys.getCwd();
        Sys.setCwd(dir);
        Sys.command("zip -rp meizu.zip .");
        Sys.setCwd(oldDir);
	}

}
