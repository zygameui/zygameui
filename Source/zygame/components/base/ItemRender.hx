package zygame.components.base;

import zygame.components.ZBox;
import openfl.display.Tile;
import zygame.display.batch.BBox;

/**
 *  单个渲染组件对象
 */
class ItemRender extends ZBox {

    private var _data:Dynamic;
    public var data(get,set):Dynamic;

    public var tileDisplayObject:BBox;

    public function new(){
        super();
        this.visible = false;
    }

    private function get_data():Dynamic
    {
        return _data;
    }

    private function set_data(value:Dynamic):Dynamic
    {
        _data = value;
        this.visible = _data != null;
        return _data;
    }

    private var _selected:Bool;
    public var selected(get,set):Bool;
    private function get_selected():Bool
    {
        return _selected;
    }
    private function set_selected(bool:Bool):Bool
    {
        _selected = bool;
        return _selected;
    }

    

    /**
     * 添加瓦片渲染
     * @param tile 
     */
    public function addTile(tile:Tile):Void
    {
        if(tileDisplayObject == null)
            tileDisplayObject = new BBox();
        tileDisplayObject.addTile(tile);
    }

    /**
     * 承载ItemRender的Scroll是否正在滑动
     * @return Bool
     */
    public function isMoveing():Bool{
        var scroll:ZScroll = cast this.parent.parent;
        if (scroll != null && !scroll.getIsMoveing()) {
            return false;
        }
        return true;
    }
}