package atlasxml;

import sys.io.File;

/**
 * AtlasXml工具，去重功能
 */
class AtlasTools  {
    
    public static function removeXmlItem(xmlpath:String):Void{
        var xml:Xml = Xml.parse(File.getContent(xmlpath));
        var lastitem:Xml = null;
        var removeXmls:Array<Xml> = [];
        for (item in xml.firstElement().elements()) {
            if(lastitem != null && lastitem.get("x") == item.get("x") && lastitem.get("y") == item.get("y")){
                removeXmls.push(item);
            }
            lastitem = item;
        }
        for (item in removeXmls) {
            xml.firstElement().removeChild(item);
        }
        //重命名
        var index:Int = 10000;
        for (item in xml.firstElement().elements()) {
            item.set("name","Frame"+index);
            index ++;
        }
        File.saveContent(xmlpath + ".2",xml.toString());
    }

}