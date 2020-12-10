package zygame.worker;

/**
 * Worker多线程，一个游戏只能创建一个多线程，需要开启下一个多线程之前，请使用terminate()结束此线程。
 */
class Worker implements BaseWorker{

    public var worker:BaseWorker;

    /**
     * 是否支持多线程
     * @return Bool
     */
    public static function isSupport():Bool {
        #if weixin
        return true;
        #else
        return false;
        #end
    }

    /**
     * 创建一个Worker
     * @param path 传递js路径文件，如果不存在js文件，则使用class类名路径，但请注意，使用class类型路径时，将为单线程模式。
     */
    public function new(path:String) {
        if(path.indexOf(".js") == -1){
            //说明是class
            worker = Type.createInstance(Type.resolveClass(path),[]);
            worker.worker = this;
        }
        else
        {
            #if weixin
            worker = untyped wx.createWorker(path);
            worker.onMessage(function (res) {
                onMessage(res);
            });
            #end
        }
    }

    /**
     * 给主线程或者子线程中发送消息
     * @param data 
     */
    public function postMessage(data:Dynamic):Void{
        if(isSupport())
        {
            worker.postMessage(data);
        } 
        else
            worker.onMessage(data);
    }

    /**
     * 接收主线程或者子线程中的消息
     * @param data 
     */
    dynamic public function onMessage(data:Dynamic):Void{

    }

    /**
     * 弃用当前线程
     */
    public function terminate():Void{
        
    }

}