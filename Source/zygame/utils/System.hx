package zygame.utils;

import motion.Actuate;
import zygame.macro.ZMacroUtils;

/**
 * 系统
 */
#if ios
@:cppFileCode("
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <mach/mach_types.h>
")
#end
class System {
	/**
	 * 建造时间
	 */
	public static var buildTime:String = ZMacroUtils.buildDateTime();

	/**
	 * 抖动效果，请注意，需要存在支持的平台才会支持，例如`android`/`ios`等原生平台，通常都会直接支持。当不支持时，调用该接口不会产生任何效果。
	 */
	public static function virrate(time:Float = 0.025):Void {
		#if wechat
		untyped wx.vibrateShort();
		#elseif sxk_game_sdk
		v4.NativeApi.vibrate(Math.round(time * 1000));
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

	public static function getMemoryUsage():Float {
		#if ios
		untyped __cpp__("
        task_vm_info_data_t info;
		mach_msg_type_number_t count = TASK_VM_INFO_COUNT;

		const auto status = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&info, &count);
		if (status != KERN_SUCCESS) {
			return 0;
		}

		if (count >= TASK_VM_INFO_REV1_COUNT) {
			return info.phys_footprint;
		}");

		#elseif cpp
		return cpp.vm.Gc.memUsage();
		#end
		return 0;
	}

	/**
	 * 清理内存
	 */
	public static function gc():Void {
		openfl.system.System.gc();
	}
}
