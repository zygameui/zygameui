package zygame.utils;

import spine.openfl.SkeletonSprite;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.display.Stage;
import spine.base.SpineBaseDisplay;

/**
 * 用于管理Spine的动画统一播放处理
 */
class SpineManager {
	private static var spineOnFrames:Array<SpineBaseDisplay> = [];

	private static var spineOnFramesOut:Array<SpineBaseDisplay> = [];

	private static var stage:Stage;

	/**
	 * 当前延迟FPS的间隔时间
	 */
	private static var _lastFpsTime:Float;

	private static var _newFpsTime:Float;

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
		_lastFpsTime = Date.now().getTime();
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
		#if (test && js)
		untyped window.spineDebugInfo = echoDebugInfo;
		#end
	}

	public static function pause():Void {
		if (stage == null)
			return;

		stage.removeEventListener(Event.ENTER_FRAME, onFrame);
	}

	public static function resume():Void {
		if (stage == null)
			return;

		if (!isLockFrameFps) {
			_lastFpsTime = Date.now().getTime();
		}

		stage.addEventListener(Event.ENTER_FRAME, onFrame);
	}

	/**
	 * 输出调试信息
	 */
	public static function echoDebugInfo():Void {
		var spineUpdateList:Array<Dynamic> = [];
		for (display in spineOnFrames) {
			if (!display.isHidden() && display.isPlay) {
				if (Std.isOfType(display, SkeletonSprite)) {
					var spine = cast(display, SkeletonSprite);
					spineUpdateList.push({
						action: spine.assetsId,
						isCache: spine.isCache
					});
				}
			}
		}
		trace(spineUpdateList.length, spineUpdateList);
	}

	private static function onFrame(event:Event):Void {
		if (!enbed)
			return;
		_newFpsTime = Date.now().getTime();
		var currentFpsTime = _newFpsTime - _lastFpsTime;
		currentFpsTime = currentFpsTime / 1000;
		_lastFpsTime = _newFpsTime;
		playingCount = 0;
		for (display in spineOnFrames) {
			if (display.independent) {
				display.onSpineUpdate(currentFpsTime);
			}
		}
		if (!isLockFrameFps) {
			for (display in spineOnFrames) {
				if (!display.isHidden() && display.isPlay && !display.independent) {
					playingCount++;
					display.onSpineUpdate(currentFpsTime);
				}
			}
			for (display in spineOnFramesOut) {
				display.onSpineUpdate(0);
			}
		} else if (fps.fps == 60) {
			for (display in spineOnFrames) {
				if (!display.isHidden() && display.isPlay && !display.independent) {
					playingCount++;
					display.onSpineUpdate(1 / stage.frameRate);
				}
			}
			for (display in spineOnFramesOut) {
				display.onSpineUpdate(0);
			}
		} else if (fps.update()) {
			for (display in spineOnFrames) {
				if (!display.isHidden() && display.isPlay && !display.independent) {
					playingCount++;
					display.onSpineUpdate(1 / fps.fps);
				}
			}
			for (display in spineOnFramesOut) {
				display.onSpineUpdate(0);
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
