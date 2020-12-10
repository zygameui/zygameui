package zygame.sensors;

import openfl.events.EventType;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer in A;

/**
 * 针对小游戏平台优化了的重力感应侦听器，通过扩展window的openAccelerometerChange/closeAccelerometerChange方法，进行启动或关闭小游戏的重力感应处理。
 */
class Accelerometer extends A{  

    public function new() {
        super();
    }

    private function open():Void
    {
        #if html5
        if(untyped window.openAccelerometerChange != null)
            untyped window.openAccelerometerChange();
        #end
    }

    /**
     * 删除不再可用
     */
    private function close():Void
    {
        #if html5
        if(untyped window.closeAccelerometerChange != null)
            untyped window.closeAccelerometerChange();
        #end
    }

    /**
     * 侦听事件，针对小游戏平台做了优化，在不需要的时候，请移除侦听器。
     * @param type 
     * @param listener 
     * @param useCapture 
     * @param priority 
     * @param useWeakReference 
     */
    public override function addEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false) {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        if(type == AccelerometerEvent.UPDATE)
            open();
    }

    /**
     * 移除事件，针对小游戏平台做了优化，在不需要的时候，请移除侦听器。
     * @param type 
     * @param listener 
     * @param useCapture 
     */
    public override function removeEventListener<T>(type:EventType<T>, listener:T -> Void, useCapture:Bool = false) {
        super.removeEventListener(type, listener, useCapture);
        if(type == AccelerometerEvent.UPDATE)
            close();
    }

}