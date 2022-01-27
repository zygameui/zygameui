package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;
import zygame.components.base.Component;

/**
 *  实现自由布局，能够使用left/right/top/bottom/centerX/centerY的配置方案
 */
class FreeLayout extends BaseLayout {

    /**
     *  实施布局
     *  @param component - 将要布局的对象，必须是ZBox对象
     */
    override public function layout(box:ZBox):Void
    {
        for(i in 0...box.childs.length)
        {
            if(Std.isOfType(box.childs[i],Component)){
                var c:Component = cast box.childs[i];
                if(c.hasLayoutData())
                {
                    if(c.layoutData.left != null && c.layoutData.right != null)
                    {
                        c.x = c.layoutData.left;
                        c.width = box.width - c.layoutData.right - c.x;
                    }
                    else if(c.layoutData.left != null)
                    {
                        c.x = c.layoutData.left;
                    }
                    else if(c.layoutData.right != null)
                    {
                        c.x = box.width - c.layoutData.right;
                    }
                    else if(c.layoutData.centerX != null)
                    {
                        c.x = box.width/2 - c.width/2 + c.layoutData.centerX;
                    }

                    if(c.layoutData.top != null && c.layoutData.bottom != null)
                    {
                        c.y = c.layoutData.top;
                        c.height = box.height - c.layoutData.bottom - c.y;
                    }
                    else if(c.layoutData.top != null)
                    {
                        c.y = c.layoutData.top;
                    }
                    else if(c.layoutData.bottom != null)
                    {
                        c.y = box.height - c.layoutData.bottom;
                    }
                    else if(c.layoutData.centerY != null)
                    {
                        c.x = box.height/2 - c.height/2 + c.layoutData.centerY;
                    }
                }
            }
        }
    }

}