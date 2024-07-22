package zygame.utils;

import haxe.Exception;
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
	 * 将`Exception`输出
	 * @param e 
	 */
	public static function exception(e:Exception, ?infos:PosInfos):String {
		var message = e.message + "\n" + e.stack.toString();
		var str = haxe.Log.formatOutput(message, infos);
		error(str, infos);
		return str;
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
