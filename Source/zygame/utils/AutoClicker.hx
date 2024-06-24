package zygame.utils;

import zygame.display.batch.BButton;
import zygame.components.ZButton;

/**
 * 仅影响ZButton和Button的点击事件，需要定义`auto_clicker`生效
 */
class AutoClicker {
	/**
	 * 是否启动自动点击器
	 */
	public static var enabled:Bool = false;

	/**
	 * 触发毫秒
	 */
	public static var interval:Int = 1;

	/**
	 * 点击测试次数
	 */
	public static var clickCounts:Int = 100;

	/**
	 * 点击按钮
	 * @param button 
	 */
	public static function clickByZButton(button:ZButton):Void {
		if (button.clickEvent == null)
			return;
		if (enabled) {
			for (i in 0...clickCounts) {
				Lib.setTimeout(button.clickEvent, i * interval);
			}
		} else {
			button.clickEvent();
		}
	}

	/**
	 * 点击按钮
	 * @param button 
	 */
	public static function clickByBButton(button:BToggleButton):Void {
		if (button.clickEvent == null)
			return;
		if (enabled) {
			for (i in 0...clickCounts) {
				Lib.setTimeout(button.clickEvent, i * interval);
			}
		} else {
			button.clickEvent();
		}
	}
}
