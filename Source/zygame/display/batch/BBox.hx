package zygame.display.batch;

import openfl.display.Tile;
import zygame.display.batch.BSprite;
import zygame.display.batch.ITileDisplayObject;
import zygame.display.batch.BDisplayObject;
import zygame.display.batch.BDisplayObjectContainer;

@:keep
class BBox extends BSprite{

    // private var _width:Float = 0;
    // private var _height:Float = 0;

    // override private function get_width():Float
    // {
    //     return _width;
    // }
    // override private function set_width(f:Float):Float
    // {
    //     _width = f;
    //     return f;
    // }

    // /**
    //  * 获取高
    //  */
    // override private function get_height():Float
    // { 
    //     return _height;
    // }
    // override private function set_height(f:Float):Float
    // {
    //     _height = f;
    //     return f;
    // }

    private var _width:Float = 0;
    private var _height:Float = 0;

    override private function get_width():Float
    {
        var w:Float = super.width;
        if(w > _width)
            return w;   
        return _width;
    }
    override private function set_width(f:Float):Float
    {
        _width = f;
        return f;
    }

    /**
     * 获取高
     */
    override private function get_height():Float
    {
        var h:Float = super.height;
        if(h > _height)
            return h;   
        return _height;
    }
    override private function set_height(f:Float):Float
    {
        _height = f;
        return f;
    }


}


class BLayoutBox extends BBox
{

    /**
     * 添加到布局中
     * @param tile 
     */
    public function addLayout(tile:ITileDisplayObject):Void
    {
        super.addChild(cast(tile,Tile));
    }

    /**
     * 更新布局，以及宽度高度
     */
    public function updateLayout():Void
    {

    }

}

class VBBox extends BLayoutBox {

    /**
     * 间隔
     */
    public var gap:Int = 0;

    /**
     * 更新布局
     */
    override public function updateLayout():Void
    {
        var mathy:Float = 0;
        for(i in 0...this.numTiles)
        {
            var tile:Tile = this.getTileAt(i);
            tile.y = mathy;
            if(Std.isOfType(tile,BDisplayObject))
            {
                mathy += cast(tile,BDisplayObject).height + gap;
            }
            else if(Std.isOfType(tile,BDisplayObjectContainer))
            {
                mathy += cast(tile,BDisplayObjectContainer).height + gap;
            }
        }
    }

}

class HBBox extends BLayoutBox {

    /**
     * 间隔
     */
    public var gap:Int = 0;

    /**
     * 更新布局
     */
    override public function updateLayout():Void
    {
        var mathx:Float = 0;
        for(i in 0...this.numTiles)
        {
            var tile:Tile = this.getTileAt(i);
            tile.x = mathx;
            if(Std.isOfType(tile,BDisplayObject))
            {
                mathx += cast(tile,BDisplayObject).width + gap;
            }
            else if(Std.isOfType(tile,BDisplayObjectContainer))
            {
                mathx += cast(tile,BDisplayObjectContainer).width + gap;
            }
        }
    }

}