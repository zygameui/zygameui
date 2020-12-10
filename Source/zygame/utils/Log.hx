package zygame.utils;


#if (!html5 && !android && !flash)
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
#end

/**
 *  用于本地输出Log的通用入口
 */
class Log {

    /**
     *  清空所有log
     */
    public static function clear():Void
    {
        #if (!html5 && !ios && !android && !flash)
        if(FileSystem.exists("/Users/grtf/Documents/haxe.log")){
            var fileOut:FileOutput = File.write("/Users/grtf/Documents/haxe.log");
            fileOut.writeString("");
            fileOut.close();
        }
        #end
    }

    /**
     *  本地log处理
     *  @param str - 
     */
    public static function log(str:String):Void
    {
        #if (!html5 && !ios  && !android && !flash)
        if(FileSystem.exists("/Users/grtf/Documents/haxe.log")){
            var fileOut:FileOutput = File.append("/Users/grtf/Documents/haxe.log");
            fileOut.writeString(str+"\n");
            fileOut.close();
        }
        #else
        //trace(str);
        #end
    }

}