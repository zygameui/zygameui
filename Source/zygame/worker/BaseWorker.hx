package zygame.worker;

interface BaseWorker {

    public var worker:BaseWorker;
    
    dynamic public function onMessage(data:Dynamic):Void;

    public function postMessage(data:Dynamic):Void;

}