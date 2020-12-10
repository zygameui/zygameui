package zygame.utils;

import openfl.geom.Rectangle;

class Scale9Utils {

    /**
     * 根据rect创建九宫格分割区域，提供给tileset使用
     * @param x 
     * @param y 
     * @param width 
     * @param height 
     * @param rect 
     * @return Array<Rectangle>
     */
    public static function createScale9Rects(x:Float,y:Float,width:Float,height:Float,rect:Rectangle):Array<Rectangle>
    {
        var rects:Array<Rectangle> = [];

        //左上
        rects.push(new Rectangle(x,y,rect.x,rect.y));
        //中上
        rects.push(new Rectangle(x + rect.x,y,rect.width,rect.y));
        //右上
        rects.push(new Rectangle(x + rect.width + rect.x,y,width - rect.x - rect.width,rect.y));
        //左中
        rects.push(new Rectangle(x, y + rect.y, rect.x, rect.height));
        //中心
        rects.push(new Rectangle(x + rect.x, y + rect.y, rect.width,rect.height));
        //右中
        rects.push(new Rectangle(x + rect.width + rect.x,y + rect.y,width - rect.x - rect.width, rect.height));
        //左下
        rects.push(new Rectangle(x, y + rect.y + rect.height,rect.x , height - rect.y - rect.height));
        //中下
        rects.push(new Rectangle(x + rect.x, y + rect.y + rect.height,rect.width , height - rect.y - rect.height));
        //右下
        rects.push(new Rectangle(x + rect.x + rect.width ,y + rect.y  + rect.height, width - rect.x - rect.width , height - rect.y - rect.height));
        return rects;
    }

}