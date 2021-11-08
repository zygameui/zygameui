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
	 * @param time 持续时间，默认1秒
	 * @param scale 缩放比例，默认1.06
	 */
	public static function breathe(display:Dynamic,time:Float = 1,scale:Float = 1.06):Void {
		// 呼吸效果
		var map:Dynamic = Std.isOfType(display, Tile) ? batchmap : displaymap;
		map.set(display, motion.Actuate.tween(display, time, {
			scaleX: scale,
			scaleY: scale,
			x: Reflect.getProperty(display, "x") - Reflect.getProperty(display, "width") * (scale - 1) * 0.25,
			y: Reflect.getProperty(display, "y") - Reflect.getProperty(display, "height") * (scale - 1) * 0.25
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
