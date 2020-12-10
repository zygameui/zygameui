package atf;

import python.FileUtils;
import sys.io.File;
import sys.FileSystem;

class AtfBuild {
    
    public static function build(path:String,out:String):Void
    {
        if(!FileSystem.exists(out))
        {
            FileSystem.createDirectory(out);
        }
        var dir:Array<String> = FileSystem.readDirectory(path);
        for (str in dir) {
            if(FileSystem.isDirectory(path + "/" + str))
            {
                AtfBuild.build(path + "/" + str,out + "/" + str);
            }
            else 
            {
                if(StringTools.endsWith(str,"png"))
                {
                    if(FileSystem.exists(path + "/" + StringTools.replace(str,".png",".xml")))
                    {
                        //仅转换精灵表
                        Sys.command("echo `sips -g pixelHeight -g pixelWidth "+path + "/" + str +"` > "+out+"/cache.txt");
                        var size = File.getContent(out+"/cache.txt").split(" ");
                        var filename:String = size[2] + "x" + size[4];
                        FileSystem.deleteFile(out+"/cache.txt");
                        Sys.command("tools/atftools/png2atf -n 0,0 -c e -i " + path + "/" + str + " -o " + out + "/" + filename);
                        Sys.command("cd " + out + "
                        zip -q -r -m -o "+str+".zip "+ filename +"
                        mv "+str+".zip "+str);
                    }
                    else
                    {
                        FileUtils.copyFile(path + "/" + str,out + "/" + str);
                    }
                }
                else 
                {
                    FileUtils.copyFile(path + "/" + str,out + "/" + str);
                }
            }
        }
    }

}