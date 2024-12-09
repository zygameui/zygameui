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

	private static var __isSupport:Null<Bool> = null;

	/**
	 * 判断是否支持当前API
	 * @return Bool
	 */
	public static function isSupport():Bool {
		if (__isSupport != null)
			return __isSupport;
		#if js
		if (untyped window.WeakRef != null) {
			__isSupport = true;
		} else {
			trace("[WeakRef] Not support.");
			__isSupport = false;
		}
		#else
		__isSupport = true;
		#end
		return __isSupport;
	}

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
		if (isSupport()) {
			__weakMap[key] = new WeakRef(bitmap);
		}
	}

	/**
	 * 获取位图
	 */
	public function get(key:String):BitmapData {
		if (isSupport()) {
			var ref = __weakMap[key];
			if (ref != null) {
				var bitmap = #if js __weakMap[key].deref() #else __weakMap[key].get() #end;
				if (bitmap != null && @:privateAccess bitmap.__texture != null)
					return bitmap;
			}
		}
		return null;
	}
}
