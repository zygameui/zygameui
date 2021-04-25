package zygame.utils;

import openfl.display.DisplayObject;
import openfl.display.Tile;
import motion.easing.Back;
import motion.actuators.GenericActuator;

/**
 * 简易效果工具，一个显示对象只能应用一个特效效果。
 */
class EffectUtils {
	private static var batchmap:Map<Tile, GenericActuator<Dynamic>> = [];
	private static var displaymap:Map<DisplayObject, GenericActuator<Dynamic>> = [];

	/**
	 * 给按钮添加呼吸效果
	 * @param keyid 效果ID
	 * @param sprite 按钮对象
	 */
	public static function breathe(display:Dynamic):Void {
		// 呼吸效果
		var map:Dynamic = Std.isOfType(display, Tile) ? batchmap : displaymap;
		map.set(display, motion.Actuate.tween(display, 1, {
			scaleX: 1.06,
			scaleY: 1.06,
			x: Reflect.getProperty(display, "x") - Reflect.getProperty(display, "width") * 0.03,
			y: Reflect.getProperty(display, "y") - Reflect.getProperty(display, "height") * 0.03
		}).reflect(true).repeat().ease(Back.easeIn));
	}

	/**
	 * 停止动画
	 * @param display 
	 */
	public static function stop(display:Dynamic):Void {
		var map:Dynamic = Std.isOfType(display, Tile) ? batchmap : displaymap;
		map.remove(display);
	}
}
