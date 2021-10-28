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

	/**
	 * 获取明天的时间的字符串格式2001-10-1 00:00:00
	 * @param curDate 当前时间
	 * @param time 明天的时间，格式为00:00:00
	 * @return String
	 */
	public static function getTomorrowDateString(curDate:Date, time:String):String {
		var newDate = Date.fromTime(curDate.getTime() + 24 * 60 * 60 * 1000);
		return '${DateTools.format(newDate, "%Y-%m-%d")} ' + time;
	}
}
