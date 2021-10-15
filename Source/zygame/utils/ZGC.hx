
package zygame.utils;

import lime.graphics.Image;
import openfl.display.ITileContainer;
import zygame.display.batch.ImageBatchs;
import zygame.core.Start;
import zygame.core.Refresher;
import openfl.display.TileContainer;
import openfl.display.MovieClip;
import openfl.display.DisplayObjectContainer;
import openfl.display.Bitmap;
#if (openfl <= '9.0.0')
import openfl._internal.symbols.SpriteSymbol;
#if (openfl >= '8.7.0')
import openfl._internal.symbols.timeline.Frame;
import openfl._internal.symbols.timeline.FrameObject;
#end
#end
import openfl.display.DisplayObject;
import openfl.display.BitmapData;

/**
 * 一些特定的清理器，请务必谨慎调用这些方法，会导致纹理无法再次渲染。该方法可释放掉容器里的所有对象，但需要注意传入GC的对象，如果容器里包含了不想清理的对象，也会被一并清理掉。
 */
@:access(openfl._internal.symbols.SWFSymbol)
@:access(openfl.display.MovieClip)
class ZGC {

    /**
     * 准备GC的列表
     */
    public static var GCLIST:Array<DisplayObject> = [];

    /**
     * GC运作
     */
    public static function onFrame():Void
    {
        if(GCLIST.length > 0)
        {
            disposeDisplayObject(GCLIST.shift());
        }
    }

    public static function disposeDisplayObject(display:DisplayObject,addGC:Bool = false):Void
    {
        if(display == null)
            return;
        if(addGC)
        {
            if(GCLIST.indexOf(display) == -1){
                GCLIST.push(display);
            }
            return;
        }

        //卸载cacheBitmapData缓存对象
        // //trace(@:privateAccess display.__cacheBitmap);
        // //trace(@:privateAccess display.__cacheBitmapData);
        // //trace(@:privateAccess display.__cacheBitmapData2);
        // //trace(@:privateAccess display.__cacheBitmapData3);
        disposeBitmap(@:privateAccess display.__cacheBitmap);
        disposeBitmapData(@:privateAccess display.__cacheBitmapData);
        disposeBitmapData(@:privateAccess display.__cacheBitmapData2);
        disposeBitmapData(@:privateAccess display.__cacheBitmapData3);

        if(Std.isOfType(display,MovieClip))
        {
            //影片剪辑释放
            disposeMovieClip(cast display);
        }
        else if(Std.isOfType(display,Bitmap))
        {
            //影片剪辑释放
            disposeBitmap(cast display);
        }
        else if(Std.isOfType(display,DisplayObjectContainer))
        {
            //精灵释放
            disposeSprite(cast display);
        }
    }

    /**
     * 释放位图纹理
     * @param display 
     */
    public static function disposeBitmap(display:Bitmap):Void
    {
        if(display != null && display.bitmapData != null){

            //进行深度清理
            var bitmapData:Dynamic = display.bitmapData;
            disposeBitmapData(bitmapData);
        }
    }

    /**
     * 释放位数数据
     * @param bitmapData 
     */
    public static function disposeBitmapData(bitmapData:BitmapData):Void
    {
        if(bitmapData == null)
            return;
        GPUUtils.removeBitmapData(bitmapData);
        #if js
        // var getImage:Image = @:privateAccess bitmapData.image;
        // if(getImage != null && getImage.buffer != null && untyped getImage.buffer.__srcImage != null && untyped getImage.buffer.__srcImage.disposeImage != null)
        // {
        //     //卸载内存
        //     untyped getImage.buffer.__srcImage.disposeImage();
        //     untyped getImage.buffer.__srcImage = null;
        // }
        js.Syntax.code("
        if(bitmapData != null)
        {
            if(bitmapData.__vertexBuffer != null && bitmapData.__vertexBuffer.__context != null)
            {
                bitmapData.__vertexBuffer.__context.gl.deleteBuffer(bitmapData.__vertexBuffer.__id);
                bitmapData.__vertexBuffer = null;
            }
            if(bitmapData.__texture != null)
            {
                bitmapData.__texture.dispose();
                bitmapData.__texture = null;
            }
            bitmapData.dispose();
        }
        if(bitmapData != null && bitmapData.__canvas != null && bitmapData.__canvas.cleanup != null){
            bitmapData.__canvas.cleanup();
            bitmapData.__canvas = null;
        }");
        #end
        if(@:privateAccess bitmapData.image != null && @:privateAccess bitmapData.image.src != null)
        {
            @:privateAccess bitmapData.image.src = null;
        }
        bitmapData.dispose();
        bitmapData.disposeImage();
        bitmapData = null;

        // #if vivo
        // untyped qg.triggerGC();
        // #end
    }

    /**
     * 对MovieClip的纹理进行释放
     * @param mc 
     */
    public static function disposeMovieClip(mc:MovieClip):Void
    {   
        #if (openfl_swf && openfl < '9.0.0')
        var iterator:Iterator<Dynamic> = mc.__activeInstancesByFrameObjectID.iterator(); 
        while(iterator.hasNext())
        {
            var displayObject:DisplayObject = iterator.next().displayObject;
            disposeDisplayObject(displayObject, true);
        }
        #end
    }

    /**
     * 对Sprite的纹理进行释放
     * @param spr 
     */
    public static function disposeSprite(spr:DisplayObjectContainer):Void
    {
        for(i in 0...spr.numChildren)
        {
            disposeDisplayObject(spr.getChildAt(i));
        }   
    }

    /**
     * 清理Tile容器中的Refresher引用
     * @param spr 
     */
    public static function disposeTileRefresher(spr:TileContainer):Void
    {
        for(i in 0...spr.numTiles)
        {
            var tile = spr.getTileAt(i);
            if(Std.isOfType(tile,TileContainer))
            {
                disposeTileRefresher(cast tile);
            }
            else if(Std.isOfType(tile,Refresher))
            {
                Start.current.removeToUpdate(cast tile);
            }
        }
    }

    /**
     * 释放指定对象内含的FrameEvent事件
     * @param display 
     */
    public static function disposeFrameEvent(display:Dynamic):Void
    {
        if(Std.isOfType(display,Refresher))
        {
            Start.current.removeToUpdate(cast display);
        }
        if(Std.isOfType(display,ITileContainer))
        {
            for (i in 0...cast(display,ITileContainer).numTiles) {
                disposeFrameEvent(cast(display,ITileContainer).getTileAt(i));
            }
        }
        else if(Std.isOfType(display,DisplayObjectContainer))
        {
            for (i in 0...cast(display,DisplayObjectContainer).numChildren) {
                disposeFrameEvent(cast(display,DisplayObjectContainer).getChildAt(i));
            }
        }
    }

}