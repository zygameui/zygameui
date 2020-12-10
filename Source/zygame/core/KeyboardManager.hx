package zygame.core;

#if html5
import js.base.KeyboardInput;
#end
import openfl.display.DisplayObject;

class KeyboardManager {

    #if html5
    public static var keyboard:KeyboardInput;
    #end

    public static function init():Void
    {
        #if html5
        var c:Class<Dynamic> = Type.resolveClass("Keyboard");
        if(c == null)
        {
            return;
        }
        keyboard = Type.createInstance(c,[]);
        keyboard.onKeyboardComplete(onKeyboardComplete);
        #end
    }

    public static function onKeyboardComplete():Void
    {
        focus(null);
    }

    /**
     * 获取引擎是否能够支持文本输入功能
     * @return Bool
     */
    public static function isSupportInput():Bool
    {
        #if (minigame && html5)
        return keyboard != null;
        #else
        return true;
        #end
    }

    public static function focus(display:DisplayObject):Void
    {
        var current:Start = Start.current;
        if(display == null)
        {
            current.y = 0;
            return;
        }
        //只有竖版状态时需要调整位置
        if(current.getStageWidth() < current.getStageHeight())
        {
            var moveY:Float = current.stage.stageHeight/2;
            current.y += moveY - moveY/2;
        }
    }

}