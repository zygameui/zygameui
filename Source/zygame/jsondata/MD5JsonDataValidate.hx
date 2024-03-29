package zygame.jsondata;

import haxe.crypto.Md5;
import haxe.zip.Reader;

/**
 * MD5数据检验逻辑
 */
class MD5JsonDataValidate implements IJsonDataValidate {
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

	public function new(data:Array<Dynamic>) {
		this.__data = data;
		if (data.length > 0) {
			var item = data[0];
			__keys = Reflect.fields(item);
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
		return __md5s.exists(getMd5(object));
	}

	public function getMd5(item:String):String {
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
