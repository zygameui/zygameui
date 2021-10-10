package zygame.utils;

/**
 * 时间工具
 */
class DateUtils {
	/**
	 * 兼容多种格式
	 * 2021-09-29T02:31:56.583Z
	 * 2021-09-29 02:31:56
	 * @param string 
	 * @return Date
	 */
	public static function fromString(string:String):Date {
		if (string == null)
			return null;
		if (string.indexOf("T") != -1)
			string = StringTools.replace(string, "T", " ");
		if (string.indexOf(".") != -1)
			string = string.substr(0, string.indexOf("."));
		var date = Date.fromString(string);
		return date;
	}
}
