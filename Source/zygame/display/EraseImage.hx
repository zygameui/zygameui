package zygame.display;

import zygame.display.Image;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapDataChannel;
import openfl.display.Bitmap;

/**
 * 可用于支持擦除类型的图片，这里的擦除是擦拭过的地方会进行显示
 */
class EraseImage extends Image{

    /**
     * 用于遮罩模板使用的位图，如擦除的范围，需要擦除的地方请使用红色。如果不提供这个，则不计算擦除范围，按照整张范围计算。
     */
    private var _maskBitmapData:BitmapData;

    /**
     * 用于擦除显示的位图数据
     */
    private var _targetBitmapData:BitmapData;

    /**
     * 绘制副本
     */
    private var _cloneBitmap:Bitmap;

    /**
     * 画板
     */
    private var _draw:BitmapData;
    private var _sprite:Sprite;

    /**
     * 是否按下，可以开始绘制使用
     */
    private var _isDown:Bool;

    /**
     * 记录鼠标的上一次
     */
    private var _lastPos:Point = new Point();

    /**
     * 百分比网格
     */
    private var _drawArray:Array<Array<Bool>> = [];
    private var _drawTrueCount:Int = 0;
    private var _drawAllTrueCount:Int = 0;

    /**
     * 擦除对象，被擦的对象是需要显示的对象
     * @param bitmapData 被遮挡对象
     * @param targetBitmapData 被擦拭对象
     * @param maskBitmapData 被擦拭计算蒙版，不传则按整张计算
     */
    public function new(bitmapData:BitmapData,targetBitmapData:BitmapData,maskBitmapData:BitmapData = null){
        super(bitmapData);
        _maskBitmapData = maskBitmapData;
        _targetBitmapData = targetBitmapData;

        //创建一个画笔
        _sprite = new Sprite();
        _draw = new BitmapData(targetBitmapData.width,targetBitmapData.height,true,0);

        //计算出百分比网格状态 false（未绘制）true（已绘制）
        for(ix in 0...Std.int(bitmapData.width/5))
        {
            _drawArray[ix] = [];
            for(iy in 0...Std.int(bitmapData.height/5))
            {
                _drawArray[ix][iy] = false;
                //用于计算百分比总数使用
                _drawAllTrueCount++;
            }
        }

        //创建一个副本，避免修改源数据
        _cloneBitmap = new Bitmap(targetBitmapData.clone());
        _cloneBitmap.smoothing = #if !smoothing false #else true #end;
        this.addChild(_cloneBitmap);

        //初始化画布
        updateBitmapData();
    }

    /**
     * 初始化
     */
    override public function onInit():Void
    {
        super.onInit();
        //侦听绘制逻辑
        stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
        stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
    }

    /**
     * 释放
     */
    override public function onRemove():Void
    {
        super.onRemove();
        stage.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
        _cloneBitmap.bitmapData.dispose();
        _cloneBitmap.bitmapData.disposeImage();
        _cloneBitmap.bitmapData = null;
        _targetBitmapData = null;
        _draw.dispose();
        _draw.disposeImage();
        _draw = null;
        _maskBitmapData = null;
    }

    override private function set_pivotX(f:Float):Float
    {
        _cloneBitmap.x = -f;
        return get_pivotX();
    }

    override private function set_pivotY(f:Float):Float
    {
        _cloneBitmap.y = -f;
        return get_pivotY();
    }

    override public function alignPivot(v:String = null,h:String = null):Void
    {
        super.alignPivot(v,h);
        if(_cloneBitmap != null)
            zygame.utils.Align.alignDisplay(_cloneBitmap,v,h);
    }

    /**
     * 获取擦除百分比
     * @return Float
     */
    public function getPercentage():Float
    {
        return _drawTrueCount/_drawAllTrueCount;
    }

    /**
     * 设置新的擦除范围
     * @param maskBitmapData 
     */
    public function setMaskBitmapData(maskBitmapData:BitmapData):Void
    {
        _maskBitmapData = maskBitmapData;
    }

    /**
     * 清除画布
     */
    public function clear():Void
    {
        _draw.fillRect(_draw.rect,0);
        updateBitmapData();
        _drawTrueCount = 0;
        for(ix in 0...Std.int(bitmapData.width/5))
            for(iy in 0...Std.int(bitmapData.height/5))
                _drawArray[ix][iy] = false;
    }

    /**
     * 刷新位图
     * @param rect 
     * @param pos 
     */ 
    private function updateBitmapData(rect:Rectangle = null,pos:Point = null):Void
    {
        if(rect == null)
            rect = new Rectangle(0,0,_draw.width,_draw.height);
        if(rect.x < 0)
        {
            rect.width += rect.x;
            rect.x = 0;
            pos.x = 0;
        }
        if(rect.y < 0)
        {
            rect.height += rect.y;
            rect.y = 0;
            pos.y = 0;
        }
        if(pos == null)
            pos = new Point();
        #if cpp
        //C++版本需要实现以下逻辑
        _cloneBitmap.bitmapData.copyPixels(_targetBitmapData,rect,pos);
        #end    
        _cloneBitmap.bitmapData.copyChannel(_draw,rect,pos, BitmapDataChannel.RED,BitmapDataChannel.ALPHA);   
    }

    private function onMove(e:MouseEvent):Void
    {
        if(!_isDown)
            return;
        
        // 绘制逻辑
        _sprite.graphics.clear();
        _sprite.graphics.beginFill(0xff0000,1);
        _sprite.graphics.lineStyle(40,0xff0000,1);
        _sprite.graphics.moveTo(_lastPos.x,_lastPos.y);
        _sprite.graphics.lineTo(getMouseX(),getMouseY());
        _sprite.graphics.endFill();

        _draw.draw(_sprite,null,null,null,null,true);
        var rect:Rectangle = _sprite.getBounds(null);
        updateBitmapData(rect,new Point(rect.x,rect.y));
        
        //计算擦除范围
        var xid:Int = Std.int(rect.x/5);
        var yid:Int = Std.int(rect.y/5);
        var wlen:Int = Std.int(rect.width/5);
        var hlen:Int = Std.int(rect.height/5);
        for(ix in xid...xid+wlen)
        {
            for(iy in yid...yid+hlen)
            {
                if(_draw.getPixel(ix*5,iy*5) != 0 && (_maskBitmapData == null || _maskBitmapData.getPixel(ix*5,iy*5) != 0))
                {
                    if(_drawArray[ix] != null && _drawArray[ix][iy] == false)
                    {
                        _drawArray[ix][iy] = true;
                        _drawTrueCount++;
                    }
                }
            }
        }

        _lastPos.x = getMouseX();
        _lastPos.y = getMouseY();
    }

    private function getMouseX():Float
    {
        return this.mouseX + pivotX;
    }

    private function getMouseY():Float
    {
        return this.mouseY + pivotY;
    }

    private function onDown(e:MouseEvent):Void
    {
        _isDown = true;
        _lastPos.x = getMouseX();
        _lastPos.y = getMouseY();
        onMove(null);
    }

    private function onUp(e:MouseEvent):Void
    {
        _isDown = false;
    }

}