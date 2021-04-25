package zygame.components.layout;

import zygame.components.layout.BaseLayout;
import zygame.components.ZBox;
import zygame.components.ZList;
import zygame.components.data.ListData;
import zygame.components.base.ItemRender;

/**
 *  提供给ZList的性能排序使用
 */
class ListLayout extends BaseLayout
{
    public var virtualWidth:Float = 0;
 
    public var virtualHeight:Float = 0;

    public static inline var HORIZONTAL:String = "horizontal";

    public static inline var VERTICAL:String = "vertical";

    public var direction:String = VERTICAL;

    override public function layout(box:ZBox):Void
    {
        if(Std.isOfType(box.parent,ZList)){
            if(direction == VERTICAL)
                layoutListV(cast box.parent);
            else if(direction == HORIZONTAL)
                layoutListH(cast box.parent);
        }
        else
            throw "ListLayout布局只能在ZList中使用，如果需要竖向/横向布局，请使用VLayout或者HLayout。";
    }

    public function layoutListV(list:ZList):Void
    {  
        //获取数据
        var data:ListData = cast list.dataProvider;
        if(data == null)
            return;

        //虚拟高度
        var itemOnw:ItemRender = virtualHeight == 0?list.createItemRender(null):null;
        if(itemOnw != null){
            list.view.addChildSuper(itemOnw);
            if(itemOnw.tileDisplayObject != null)
                list.batch.getBatchs().addChild(itemOnw.tileDisplayObject);
            virtualHeight = itemOnw.height + list.gap;
            if(list.cache == false)
                list.removeItemRender(itemOnw);
        }
        
        //重置容器的高度
        list.view.height = data.length * virtualHeight;

        //开始索引
        var startIndex:Int = Std.int(list.vscroll/virtualHeight);
        if(startIndex < 0)
            startIndex = 0;
        //结束索引
        var endIndex:Int = Std.int(list.height/virtualHeight) + 1;
        if(endIndex > data.length - startIndex - 1 || endIndex + startIndex > data.length)
            endIndex = data.length - startIndex - 1;
        endIndex += startIndex;
        

        //计算复用关系
        var count:Int = list.cache?startIndex:0;
        var index:Int = startIndex;

        for(c in list.view.childs){
            c.visible = false;
            if(cast(c,ItemRender).tileDisplayObject != null)
                cast(c,ItemRender).tileDisplayObject.visible = false;
        }

        while(index <= endIndex)
        {
            var itemdata = data.getItem(index);
            if(count >= list.view.childs.length)
            {
                var item:ItemRender = list.createItemRender(itemdata);
                item.visible = true;
                list.addChildSuper(item);
                item.y = (virtualHeight)*index;
                if(item.tileDisplayObject != null){
                    item.tileDisplayObject.y = item.y;
                    item.tileDisplayObject.visible = true;
                }
                updateData(item,itemdata,list.currentSelectItem != null && list.currentSelectItem == data.getItem(index));
            }
            else
            {
                var itemCopy:ItemRender = cast list.view.childs[count];
                itemCopy.y = (virtualHeight)*index;
                itemCopy.visible = true;
                if(itemCopy.tileDisplayObject != null){
                    itemCopy.tileDisplayObject.y = itemCopy.y;
                    itemCopy.tileDisplayObject.visible = true;
                }
                updateData(itemCopy,itemdata,list.currentSelectItem != null && list.currentSelectItem == data.getItem(index));
            }
            count++;
            index++;
            if(count >= data.length)
                break;
        }

        //将多余的组件移除
        var len:Int = list.view.childs.length;
        for(del in count...len)
        {
            list.removeItemRender(cast list.view.childs[del]);
        }
    }

    /**
     *  更新data资源，相同的data不重复更新
     *  @param item - 
     *  @param data - 
     */
    public function updateData(item:ItemRender,data:Dynamic,selected:Bool):Void
    {
        if(selected != item.selected)
            item.selected = selected;
        if(data != item.data){
            item.data = data; 
        } 
    }

    public function layoutListH(list:ZList):Void
    {  
        //获取数据
        var data:ListData = cast list.dataProvider;
        if(data == null)
            return;

        //虚拟高度
        var itemOnw:ItemRender = virtualWidth == 0?list.createItemRender(null):null;
        if(itemOnw != null){
            list.view.addChildSuper(itemOnw);
            if(itemOnw.tileDisplayObject != null)
                list.batch.getBatchs().addChild(itemOnw.tileDisplayObject);
            virtualWidth = itemOnw.width + list.gap;
            if(list.cache == false)
                list.removeItemRender(itemOnw);
        }
        
        
        //重置容器的高度
        list.view.width = data.length * virtualWidth;

        //开始索引
        var startIndex:Int = Std.int(list.hscroll/virtualWidth);
        if(startIndex < 0)
            startIndex = 0;
        //结束索引
        var endIndex:Int = Std.int(list.width/virtualWidth) + 1;
        if(endIndex > data.length - startIndex - 1 || endIndex + startIndex > data.length)
            endIndex = data.length - startIndex - 1;
        endIndex += startIndex;

        for(c in list.view.childs){
            c.visible = false;
            if(cast(c,ItemRender).tileDisplayObject != null)
                cast(c,ItemRender).tileDisplayObject.visible = false;
        }

        //计算复用关系
        var count:Int = list.cache?startIndex:0;
        var index:Int = startIndex;
        while(index <= endIndex)
        {
            var itemData = data.getItem(index);
            if(count >= list.view.childs.length)
            {
                var item:ItemRender = list.createItemRender(itemData);
                list.view.addChildSuper(item);
                item.x = (virtualWidth)*index;
                item.visible = true;
                if(item.tileDisplayObject != null){
                    item.tileDisplayObject.y = item.y;
                    item.tileDisplayObject.visible = true;
                }
                updateData(item,itemData,list.currentSelectItem != null && list.currentSelectItem == data.getItem(index));
            }
            else
            {
                var itemCopy:ItemRender = cast list.view.childs[count];
                itemCopy.x = (virtualWidth)*index; 
                itemCopy.visible = true;
                if(itemCopy.tileDisplayObject != null){
                    itemCopy.tileDisplayObject.y = itemCopy.y;
                    itemCopy.tileDisplayObject.visible = true;
                }
                updateData(itemCopy,itemData,list.currentSelectItem != null && list.currentSelectItem == data.getItem(index));
            }
            count++;
            index++;
        }

        //将多余的组件移除
        var len:Int = list.view.childs.length;
        for(del in count...len)
        {
            list.removeItemRender(cast list.view.childs[del]);
        }
    }
}