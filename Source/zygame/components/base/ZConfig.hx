package zygame.components.base;

/**
 * 全局配置
 */
class ZConfig {

    /**
     * 文本字体指向
     */
    public static var fontName:String =#if html5 null #else "assets/DroidSansFallbackFull.ttf" #end;

}