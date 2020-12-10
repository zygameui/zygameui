package zygame.components.base;

import openfl.events.Event;
import openfl.display.OpenGLRenderer;
import openfl.text.TextField;
#if (openfl <= '9.0.0')
import openfl._internal.renderer.context3D.Context3DBitmap;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.context3D.Context3DDisplayObject;
#end
import openfl.display.BitmapData;

/**
 * 针对TextField做了渲染优化，会有更优的内存释放表现。一般不直接使用ZTextField，请直接使用ZLabel类。
 */
@:access(openfl._internal.text.TextEngine)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)
@:access(openfl.display.BitmapData)
class ZTextField extends TextField 
{

    private static var initTextFieldWindow:Bool = false;

    private static var compositionstart:Bool = false;

    @:noCompletion private override function __cleanup ():Void {
        #if js
        //进行深度清理
        js.Syntax.code("
        if(this.__graphics != null && this.__graphics.__bitmap != null)
        {
            if(this.__graphics.__bitmap.__texture != null)
            {
                this.__graphics.__bitmap.__texture.dispose();
                this.__graphics.__bitmap.__texture = null;
            }
            this.__graphics.__bitmap.dispose();
        }
        if(this.__graphics != null && this.__graphics.__canvas != null && this.__graphics.__canvas.cleanup != null)
            this.__graphics.__canvas.cleanup();");
        #end
		super.__cleanup ();

	}
    
    /**
     * 优化使用输入法时输入重叠的问题
     */
    @:noCompletion override private function __enableInput():Void
	{
        #if js
        if(!initTextFieldWindow)
        {
            initTextFieldWindow = true;
            untyped window.document.addEventListener("compositionstart",function(e){
				if(compositionstart == false)
					compositionstart = true;
			});
        }
        #end
        super.__enableInput();
    }

    /**
     * 优化使用输入法时输入重叠的问题
     */
    @:noCompletion override private function window_onTextInput(value:String):Void
	{
		if(compositionstart){
			compositionstart = false;
			return;
		}
        super.window_onTextInput(value);
	}

    override public function set_text(value:String):String
    {
        if(text != value)
        {
            super.text = value;
        }
        return value;
    }

}