import sys.io.File;
import sys.FileSystem;

/**
 * 用于启动命令
 */
class Run {

    public static function main(){
        trace("zygameui-command");
        trace("当前运行目录:"+Sys.getCwd());
        trace("命令入口："+Sys.args());
        var args:Array<String> = Sys.args();
        if(Sys.systemName() == "Mac")
            Sys.command("python3 "+FileSystem.absolutePath("tools/run/tools.py")+" "+args.join(" "));
        else
            Sys.command("python "+FileSystem.absolutePath("tools/run/tools.py")+" "+args.join(" "));
    }
    
}