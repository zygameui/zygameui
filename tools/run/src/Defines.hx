
/**
 * 定义器
 */
class Defines {
    
    public static var defineMaps:Map<String,String> = [];

    public static function define(name:String,value:String = null):Void
    {
        trace("Define "+name+"="+value);
        defineMaps.set(name,value);
    }

    /**
     * 是否定义
     * @param name 
     * @return Bool
     */
    public static function isDefine(name:String):Bool
    {
        return defineMaps.exists(name);
    }

    /**
     * 检查是否可以运行
     * @param item 
     * @return Bool
     */
    public static function cheak(item:Xml):Bool
    {
        if(item.nodeName == "assets")
            return true;
        var result:Bool = item.exists("if")?false:true;
        if(item.exists("if"))
        {
            var data = item.get("if");
            if(data.indexOf("||") != -1){
                if(cheakDefineOr(item.get("if")))
                    result = true;
            }
            else{
                if(cheakDefineAnd(item.get("if")))
                    result = true;
            }
        }
        if(result == false && item.exists("unless"))
        {
            if(!cheakDefineOr(item.get("unless")))
                result = true;
        }
        return result;
    }

    private static function cheakDefineAnd(data:String):Bool
    {
        var array = data.split(" ");
        for (s in array) {
            if(s == "||")
                continue;
            if(!defineMaps.exists(s))
                return false;
        }
        return true;
    }

    private static function cheakDefineOr(data:String):Bool
    {
        var array = data.split(" ");
        for (s in array) {
            if(defineMaps.exists(s))
                return true;
        }
        return false;
    }
}