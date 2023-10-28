package zygame.components.data;

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

	public function new(maxFrame:Int, fps:Int) {
		this.maxFrame = maxFrame;
		this.fps = fps;
	}

	/**
	 * 更新时间戳
	 * @param dt 
	 */
	public function advanceTime(dt:Float):Void {
		__frameCurrentDt += dt;
		var frame = currentFrame + Math.floor(__frameCurrentDt / __frameDtSetp);
		__frameCurrentDt = __frameCurrentDt % __frameDtSetp;
		if (frame > maxFrame) {
			if (loop == -1 || loop > 0) {
				if (loop > 0)
					loop--;
				currentFrame = frame % maxFrame;
			}
		} else {
			currentFrame = frame;
		}
	}
}
