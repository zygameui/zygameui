package zygame.utils;

#if crypto
import haxe.crypto.padding.Padding;
import haxe.crypto.mode.Mode;
import haxe.crypto.Aes;
#end
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

	#if crypto
	/**
	 * AES加密源
	 */
	public static var aes:Aes;
	#end

	/**
	 * 左右对应key
	 * @param leftKey 16位秘钥
	 * @param rightKey 16位秘钥
	 */
	public static function initAesKey(leftKey:String, rightKey:String):Void {
		#if crypto
		aes = new Aes(Bytes.ofString(leftKey), Bytes.ofString(rightKey));
		#end
	}

	/**
	 * AES级别加密
	 * @param data 
	 * @param key 
	 * @return String
	 */
	public static function aesEncode(data:String):String {
		#if crypto
		if (aes == null)
			throw "需要先使用CEUtils.initAesKey进行初始化";
		var bytes = Bytes.ofString(data);
		var encryptdata = aes.encrypt(Mode.CBC, bytes, Padding.PKCS7);
		var str = Base64.encode(encryptdata, false);
		return str;
		#else
		throw "使用CEUtils.aesEncode时，需要引入crypto库";
		#end
	}

	/**
	 * AES级别解密
	 * @param data 
	 * @param key 
	 * @return String
	 */
	public static function aesDecode(data:String):String {
		#if crypto
		if (aes == null)
			throw "需要先使用CEUtils.initAesKey进行初始化";
		var bytes = Base64.decode(data, false);
		var encryptdata = aes.decrypt(Mode.CBC, bytes, Padding.PKCS7);
		return encryptdata.toString();
		#else
		throw "使用CEUtils.aesDecode时，需要引入crypto库";
		#end
	}
}
