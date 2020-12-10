package zygame.components;

import zygame.components.base.Component;
import zygame.components.layout.BaseLayout;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * 容器盒子，用于实现布局排版功能
 */
class ZBox extends Component
{
    /**
     *  添加到容器盒子里会记录所有的子项
     */
    public var childs:Array<DisplayObject>;

    public function new()
    {
        super();
        childs = [];
    }

    override public function initComponents():Void
    {
        
    }

    /**
     *  ZBox负责刷新布局容器
     */
    override public function updateComponents():Void
    {
        if(layout != null)
        {
            //布局排版
            layout.layout(this);
        }
        // 可能对性能有影响
        // for(i in 0...childs.length)
        // {
        //     if(Std.is(childs[i],Component))
        //     {
        //         var box:Component = cast childs[i];
        //         if(box.isInit)
        //             box.updateComponents();
        //     }
        // }
    }

    override public function addChild(display:DisplayObject):DisplayObject
    {
        return super.addChild(display);
    }

    override public function addChildAt(display:DisplayObject,index:Int):DisplayObject
    {
        childs.push(display);
        var child:DisplayObject = super.addChildAt(display,index);
        this.updateComponents();
        return child;
    }

    public function addChildSuper(display:DisplayObject):DisplayObject
    {
        childs.push(display);
        return super.addChildAt(display,this.numChildren);
    }

    public function removeChildSuper(display:DisplayObject):DisplayObject
    {
        childs.remove(display);
        return super.removeChild(display);
    }

    override public function removeChild(display:DisplayObject):DisplayObject
    {
        childs.remove(display);
        this.updateComponents();
        return super.removeChild(display);
    }

    private var _layout:BaseLayout;
    /**
     *  设置布局对象，用于控制Box里的容器显示位置
     */
    public var layout(get,set):BaseLayout;
    private function get_layout():BaseLayout
    {
        return _layout;
    }
    private function set_layout(value:BaseLayout):BaseLayout
    {
        if(stage == null)
            throw "请在组件初始化完毕后调用。";
        _layout = value;
        this.updateComponents();
        return value;
    }

    private var _componentWidth:Float = 0;

    private var _componentHeight:Float = 0;
    
    #if flash
    @:setter(width)
    public function set_width(value:Float):Float
    {
        _componentWidth = value;
        return value;
    }
    @:setter(height)
    public function set_height(value:Float):Float
    {
        _componentHeight = value;
        return value;
    }
    @:getter(width)
    public function get_width():Float
    {
        if(_componentWidth == 0)
            return super.width;
        return _componentWidth;
    }
    @:getter(height)
    public function get_height():Float
    {
        if(_componentHeight == 0)
            return super.height;
        return _componentHeight;
    }
    #else
    override private function set_width(value:Float):Float
    {
        _componentWidth = value;
        return value;
    }

    override private function set_height(value:Float):Float
    {
        _componentHeight = value;
        return value;
    }

    override private function get_width():Float
    {
        if(_componentWidth == 0)
            return Math.abs(super.width);
        return _componentWidth;
    }
    override private function get_height():Float
    {
        if(_componentHeight == 0)
            return Math.abs(super.height);
        return _componentHeight;
    }
    #end
    public function isAutoWidth():Bool
    {
        return _componentWidth == 0;
    }

    public function isAutoHeight():Bool
    {
        return _componentHeight == 0;
    }

    /**
     *  对齐功能
     *  @param obj - 对齐对象
     *  @param leftPx - 左对齐
     *  @param rightPx - 右对齐
     *  @param topPx - 顶部对齐
     *  @param bottomPx - 底部对齐
     *  @param centerX - 居中对齐
     *  @param centerY - 垂直对齐
     */
    public function align(obj:DisplayObject, leftPx:Dynamic = null, rightPx:Dynamic = null, topPx:Dynamic= null, bottomPx:Dynamic= null,centerX:Dynamic = 0,centerY:Dynamic = 0):Void
    {
        if(Std.is(leftPx,String))
            leftPx = Std.parseInt(leftPx);
        if(Std.is(rightPx,String))
            rightPx = Std.parseInt(rightPx);
        if(Std.is(topPx,String))
            topPx = Std.parseInt(topPx);
        if(Std.is(bottomPx,String))
            bottomPx = Std.parseInt(bottomPx);
        if(Std.is(centerX,String))
            centerX = Std.parseInt(centerX);
        if(Std.is(centerY,String))
            centerY = Std.parseInt(centerY);
        var rect:Rectangle = obj.getBounds(obj.parent);
        var pos:Point = new Point(rect.x,rect.y);
        pos.x -= obj.x;
        pos.y -= obj.y;
        pos.x *= -1;
        pos.y *= -1;
        if(leftPx != null)
            obj.x = cast(leftPx,Int) + pos.x;
        else if(rightPx != null)
            obj.x = this.width - cast(rightPx,Int) + pos.x - rect.width;
        else if(centerX != null)
            obj.x = this.width /2 + cast(centerX,Int) + pos.x - rect.width/2;
        if(topPx != null)
            obj.y = cast(topPx,Int) + pos.y;
        else if(bottomPx != null)
            obj.y = this.height - cast(bottomPx,Int) + pos.y - rect.height;
        else if(centerY != null)
            obj.y = this.height/2 + cast(centerY,Int) + pos.y - rect.height/2;
    }
}


class ZLayoutBox extends zygame.display.DisplayObjectContainer
{

    /**
     * 更新布局，以及宽度高度
     */
    public function updateLayout():Void
    {

    }

    private var _componentWidth:Float = 0;

    private var _componentHeight:Float = 0;
    
    override private function set_width(value:Float):Float
    {
        _componentWidth = value;
        return value;
    }

    override private function set_height(value:Float):Float
    {
        _componentHeight = value;
        return value;
    }

    override private function get_width():Float
    {
        if(_componentWidth == 0 || super.width > _componentWidth)
            return super.width;
        return _componentWidth;
    }
    override private function get_height():Float
    {
        if(_componentHeight == 0 || super.height > _componentHeight)
            return super.height;
        return _componentHeight;
    }

}

class VBox extends ZLayoutBox {

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
        for(i in 0...this.numChildren)
        {
            var tile:DisplayObject = this.getChildAt(i);
            tile.y = mathy;
            mathy += tile.height + gap;
        }
    }

}

class HBox extends ZLayoutBox {

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
        for(i in 0...this.numChildren)
        {
            var tile:DisplayObject = this.getChildAt(i);
            tile.x = mathx;
            mathx += tile.width + gap;
        }
    }

}