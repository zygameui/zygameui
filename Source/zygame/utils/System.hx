package zygame.utils;

import motion.Actuate;
import zygame.macro.ZMacroUtils;

/**
 * 系统
 */
class System {
	/**
	 * 建造时间
	 */
	public static var buildTime:String = ZMacroUtils.buildDateTime();

	/**
	 * 抖动效果，请注意，需要存在支持的平台才会支持，例如`android`/`ios`等原生平台，通常都会直接支持。当不支持时，调用该接口不会产生任何效果。
	 */
	public static function virrate(time:Float = 0.15):Void {
		#if wechat
		untyped wx.vibrateShort();
		#end
	}

	/**
	 * 获得平台目标，存在`null`的情况，它并不是必然可以获得目标。
	 * @return String
	 */
	public static function getPlatfrom():String {
		#if wechat
		return untyped window.platform;
		#else
		return null;
		#end
	}
}
