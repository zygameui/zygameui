package zygame.utils;

import zygame.display.ZBitmapData;
import openfl.display.BitmapData;

/**
 * 用于模拟统计GPU的使用率的计算器，仅计算加载到游戏中的图片GPU内存，不计算是否创建的GPU内存
 */
class GPUUtils {
	/**
	 * GPU内存记录
	 */
	public static var gpuMemory:Int = 0;

	#if (debug || gpudebug)
	public static var gpuList:Array<String> = [];
	#end

	public static function addBitmapData(bitmapData:BitmapData):Void {
		if (bitmapData == null)
			return;
		gpuMemory += bitmapData.width * bitmapData.height * 4;
		#if (debug || gpudebug)
		if (Std.is(bitmapData, ZBitmapData)) {
			if (gpuList.indexOf(cast(bitmapData, ZBitmapData).path) == -1)
				gpuList.push(cast(bitmapData, ZBitmapData).path);
			else
				trace("[GPUWarring]可能存在内存泄露：" + cast(bitmapData, ZBitmapData).path);
		}
		#end
	}

	public static function removeBitmapData(bitmapData:BitmapData):Void {
		gpuMemory -= bitmapData.width * bitmapData.height * 4;
		if (gpuMemory < 0)
			gpuMemory = 0;
		#if (debug || gpudebug)
		if (Std.is(bitmapData, ZBitmapData)) {
			gpuList.remove(cast(bitmapData, ZBitmapData).path);
		}
		#end
	}

	public static function getGpuMemoryMB():Float {
		return Std.int(gpuMemory / 1024 / 1024 * 100) / 100;
	}
}
