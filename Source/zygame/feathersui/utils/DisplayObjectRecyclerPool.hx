package zygame.feathersui.utils;

import lime.utils.ObjectPool;
#if feathersui
import feathers.utils.DisplayObjectRecycler;
import openfl.display.DisplayObject;

/**
 * 带垃圾池处理的withClass创建逻辑
 */
@:access(feathers.utils.DisplayObjectRecycler)
class DisplayObjectRecyclerPool {
	/**
		创建一个`DisplayObjectRecycler`单例，自动拥有垃圾池逻辑实现
	**/
	public static function withClass<T:B, S, B:DisplayObject>(displayObjectType:Class<T>, ?update:(target:T, state:S) -> Void,
			?reset:(target:T, state:S) -> Void, ?destroy:(T) -> Void):DisplayObjectRecycler<T, S, B> {
		var item = new DisplayObjectRecycler<T, S, B>();
		var pool:ObjectPool<T> = new ObjectPool(() -> {
			return Type.createInstance(displayObjectType, []);
		});
		item.create = () -> {
			pool.get();
		};
		item.update = update;
		item.reset = reset;
		item.destroy = (display) -> {
			pool.release(display);
			if (destroy != null) {
				destroy(display);
			}
		};
		return item;
	}

	public static function withClassWithArgs<T:B, S, B:DisplayObject>(displayObjectType:Class<T>, ?update:(target:T, state:S) -> Void,
			?reset:(target:T, state:S) -> Void, ?destroy:(T) -> Void, args:Array<Dynamic>):DisplayObjectRecycler<T, S, B> {
		var item = new DisplayObjectRecycler<T, S, B>();
		var pool:ObjectPool<T> = new ObjectPool(() -> {
			return Type.createInstance(displayObjectType, args);
		});
		item.create = () -> {
			pool.get();
		};
		item.update = update;
		item.reset = reset;
		item.destroy = (display) -> {
			pool.release(display);
			if (destroy != null) {
				destroy(display);
			}
		};
		return item;
	}
}
#end