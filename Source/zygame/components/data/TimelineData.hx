package zygame.components.data;

import haxe.Rest;

/**
 * 时间戳数据
 */
class TimelineData {
	/**
	 * 当前帧数，从0开始
	 */
	public var currentFrame:Int = 0;

	/**
	 * 最大帧数
	 */
	public var maxFrame:Int = 0;

	/**
	 * 帧率，默认使用60FPS
	 */
	public var fps(default, set):Int = 60;

	/**
	 * 每步的时间戳
	 */
	private var __frameDtSetp:Float = 0;

	/**
	 * 当前DT
	 */
	private var __frameCurrentDt:Float = 0;

	/**
	 * 循环次数，如果值为`-1`时，则可以无限循环
	 */
	public var loop:Int = -1;

	private function set_fps(f:Int):Int {
		this.fps = f;
		__frameDtSetp = 1 / this.fps;
		return f;
	}

	/**
	 * 获得0-1的FPS进度值
	 */
	public var currentFrameRate(get, never):Float;

	private function get_currentFrameRate():Float {
		return currentFrame / maxFrame;
	}

	/**
	 * 帧事件脚本
	 */
	private var __frameScript:Map<Int, Array<Void->Void>> = [];

	public function new(maxFrame:Int, fps:Int) {
		this.maxFrame = maxFrame;
		this.fps = fps;
	}

	/**
	 * 添加帧事件
	 * @param frame 
	 * @param call 
	 * @param ...args 
	 */
	public function addFrameScript(frame:Int, call:Void->Void, ...args:Dynamic):Void {
		__addFrameScript(frame, call);
		var array = args.toArray();
		var len = Math.floor(array.length / 2);
		for (i in 0...len) {
			__addFrameScript(array[i * 2], array[i * 2 + 1]);
		}
	}

	private function __addFrameScript(frame:Int, call:Void->Void):Void {
		if (!__frameScript.exists(frame)) {
			__frameScript.set(frame, [call]);
		} else {
			__frameScript.get(frame).push(call);
		}
	}

	/**
	 * 更新时间戳
	 * @param dt 
	 */
	public function advanceTime(dt:Float):Void {
		if (loop == 0)
			return;
		var oldFrame = currentFrame;
		__frameCurrentDt += dt;
		var frame = currentFrame + Math.floor(__frameCurrentDt / __frameDtSetp);
		__frameCurrentDt = __frameCurrentDt % __frameDtSetp;
		if (frame > maxFrame) {
			if (loop == -1 || loop > 0) {
				if (loop > 0)
					loop--;
				for (i in oldFrame...maxFrame) {
					__frameScriptExecute(i);
				}
				if (loop == 0) {
					currentFrame = maxFrame;
				} else {
					oldFrame = 0;
					currentFrame = frame % maxFrame;
				}
			}
		} else {
			currentFrame = frame;
		}
		for (i in oldFrame...currentFrame) {
			__frameScriptExecute(i);
		}
	}

	/**
	 * 执行帧事件逻辑
	 * @param frame 
	 */
	private function __frameScriptExecute(frame:Int):Void {
		this.onFrame(frame);
		if (__frameScript.exists(frame)) {
			for (call in __frameScript.get(frame)) {
				call();
			}
		}
	}

	/**
	 * 帧事件自定义回调
	 * @param frame 
	 */
	dynamic public function onFrame(frame:Int):Void {}

	/**
	 * 进入下一帧
	 */
	public function nextFrame():Void {
		var oldFrame = currentFrame;
		currentFrame++;
		if (currentFrame >= maxFrame) {
			currentFrame = maxFrame;
		}
		if (oldFrame != currentFrame)
			__frameScriptExecute(currentFrame);
	}

	/**
	 * 回到上一帧
	 */
	public function lastFrame():Void {
		var oldFrame = currentFrame;
		currentFrame--;
		if (currentFrame < 0) {
			currentFrame = 0;
		}
		if (oldFrame != currentFrame)
			__frameScriptExecute(currentFrame);
	}
}
