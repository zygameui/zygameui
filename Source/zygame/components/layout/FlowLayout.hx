package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;
import openfl.display.DisplayObject;

/**
 *  流水布局，需要指定ZBox的宽度或者高度，默认水平布局
 */
class FlowLayout extends BaseLayout
{

    public static inline var HORIZONTAL:String = "horizontal";

    public static inline var VERTICAL:String = "vertical";

    public var direction:String = HORIZONTAL;

    override public function layout(box:ZBox):Void
    {
        if(direction == HORIZONTAL)
            layoutHorizontal(box);
        else
            layoutVertical(box);
    }

    private function layoutHorizontal(box:ZBox):Void
    {
        if(box.isAutoWidth())
            throw "未对ZBox对象设置实际宽度，无法使用FlowLayout布局。";
        var ix:Float = 0;
        var max:Float = 0;
        var iy:Float = 0;
        var child:DisplayObject;
        for(i in 0...box.childs.length)
        {
            child = box.childs[i];
            if(ix + child.width > box.width)
            {
                ix = 0;
                iy += max;
                max = 0;
                child.x = ix;
                child.y = iy;
            }
            else
            {
                child.x = ix;
                child.y = iy;
                ix += child.width;
                if(child.height > max)
                    max = child.height;
            }
        
            
        }
    }

    private function layoutVertical(box:ZBox):Void
    {
        if(box.isAutoHeight())
            throw "未对ZBox对象设置实际高度，无法使用FlowLayout布局。";
        var ix:Float = 0;
        var max:Float = 0;
        var iy:Float = 0;
        var child:DisplayObject;
        for(i in 0...box.childs.length)
        {
            child = box.childs[i];
            if(iy + child.height > box.height)
            {
                iy = 0;
                ix += max;
                max = 0;
                child.x = ix;
                child.y = iy;
            }
            else
            {
                child.x = ix;
                child.y = iy;
                iy += child.height;
                if(child.width > max)
                    max = child.width;
            }
            
        }
    }

}