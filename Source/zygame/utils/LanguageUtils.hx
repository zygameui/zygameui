package zygame.utils;

class LanguageUtils {

    private static var currentLanguage:String = "zh";

    private static var languages:Map<String,Dynamic> = new Map<String,Dynamic>();

    /**
     * 设置当前语言
     * @param tag 
     */
    public static function setLanguage(tag:String):Void
    {
        currentLanguage = tag;
    }

    /**
     * 绑定语言实现
     * @param tag 
     * @param data 
     */
    public static function bindLanguage(tag:String,data:Dynamic):Void
    {
        languages.set(tag,data);
    }

    /**
     * 获取语言文，格式为@Key
     * @param id 
     * @return String
     */
    public static function getText(id:String):String
    {
        var data:Dynamic = languages.get(currentLanguage);
        if(data == null)
            return id;
        var key:String = id.substr(1);
        var language:String = Reflect.getProperty(data,key);
        return language!=null?language:key;
    }

}