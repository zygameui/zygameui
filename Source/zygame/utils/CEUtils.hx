package zygame.utils;

import haxe.crypto.padding.Padding;
import haxe.crypto.mode.Mode;
import haxe.crypto.Aes;
import haxe.io.Bytes;
import haxe.crypto.Base64;

class CEUtils {
	/**
	 * 普通的BASE64加密
	 * @param data 
	 * @return String
	 */
	public static function encode(data:String):String {
		return Base64.encode(Bytes.ofString(data));
	}

	/**
	 * 普通的BASE64解密
	 * @param data 
	 * @return String
	 */
	public static function decode(data:String):String {
		return Base64.decode(data).toString();
	}

	/**
	 * AES加密源
	 */
	public static var aes:Aes;

	/**
	 * 左右对应key
	 * @param leftKey 16位秘钥
	 * @param rightKey 16位秘钥
	 */
	public static function initAesKey(leftKey:String, rightKey:String):Void {
		aes = new Aes(Bytes.ofString(leftKey), Bytes.ofString(rightKey));
	}

	/**
	 * AES级别加密
	 * @param data 
	 * @param key 
	 * @return String
	 */
	public static function aesEncode(data:String):String {
		if (aes == null)
			throw "需要先使用CEUtils.initAesKey进行初始化";
		var bytes = Bytes.ofString(data);
		var encryptdata = aes.encrypt(Mode.CBC, bytes, Padding.PKCS7);
		var str = Base64.encode(encryptdata, false);
		return str;
	}

	/**
	 * AES级别解密
	 * @param data 
	 * @param key 
	 * @return String
	 */
	public static function aesDecode(data:String):String {
		if (aes == null)
			throw "需要先使用CEUtils.initAesKey进行初始化";
		var bytes = Base64.decode(data, false);
		var encryptdata = aes.decrypt(Mode.CBC, bytes, Padding.PKCS7);
		return encryptdata.toString();
	}
}
