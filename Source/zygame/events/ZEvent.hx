package zygame.events;

import openfl.events.Event;

/**
 * 通用带data动态属性的事件
 */
class ZEvent extends Event {
    
    public var data:Dynamic = null;

    public function new(type:String,data:Dynamic = null) {
        super(type,true,false);
        this.data = data;
    }

}