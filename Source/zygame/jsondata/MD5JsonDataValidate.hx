package zygame.jsondata;

import haxe.crypto.Md5;
import haxe.zip.Reader;

/**
 * MD5数据检验逻辑
 */
class MD5JsonDataValidate implements IJsonDataValidate {
	/**
	 * 是否启用全局验证，当关闭时，则在验证时，会忽略掉所有验证规则
	 */
	public static var validateGlobalEnable:Bool = true;

	/**
	 * 验证条例
	 */
	private var __md5s:Map<String, Bool> = [];

	/**
	 * MD5循序key
	 */
	private var __keys:Array<String> = [];

	private var __data:Array<Dynamic> = [];

	/**
	 * 允许在通过`getDataArrayByXX`获得数据时，进行一个数据全验证的处理，默认为`true`，如果存在性能影响时，可以设置为`false`
	 */
	public var allowGetDataListValidate:Bool = false;

	/**
	 * 允许在通过`getDataByXXX`获得数据时，进行一个数据验证的处理，默认为`false`，开启后可能存在性能影响，但如果需要完整的数据验证，可设置为`true`
	 */
	public var allowGetDataValidate:Bool = false;

	public function new(data:Array<Dynamic>) {
		this.__data = data;
		if (data.length > 0) {
			var item = data[0];
			var keys = Reflect.fields(item);
			for (key in keys) {
				var value = Reflect.getProperty(item, key);
				if (value is String || value is Int || value is Float) {
					__keys.push(key);
				}
			}
			for (item in data) {
				__md5s.set(getMd5(item), true);
			}
		}
	}

	/**
	 * 验证Item是否有被篡改
	 * @param object 
	 * @return Bool
	 */
	public function validateObject(object:Dynamic):Bool {
		#if test
		game.utils.DebugStatus.checkValidate++;
		#end
		if (!validateGlobalEnable) {
			return true;
		}
		return __md5s.exists(getMd5(object));
	}

	public function getMd5(item:Dynamic):String {
		var key = "";
		for (k in __keys) {
			key += Reflect.getProperty(item, k);
		}
		return Md5.encode(key);
	}

	/**
	 * 验证所有数据
	 * @return Bool
	 */
	public function validateAll():Bool {
		for (item in __data) {
			if (!validateObject(item)) {
				return false;
			}
		}
		return true;
	}
}
