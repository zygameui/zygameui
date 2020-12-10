package zygame.utils.load;

/**
 * 基础帧
 */
class BaseFrame {

     /**
     * 瓦片ID
     */
    public var id:Int = -1;

    public var width:Float;

    public var height:Float;

    public var x:Float = 0;

    public var y:Float = 0;

    public function toString():String{
        return "[BaseFrame]";
    }
}