package zygame.utils;

/**
 *  字符串工具
 */
class StringUtils {
	/**
	 *  获取字符串的扩展名，如果不存在扩展名，则会返回null
	 * @param data - 
	 *  @return String
	 */
	public static function getExtType(data:String):String {
		if (data == null)
			return data;
		var index:Int = data.lastIndexOf(".");
		var ext = index == -1 ? null : data.substr(index + 1);
		if (ext != null && ext.indexOf("?") != -1) {
			ext = ext.substr(0, ext.lastIndexOf("?"));
		}
		return ext;
	}

	/**
	 *  获取字符串的名字，不带路径、扩展名
	 * @param data - 
	 *  @return String
	 */
	public static function getName(source:String):String {
		var data = source;
		if (data == null)
			return data;
		data = data.substr(data.lastIndexOf("/") + 1);
		if (data.indexOf(".") != -1)
			data = data.substr(0, data.lastIndexOf("."));
		else if (source.indexOf("http") == 0)
			return source;
		return data;
	}

	/**
	 * 转成整数
	 * @param text 
	 * @return Int
	 */
	public static function toInt(text:String):Int {
		return Std.parseInt(text);
	}

	/**
	 * 转成浮点数
	 * @param text 
	 * @return Float
	 */
	public static function toFloat(text:String):Float {
		return Std.parseFloat(text);
	}
}
