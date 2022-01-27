package zygame.utils;

import zygame.display.Image;

/**
 *  实现基本的对齐算法
 */
class Align {

    public static inline var LEFT:String = "left";

    public static inline var RIGHT:String = "right";

    public static inline var TOP:String = "top";

    public static inline var BOTTOM:String = "bottom";

    public static inline var CENTER:String = "center";

    /**
     *  对齐算法
     *  @param display - 
     *  @param v - 
     *  @param h - 
     */
    public static function alignDisplay(display:openfl.display.DisplayObject, v:String,h:String):Void
    {
        v = v == null?CENTER:v;
        h = h == null?CENTER:h;
        switch(v)
        {
            case TOP:
                display.y = 0;
            case BOTTOM:
                display.y = -display.height;
            case CENTER:
                display.y = -display.height*0.5;
        }
        switch(h)
        {
            case LEFT:
                display.x = 0;
            case RIGHT:
                display.x = -display.width;
            case CENTER:
                display.x = -display.width*0.5;
        }
    }

}