package zygame.utils;

import haxe.Timer;

/**
 * 计时器工具
 */
class TimerUtils {
	private static var _lastTimer:Float = 0;

	/**
	 * 开始计时
	 */
	public static function start():Void {
		_lastTimer = Timer.stamp();
	}

	/**
	 * 停止计时
	 * @return Float 返回所统计的耗时
	 */
	public static function stop():Float {
		var nowTimer = Timer.stamp();
		return nowTimer - _lastTimer;
	}
}
