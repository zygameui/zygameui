package zygame.events;

import openfl.events.Event;

/**
 * 通过ZAssets.globalListener侦听全局加载事件
 */
class GlobalAssetsLoadEvent extends Event {

    /**
     * 加载失败回调
     */
    public static final LOAD_ERROR:String = "load_error";

    public var url:String;

}