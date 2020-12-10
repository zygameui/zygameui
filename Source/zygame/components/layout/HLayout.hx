package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;

/**
 *  竖向布局
 */
class HLayout extends BaseLayout
{
    public var gap:Float;

    override public function layout(box:ZBox):Void
    {
        var ix:Float = 0;
        for(i in 0...box.childs.length)
        {
            box.childs[i].x = ix;
            box.childs[i].y = box.height/2 - box.childs[i].height/2;
            ix += gap + box.childs[i].width;
        }
    }

}