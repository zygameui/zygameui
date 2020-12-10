package zygame.macro;

import zygame.utils.StringUtils;
#if macro

import sys.FileSystem;
import sys.io.File;
#end
class ZBuilderData {
    #if macro

    public var assetsLoads:Array<String> = [];

    public var ids:Map<String,String> = [];

    public var content:String;

    public function new(xmlPath:String) {
        if(!FileSystem.exists(xmlPath)){
            throw "Xml file '" + xmlPath + "' is not exists!";
        }
        content = File.getContent(xmlPath);
        var xml:Xml = Xml.parse(content);
        parserXml(xml.firstElement());
    }

    private function parserXml(xml:Xml):Void{
        parserItem(xml);
        for (item in xml.elements()) {
            parserXml(item);
        }
    }

    private function parserItem(item:Xml){
        if(item.exists("id")){
            ids.set(item.get("id"),item.nodeName);
        }
        if(item.exists("src")){
            var src = item.get("src");
            if(src.indexOf(":") != -1){
                src = src.substr(0,src.lastIndexOf(":"));
            }
            else
            {
                src = StringUtils.getName(src);
            }
            if(assetsLoads.indexOf(src) == -1)
            {
                assetsLoads.push(src);
            }
        }
    }

	#end
}
