package zygame.utils;

import haxe.Timer;
import zygame.core.Start;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.display.Stage;
import spine.base.SpineBaseDisplay;

/**
 * 用于管理Spine的动画统一播放处理
 */
class SpineManager {
	/**
	 * Bate 节约模式，当设置了节约模式后，仅提供给Spine渲染10%的CPU，当渲染的时候，超过10%的CPU时，没有来得及渲染的Spine不进行渲染，等待到下一帧重新渲染。
	 */
	public static var savingMode:Bool = false;

	/**
	 * CPU，默认为10%的使用率
	 */
	public static var cpu = 0.016 * 0.2;

	private static var _curcpu:Float = 0;

	private static var spineOnFrames:Array<SpineBaseDisplay> = [];

	private static var spineOnFramesOut:Array<SpineBaseDisplay> = [];

	private static var stage:Stage;

	/**
	 * 设置龙骨的播放频率
	 */
	public static var fps:FPSUtil;

	/**
	 * 是否锁定FPS时间
	 */
	public static var isLockFrameFps:Bool = false;

	/**
	 * 可用性，默认为true，如果设置为false，则不可用。
	 */
	public static var enbed:Bool = true;

	/**
	 * 正在播放运行的Spine数量
	 */
	public static var playingCount:Int = 0;

	private static var _dt:Float;
	private static var _nowTime:Float;

	private static var _isRuning:Bool = true;

	/**
	 * 初始化更新器
	 * @param stage
	 * @param isLockFrameFps 是否根据帧频率来播放动画，默认为false
	 */
	public static function init(pstage:Stage, isLockFrameFps:Bool = false):Void {
		if (stage != null)
			return;
		fps = new FPSUtil(60);
		stage = pstage;
		_nowTime = Timer.stamp();
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
	}

	public static function pause():Void {
		if (stage == null || !_isRuning)
			return;
		stage.removeEventListener(Event.ENTER_FRAME, onFrame);
	}

	public static function resume():Void {
		if (stage == null || _isRuning)
			return;
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
	}

	/**
	 * 更新过滤器，如果返回的是true，则进行渲染，否则则不渲染
	 */
	public static var onSpineUpdateFilter:SpineBaseDisplay->Bool;

	private static function onSpineUpdate(spine:SpineBaseDisplay, dt:Float):Void {
		if (onSpineUpdateFilter != null) {
			if (!onSpineUpdateFilter(spine))
				return;
		}
		if (!savingMode) {
			spine.onSpineUpdate(dt);
			playingCount++;
			return;
		}
		// 节能模式，节能模式所有渲染都是24FPS
		var cur = Timer.stamp();
		if (_curcpu > cpu || cur - spine.lastDrawTime < 1 / 12)
			return;
		spine.onSpineUpdate(spine.lastDrawTime == 0 ? dt : cur - spine.lastDrawTime);
		var newcur = Timer.stamp();
		spine.lastDrawTime = newcur;
		_curcpu += (newcur - cur);
		playingCount++;
	}

	private static function onFrame(event:Event):Void {
		if (!enbed)
			return;
		_curcpu = 0;
		playingCount = 0;

		for (display in spineOnFrames) {
			if (display.independent) {
				onSpineUpdate(display, Start.current.frameDt);
			}
		}

		if (savingMode) {
			// 将时间少的往前面放
			spineOnFrames.sort((a, b) -> a.lastDrawTime > b.lastDrawTime ? 1 : -1);
			for (display in spineOnFrames) {
				if (!display.isHidden() && display.isPlay && !display.independent) {
					onSpineUpdate(display, Start.current.frameDt);
				}
			}
			for (display in spineOnFramesOut) {
				onSpineUpdate(display, 0);
			}
			return;
		}

		if (!isLockFrameFps) {
			if (fps.fps == 60 || fps.update()) {
				var nTime = Timer.stamp();
				var dt = nTime - _nowTime;
				_nowTime = nTime;
				for (display in spineOnFrames) {
					if (!display.isHidden() && display.isPlay && !display.independent) {
						onSpineUpdate(display, dt);
					}
				}
				for (display in spineOnFramesOut) {
					onSpineUpdate(display, 0);
				}
			}
		} else if (fps.fps == 60 || fps.update()) {
			for (display in spineOnFrames) {
				if (!display.isHidden() && display.isPlay && !display.independent) {
					onSpineUpdate(display, 1 / fps.fps);
				}
			}
			for (display in spineOnFramesOut) {
				onSpineUpdate(display, 0);
			}
		}
	}

	/**
	 * 添加到更新器中
	 * @param spine
	 */
	public static function addOnFrame(s:SpineBaseDisplay, out:Bool = false):Void {
		if (spineOnFrames.indexOf(s) == -1) {
			if (!out)
				spineOnFrames.push(s);
			else
				spineOnFramesOut.push(s);
		}
	}

	/**
	 * 从更新器中移除
	 * @param spine
	 */
	public static function removeOnFrame(spine:SpineBaseDisplay):Void {
		spineOnFrames.remove(spine);
		spineOnFramesOut.remove(spine);
	}

	/**
	 * 获取更新器的长度
	 * @return Int
	 */
	public static function count():Int {
		return spineOnFrames.length;
	}
}
