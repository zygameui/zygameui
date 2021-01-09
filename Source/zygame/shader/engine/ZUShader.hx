package zygame.shader.engine;

import zygame.core.Start;
import openfl.display.DisplayObjectShader;

class ZUShader extends DisplayObjectShader implements zygame.core.Refresher{
    
    public function new() {
        super();
        Start.current.addToUpdate(this);
    }
    
    public function onFrame():Void{
        
    }

    /**
     * 释放当前着色器
     */
    public function dispose():Void{
        Start.current.removeToUpdate(this);
    }

}