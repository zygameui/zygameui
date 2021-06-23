package zygame.utils;

/**
 * GC工具
 */
class GC {
	private static var _retain:Array<Dynamic> = [];

	/**
	 * 获取引用数的长度
	 * @return Int
	 */
	public static function getRetainCounts():Int {
		return _retain.length;
	}

	/**
	 * 对变量进行引用，避免C++回收
	 * @param value 
	 */
	public static function retain(value:Dynamic):Void {
		if (_retain.indexOf(value) == -1)
			_retain.push(value);
	}

	/**
	 * 对变量进行引用清理，让它可以被回收，但请确保在其他地方没有任何引用
	 * @param value 
	 */
	public static function release(value:Dynamic):Void {
		_retain.remove(value);
	}
}
