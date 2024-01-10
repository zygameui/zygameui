package zygame.events;

import zygame.utils.ZAssets;
import openfl.events.Event;

/**
 * 通过ZAssets.globalListener侦听全局加载事件
 */
class GlobalAssetsLoadEvent extends Event {
	/**
	 * 加载失败回调
	 */
	public static final LOAD_ERROR:String = "load_error";

	/**
	 * 加载失败的地址
	 */
	public var url:String;

	/**
	 * ASSETS资源
	 */
	public var assets:ZAssets;

	/**
	 * 是否拦截失败回调处理，通过`preventDefault`可以启动拦截
	 */
	public var interceptErrorEvent(default, null):Bool = false;

	override function preventDefault() {
		super.preventDefault();
		interceptErrorEvent = true;
	}
}
