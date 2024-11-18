package zygame.utils;

import openfl.display.BitmapData;
#if js
import js.lib.WeakRef;
#elseif cpp
import cpp.vm.WeakRef;
#end

/**
 * 图片位图资源缓存，使用弱引用的实现，让位图实现缓存处理
 */
class ImageBitmapCacheAssets {
	private static var __instance:ImageBitmapCacheAssets;

	/**
	 * 单例
	 */
	public static function getInstance():ImageBitmapCacheAssets {
		if (__instance == null) {
			__instance = new ImageBitmapCacheAssets();
		}
		return __instance;
	}

	private var __weakMap:Map<String, WeakRef<BitmapData>> = [];

	private function new() {}

	/**
	 * 注册位图
	 */
	public function register(key:String, bitmap:BitmapData):Void {
		trace('register key:$key');
		__weakMap[key] = new WeakRef(bitmap);
	}

	/**
	 * 获取位图
	 */
	public function get(key:String):BitmapData {
		trace('get key:$key');
		var ref = __weakMap[key];
		if (ref != null) {
			var bitmap = #if js __weakMap[key].deref() #else __weakMap[key].get() #end;
			if (bitmap != null && @:privateAccess bitmap.__texture != null)
				return bitmap;
		}
		return null;
	}
}
