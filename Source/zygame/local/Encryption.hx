package zygame.local;

import haxe.Exception;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.crypto.Hmac;

class Encryption {
	public static var key:String;

	public static var keyCode:Int = 0;

	/**
	 * 初始化加密秘钥
	 * @param key 
	 */
	public static function init(key:String):Void {
		Encryption.key = key;
		if (key == null)
			return;
		var array = key.split("");
		for (s in array) {
			keyCode += s.charCodeAt(0);
		}
		keyCode %= 255;
	}

	/**
	 * 加密处理
	 * @param data 
	 * @return String
	 */
	public static function encode(data:String):String {
		if (keyCode != 0) {
			try {
				var bytes = Bytes.ofString(data);
				for (i in 0...bytes.length) {
					bytes.set(i, bytes.get(i) + keyCode);
				}
				return Base64.encode(bytes);
			} catch (e:Exception) {}
		}
		return data;
	}

	/**
	 * 解密处理
	 * @param data 
	 * @return String
	 */
	public static function decode(data:String):String {
		if (keyCode != 0) {
			try {
				var bytes = Base64.decode(data);
				for (i in 0...bytes.length) {
					bytes.set(i, bytes.get(i) - keyCode);
				}
				return bytes.toString();
			} catch (e:Exception) {}
		}
		return data;
	}
}
