package platforms;

import python.FileUtils;

class Mmh5 extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
        Sys.setCwd(Sys.getCwd() + "Export/html5/bin");
        Sys.command("zip -rp mmh5.zip .");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/mmh5.zip", dir);
	}

}