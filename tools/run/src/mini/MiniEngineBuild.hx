package mini;

import sys.io.File;
import python.FileUtils;
import sys.FileSystem;

class MiniEngineBuild {
    
    public static function build(path:String):Void
    {
        trace("build miniengine target = " + path);
        if(path.indexOf(".hx") == -1)
            Sys.setCwd(path);
        else 
            Sys.setCwd(Sys.args()[Sys.args().length - 1]);
        if(FileSystem.exists("build"))
            FileUtils.removeDic("build");
        if(FileSystem.exists("dist.zip"))
            FileSystem.deleteFile("dist.zip");
        FileSystem.createDirectory("build");
        FileUtils.copyDic("Source","build/");    
        FileUtils.copyDic("Assets","build/");
        FileUtils.copyDic("Sound/mp3","build/");
        Sys.command("zip -q -r -m -o dist.zip build");   
        if(Sys.args()[2] == "-o")
        {
            File.copy("dist.zip",Sys.args()[3]);
        }
    }

}