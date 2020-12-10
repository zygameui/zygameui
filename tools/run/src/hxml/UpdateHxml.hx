package hxml;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * 更新Hxml配置为最新版本
 */
class UpdateHxml {

    public static var haxelibPath:String = "";
    
    public static function update(path:String):Void
    {
        var p:Process = new Process("haxelib config");
        haxelibPath = p.stdout.readAll().toString();
        haxelibPath = StringTools.replace(haxelibPath,"\n","");
        haxelibPath = StringTools.replace(haxelibPath,"\r","");
        trace("Haxelib path = " + haxelibPath);
        trace("read path = " + path);
        var hxml:String = File.getContent(path);
        var lines:Array<String> = hxml.split("\n");
        var hxmlContent = "";
        for (data in lines) {
            if(data.indexOf("-D") != -1)
            {
                data = data.substr(3);
                var currentLib = data.split("=");
                var value = readHaxelibVersion(currentLib[0]);
                if(value != null){
                    trace("update lib "+ currentLib[0] + " = " + value);
                    currentLib[1] = value;
                }
                hxmlContent += "-D " + currentLib.join("=") + "\n";
            }
            else if(data.indexOf("-cp") != -1)
            {
                var currentLib = data.split("/");
                var value = null;
                var index = 0;
                for(i in 1...4)
                {
                    value = readHaxelibVersion(currentLib[currentLib.length - i]);
                    if(value != null){
                        index = i;
                        break;
                    }
                }
                if(value != null){
                    // trace("update lib path "+ currentLib[currentLib.length - index] + " = " + value);
                    var versoinData = currentLib[currentLib.length - index + 1];
                    if(versoinData != null || versoinData.indexOf(",") != -1)
                    {
                        currentLib[currentLib.length - index + 1] = StringTools.replace(value,".",",");
                    }
                }
                hxmlContent += currentLib.join("/") + "\n";
            }
            else
            {
                hxmlContent += data + "\n";
            }
        }
        // trace("final data\n" + hxmlContent);
        File.saveContent(path,hxmlContent);
    }

    /**
     * 读取Haxelib的版本
     * @param path 
     */
    public static function readHaxelibVersion(libname:String):String
    {
        if(FileSystem.exists(haxelibPath + libname))
        {
            if(FileSystem.exists(haxelibPath + libname + "/haxelib.json"))
            {
                return readHaxelibVersionData(haxelibPath + libname + "/haxelib.json");
            }
            else if(FileSystem.exists(haxelibPath + libname + "/.current"))
            {
                var currentVersion = File.getContent(haxelibPath + libname + "/.current");
                if(FileSystem.exists(haxelibPath + libname + "/" + currentVersion + "/haxelib.json"))
                {
                    return readHaxelibVersionData(haxelibPath + libname + "/" + currentVersion + "/haxelib.json");
                }
            }
        }
        return null;
    }

    public static function readHaxelibVersionData(path:String):String
    {
        var data = Json.parse(File.getContent(path));
        return data.version;
    }

}