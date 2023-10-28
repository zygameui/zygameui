package zygame.display.batch;

import zygame.components.data.TimelineData;
import zygame.core.Start;
import zygame.components.data.AnimationData;
import zygame.utils.load.Frame;

class BAnimation extends BImage {
	private var _animation:AnimationData;

	public var timeline:TimelineData = new TimelineData(0, 60);

	/**
	 *  播放次数
	 */
	public var loop(get, set):Int;

	private function get_loop():Int {
		return timeline.loop;
	}

	private function set_loop(l:Int):Int {
		this.timeline.loop = l;
		return l;
	}

	/**
	 *  是否播放中
	 */
	public var isPlaying:Bool = false;

	/**
	 *  当前帧
	 */
	public var currentFrame:Int = 0;

	/**
	 *  延迟计算
	 */
	private var _delayFrame:Int;

	override function onInit() {
		super.onInit();
		timeline.onFrame = __onFrameUpdate;
	}

	private function __onFrameUpdate(frame:Int):Void {
		if (_delayFrame > 0) {
			_delayFrame--;
			frame = 0;
			this.timeline.currentFrame--;
		}
		var frameData:FrameData = _animation.getFrame(frame);
		if (frameData != null) {
			_delayFrame = frameData.delayFrame;
			frameData.tryCall();
			this.setFrame(frameData.bitmapData);
		}
		if (frame == this.timeline.maxFrame - 1) {
			onComplete();
		}
	}

	dynamic public function onComplete():Void {}

	public static function createAnimation(fps:Int, bitmaps:Array<Frame>):BAnimation {
		var an:BAnimation = new BAnimation();
		var anData = new AnimationData(fps);
		anData.addFrames(bitmaps);
		an.dataProvider = anData;
		return an;
	}

	override public function onFrame():Void {
		super.onFrame();
		if (_animation == null || !isPlaying || loop == 0)
			return;
		timeline.advanceTime(Start.current.frameDt);
		// if (_animation.update()) {
		// 	if (_delayFrame > 0) {
		// 		_delayFrame--;
		// 		return;
		// 	}
		// 	currentFrame++;
		// 	if (currentFrame >= _animation.frames.length) {
		// 		currentFrame = 0;
		// 		if (loop > 0)
		// 			loop--;
		// 		onComplete();
		// 	}
		// 	// 设置间隔帧
		// 	if (_animation != null) {
		// 		var frameData:FrameData = _animation.getFrame(currentFrame);
		// 		if (frameData != null) {
		// 			_delayFrame = frameData.delayFrame;
		// 			frameData.tryCall();
		// 			this.setFrame(frameData.bitmapData);
		// 		}
		// 	}
		// }
	}

	public var dataProvider(get, set):AnimationData;

	private function get_dataProvider():AnimationData {
		return _animation;
	}

	private function set_dataProvider(value:AnimationData):AnimationData {
		_animation = value;
		if (_animation != null && _animation.getFrame(currentFrame) != null) {
			timeline.fps = _animation.fps;
			timeline.maxFrame = _animation.frames.length;
			this.setFrame(_animation.getFrame(currentFrame).bitmapData);
		}
		return value;
	}

	/**
	 * 播放动画
	 * @param loop 播放次数
	 */
	public function play(loop:Int = 0):Void {
		if (loop != 0)
			this.loop = loop;
		isPlaying = true;
		this.setFrameEvent(true);
	}

	/**
	 * 停止至某一帧
	 * @param frame - 指定停止帧
	 */
	public function stop(frame:Int = -1):Void {
		isPlaying = false;
		this.setFrameEvent(false);
		if (frame >= 0)
			currentFrame = frame;
		if (_animation != null && _animation.getFrame(currentFrame) != null) {
			this.setFrame(_animation.getFrame(currentFrame).bitmapData);
		}
	}

	/**
	 * 在指定帧开始播放
	 * @param frame - 指定播放帧
	 * @param loop - 播放次数
	 */
	public function playGo(frame:Int, loop:Int = 0):Void {
		isPlaying = true;
		if (frame >= 0)
			currentFrame = frame;
		if (_animation != null && _animation.getFrame(currentFrame) != null) {
			this.setFrame(_animation.getFrame(currentFrame).bitmapData);
		}
	}
}
