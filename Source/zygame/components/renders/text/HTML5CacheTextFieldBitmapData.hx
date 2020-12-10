package zygame.components.renders.text;

import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import zygame.utils.ZGC;
import openfl.display.BitmapData;

/**
 * HTML5缓存文本实现，用于解决HTML5平台字体消耗问题
 */
class HTML5CacheTextFieldBitmapData {

    public var width:Int = 0;

    public var height:Int = 0;

    public var selectable:Bool = false;

    public var mouseEnabled:Bool = false;

    public var wordWrap:Bool = false;

    private var textFormat:TextFormat;

    private var _text:String = "";

    public var text(get,set):String;

    public var bitmapData:BitmapData;

    private var canvas:CanvasElement;

    private var context2d:CanvasRenderingContext2D;

    private var rects:Map<String,Rectangle> = [];

    private var gapHeight:Int = 20;

    public var id:String;

    public var drawText:String = "";

    public var drawTime:Int = 0;

    public var line:Int = 1;

    public var isZh:Bool = false;

    private var _fillTextCommand:Array<FillTextCommand> = null;

    /**
     * 最大高度
     */
    private var _maxHeight:Int = 0;

    /**
     * 最大宽度
     */
    private var _maxWidth:Int = 0;

    public function new(){
    }    

    public function setTextFormat(format:TextFormat):Void
    {
        this.textFormat = format;
    }

    private function set_text(text:String):String
    {
        isZh = false;
        text = StringTools.replace(text," ","") + " ";
        if(_text == text)
            return text;
        _text = text;
        this.render();
        return _text;
    }

    private function get_text():String
    {
        return _text;
    }

    public function getCharBoundaries(index:Int,isEmoj:Bool = false):Rectangle
    {
        if(isEmoj)
            return rects.get(_text.charAt(index - 1) + _text.charAt(index));
        return rects.get(_text.charAt(index));
    }

    private function updateMaxWidthAndHeight(rect:Rectangle):Rectangle
    {
        if(_maxWidth < rect.x + rect.width)
            _maxWidth = Std.int(rect.x + rect.width);
        if(_maxHeight < rect.y + rect.height)
            _maxHeight = Std.int(rect.y + rect.height);
        return rect;
    }
    
    private function render():Void
    {
        _fillTextCommand = [];
        line = 1;
        drawTime = 0;
        this.disposeSelf();
        canvas = untyped window.document.createElement("canvas");
        // canvas.width = this.width;
        // canvas.height = this.height;
        context2d = canvas.getContext2d();
        context2d.clearRect(0,0,4096,4096);
        context2d.font = textFormat.size + "px " + (textFormat.font == null?"'sans-serif'":textFormat.font);
        var r = (textFormat.color >> 16) & 0xFF;
		var g = (textFormat.color >> 8) & 0xFF;
		var b = textFormat.color & 0xFF;
        context2d.fillStyle = "rgb("+r+","+g+","+b+")";

        //布局优化
        var height:Int = textFormat.size;
        
        var px:Float = 3;
        var req = ~/[\ud04e-\ue50e]+/;
        var emoj:String = "";
        //获得空格的宽度
        #if !no_spaces
        var bwidth:Float = context2d.measureText(" ").width;
        #end
        _maxWidth = 0;
        _maxHeight = 0;
        for (i in 0...this._text.length) {
            var char = this._text.charAt(i);
            if(isZh == false)
            {
                var code = this._text.charCodeAt(i);
                if(code >= 0x4E00)
                {
                    isZh = true;
                    flushText();
                    px = 3;
                    line ++;
                }
            }
            var width:Float = context2d.measureText(char).width;
            if(px + width + 15 > 2048)
            {
                flushText();
                px = 3;
                line ++;
            }
            else
            {
                
            }
            //HTML5兼容emoj表情
            if(req.match(char)){
                emoj += char;
                if(emoj.length == 2)
                {
                    width = context2d.measureText(emoj).width;
                    drawText += emoj;
                    rects.set(emoj,updateMaxWidthAndHeight(new Rectangle(px, (line - 1) * (height + gapHeight) + gapHeight,width,height + gapHeight)));
                    emoj = "";
                    px += width;
                }
            }
            else
            {
                #if no_cheak_zh
                drawText += char + #if no_spaces "" #else " " #end;
                rects.set(char,updateMaxWidthAndHeight(new Rectangle(px #if !no_spaces - bwidth * 0.125 #end, (line - 1) * (height + gapHeight) + gapHeight,width #if !no_spaces + bwidth * 0.25 #end,height + gapHeight)));
                #else
                if(isZh)
                {
                    drawText += char + #if no_spaces "" #else " " #end;
                    rects.set(char,updateMaxWidthAndHeight(new Rectangle(px #if !no_spaces - bwidth * 0.125 #end, (line - 1) * (height + gapHeight) + gapHeight,width #if !no_spaces + bwidth * 0.25 #end,height + gapHeight)));
                }
                else
                {
                    //单个字绘制
                    drawTime ++;
                    rects.set(char,updateMaxWidthAndHeight(new Rectangle(px #if !no_spaces - bwidth * 0.125 #end, (line - 1) * (height + gapHeight) + gapHeight,width #if !no_spaces + bwidth * 0.25 #end,height + gapHeight)));
                    _fillTextCommand.push(new FillTextCommand(char, px ,line* (this.textFormat.size + gapHeight)));
                }
                #end
                px += width + #if no_spaces 0 #else bwidth #end;
            }   
            if((drawText.length != 0 && i == this._text.length - 1))
            {
                flushText();
            }     
        }
        var ratio:Int = Std.int(line * (height + gapHeight)/2048 * 100);
        this.height = _maxHeight;
        this.width = _maxWidth;
        canvas.width = this.width;
        canvas.height = this.height;
        bitmapData = BitmapData.fromCanvas(canvas);
        context2d.font = textFormat.size + "px " + (textFormat.font == null?"'sans-serif'":textFormat.font);
        context2d.fillStyle = "rgb("+r+","+g+","+b+")";
        for (command in _fillTextCommand) {
            command.draw(context2d);
        }
        _fillTextCommand = null;
        // zygame.core.Start.current.getTopView().addChild(new openfl.display.Bitmap(bitmapData));
        trace("HTMLCacheText ID \""+id+"\" ratio:" + ratio + "% chars:" + _text.length + " drawtime:" + drawTime);
    }

    private function flushText():Void
    {
        drawTime ++;
        _fillTextCommand.push(new FillTextCommand(drawText, 3 ,line* (this.textFormat.size + gapHeight)));
        drawText = "";
    }

    public function dispose():Void
    {
        this.disposeSelf();
        this.rects = null;
    }

    public function disposeSelf():Void
    {
        #if html5
        //需要清理Context上下文
        if(context2d != null)
        {
            context2d.clearRect(0,0,4096,4096);
            if(untyped context2d.cleanup != null)
                untyped context2d.cleanup();
        }
        //需要清理Context上下文
        if(canvas != null && untyped canvas.cleanup != null )
        {
            untyped canvas.cleanup();
        }
        #end
        this.canvas = null;
        this.context2d = null;
        //开始渲染
        if(bitmapData != null)
        {
            ZGC.disposeBitmapData(bitmapData);
            bitmapData = null;
        }
    }
}

class FillTextCommand {

    public var text:String = null;

    public var x:Float = 0;

    public var y:Float = 0;

    public function new(text:String,x:Float,y:Float){
        this.text = text;
        this.x = x;
        this.y = y;
    }

    public function draw(context:CanvasRenderingContext2D):Void
    {
        context.fillText(text,x,y #if wifi + 5 #end);
    }

}