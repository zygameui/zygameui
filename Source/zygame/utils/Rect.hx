package zygame.utils;

import openfl.events.EventDispatcher;
import openfl.events.Event;

class Rect extends EventDispatcher {

    private var _x:Float;

    private var _y:Float;

    private var _width:Float;

    private var _height:Float;

    public var x(get,set):Float;
    private function set_x(value:Float):Float
    {
        _x = value;
        this.dispatchEvent(new Event(Event.CHANGE,false,false));
        return value;
    }
    private function get_x():Float
    {
        return _x;
    }

    public var y(get,set):Float;
    private function set_y(value:Float):Float
    {
        _y = value;
        this.dispatchEvent(new Event(Event.CHANGE,false,false));
        return value;
    }
    private function get_y():Float
    {
        return _y;
    }

    public var width(get,set):Float;
    private function set_width(value:Float):Float
    {
        _width = value;
        this.dispatchEvent(new Event(Event.CHANGE,false,false));
        return value;
    }
    private function get_width():Float
    {
        return _width;
    }

    public var height(get,set):Float;
    private function set_height(value:Float):Float
    {
        _height = value;
        this.dispatchEvent(new Event(Event.CHANGE,false,false));
        return value;
    }
    private function get_height():Float
    {
        return _height;
    }
    
    public function new(x:Float,y:Float,width:Float,height:Float)
    {
        super();
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    

}