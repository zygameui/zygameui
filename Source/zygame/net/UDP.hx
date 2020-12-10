package zygame.net;

#if nwjs
import nw.NwjsUDP;
#end

/**
 * UDP连接支持
 */
class UDP {

    /**
     * 不需要主动调用，Start会自动调用
     */
    public static function init():Void
    {
        #if nwjs
        //NWJSUDP
        NwjsUDP.initUDP(function(bool){
            trace("[NWJS]UDP start!");            
        });
        NwjsUDP.read(function(msg){
            onUDPMessage(msg);
        });
        #end
    }

    /**
     * UDP消息接收
     * @param msg 
     */
    dynamic public static function onUDPMessage(msg:String):Void
    {

    }

    /**
     * 发送UDP消息，需要UDP功能支持时，才能正常发送，HTML5需要依赖nwjs框架进行发送。
     * @param msg 
     * @param start 
     * @param len 
     * @param port 
     * @param ip 
     */
    public static function send(msg:String,port:Int,ip:String):Void
    {
        #if nwjs
        NwjsUDP.send(msg,0,msg.length,port,ip);
        #else
        trace("The platform is not support UDP!");
        #end
    }

    public static function isSupport():Bool
    {
        #if nwjs
        return NwjsUDP.isSupportUDP;
        #else
        return false;
        #end
    }

}