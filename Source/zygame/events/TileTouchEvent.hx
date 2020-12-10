package zygame.events;

import openfl.events.Event;
import openfl.display.Tile;

@:access(openfl.events.Event)

/**
 * 瓦片点击事件，需要通过访问tile得到点击瓦片
 */
class TileTouchEvent extends Event
{
    public static inline var TOUCH_BEGIN_TILE = "touchBeginTile";
	public static inline var TOUCH_END_TILE = "touchEndTile";
	public static inline var TOUCH_MOVE_TILE = "touchMoveTile";
    
    /**
     * 由于瓦片是相当于一块儿画布，会直接挡住下面需要穿透的对象，这时会发布一个穿透事件进行使用
     * 穿透事件会附带event对象
     */
    public static inline var TOUCH_THROUGH = "touchThrough";

    public var tile:Tile;

    public var event:Event;

    public function new(type:String,tile:Tile,event:Event = null)
    {
        super(type,true,false);
        this.tile = tile;
        this.event = event;
    }
}