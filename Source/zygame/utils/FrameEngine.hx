package zygame.utils;

import zygame.core.Start;
import zygame.core.Refresher;

/**
 * 纯帧事件逻辑驱动工具：
 * FrameEngine.create(function(engine){
 *  //帧逻辑
 *  engine.stop(); //停止
 * })
 */
class FrameEngine implements Refresher {
    
    public function new() {
        
    }

    public static function create(cb:FrameEngine->Void){
        var engine:FrameEngine = new FrameEngine();
        engine.onFrameEvent = cb;
        engine.start();
        return engine;
    }
    
    public function onFrame():Void{
        onFrameEvent(this);
    }

    /**
     * 帧事件处理
     * @param event 
     */
    dynamic public function onFrameEvent(event:FrameEngine){

    }

    /**
     * 开始帧事件
     */
    public function start():Void
    {
        Start.current.addToUpdate(this);
    }

    /**
     * 停止帧事件
     */
    public function stop():Void
    {
        Start.current.removeToUpdate(this);
    }

}