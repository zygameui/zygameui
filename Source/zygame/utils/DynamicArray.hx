package zygame.utils;

import haxe.iterators.ArrayIterator;
import zygame.local.Reflect;

/**
 * 支持添加、删除回调的数组
 */
@:forward
abstract DynamicArray<T>(DynamicArrayData<T>) from DynamicArrayData<T> to DynamicArrayData<T> {
	inline public function new() {
		this = new DynamicArrayData<T>();
	}

	@:from public static function fromArray<T>(data:Array<T>) {
		return new DynamicArray<T>();
	}

	@:to public function iterator():ArrayIterator<T> {
		return this.array.iterator();
	}

	@:to public function toArray():Array<T> {
		return this.array;
	}

	@:to public function toString():Dynamic {
		return this.array;
	}

	public var length(get, never):Int;

	function get_length():Int {
		return this.array.length;
	}

	public function getArrayByClass<B>(c:Class<B>):Array<B> {
		var name = Type.getClassName(c);
		var array = this.classMaps.get(name);
		if(array == null)
			array = [];
		return cast array;
	}

	public function getDisplayFromClassByName<B>(c:Class<B>, name:String):B {
		var data = getArrayByClass(c);
		if (data != null) {
			for (b in data) {
				if (Reflect.getProperty(b, "name") == name)
					return b;
			}
		}
		return null;
	}
}

class DynamicArrayData<T> {
	/**
	 * 删除回调
	 * @param data 
	 */
	dynamic public function onRemove(data:T):Void {}

	/**
	 * 添加回调
	 * @param data 
	 */
	dynamic public function onAdd(data:T):Void {}

	public var array:Array<T>;

	/**
	 * 更加ClassMaps
	 */
	public var classMaps:Map<String, Array<T>> = [];

	public function new(array:Array<T> = null) {
		if (array == null)
			array = [];
		this.array = array;
	}

	public function push(data:T):Void {
		array.push(data);
		this.onAdd(data);
		var className = Type.getClassName(Type.getClass(data));
		if (!classMaps.exists(className))
			classMaps.set(className, []);
		classMaps.get(className).push(data);
	}

	public function remove(data:T):Void {
		array.remove(data);
		this.onRemove(data);
		var className = Type.getClassName(Type.getClass(data));
		if (classMaps.exists(className))
			classMaps.get(className).remove(data);
	}
}
