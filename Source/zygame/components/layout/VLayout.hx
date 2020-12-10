package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;

/**
 *  竖向布局
 */
class VLayout extends BaseLayout
{
    public var gap:Float;

    override public function layout(box:ZBox):Void
    {
        var iy:Float = 0;
        for(i in 0...box.childs.length)
        {
            box.childs[i].y = iy;
            iy += gap + box.childs[i].height;
        }
    }

}