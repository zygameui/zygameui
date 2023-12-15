package zygame.utils;

#if js
import js.html.Console;
#end
import haxe.PosInfos;

/**
 * 日志输出工具
 */
class ZLog {
	/**
	 * 常规日志输出
	 * @param v 
	 * @param infos 
	 */
	public static function log(v:Dynamic, ?infos:PosInfos):Void {
		var str = haxe.Log.formatOutput(v, infos);
		#if js
		Console.log(str);
		#elseif sys
		Sys.println(str);
		#end
	}

	/**
	 * 错误日志输出
	 * @param v 
	 * @param infos 
	 */
	public static function error(v:Dynamic, ?infos:PosInfos):Void {
		var str = haxe.Log.formatOutput(v, infos);
		#if js
		Console.error(str);
		#elseif sys
		Sys.println(str);
		#end
	}

	/**
	 * 警告日志输出
	 * @param v 
	 * @param infos 
	 */
	public static function warring(v:Dynamic, ?infos:PosInfos):Void {
		var str = haxe.Log.formatOutput(v, infos);
		#if js
		Console.warn(str);
		#elseif sys
		Sys.println(str);
		#end
	}
}
