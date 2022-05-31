package zygame.utils;

#if openfl_console
import com.junkbyte.console.Cc;
#end

/**
 * 调试器
 */
class Debug {
	/**
	 * 显示openfl-console组件，需要引入`openfl-console`的定义才能正常使用
	 */
	public static function show():Void {
		#if openfl_console
		Cc.visible = true;
		#end
	}

	/**
	 * 隐藏openfl-console组件，需要引入`openfl-console`的定义才能正常使用
	 */
	public static function close():Void {
		#if openfl_console
		Cc.visible = false;
		#end
	}
}
