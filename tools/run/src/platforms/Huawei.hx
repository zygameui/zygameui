package platforms;

import sys.FileSystem;
import python.FileUtils;

class Huawei extends BuildSuper {

    public function new(args:Array<String>, dir:String) {
		super(args, dir);
        this.root = "web";
        FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/release", dir);
        FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/signtool", dir);
        if(!FileSystem.exists(dir + "/web"))
            FileSystem.createDirectory(dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/"+Build.mainFileName+".js", dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/manifest.json", dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/window.js", dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/game.js", dir + "/web");
        FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/pkgicon.png", dir + "/web");
        FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/lib", dir + "/web");
	}

    override function buildAfter() {
        super.buildAfter();
        var oldDir = Sys.getCwd();
        Sys.setCwd(dir);
        Sys.command("node ./signtool/package/index.js ./web ./dist "+Build.mainFileName+".signed ./release/private.pem ./release/certificate.pem");
        Sys.setCwd(oldDir);
    }
}