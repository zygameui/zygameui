package zygame.display.batch;

import zygame.core.Start;
import zygame.components.data.AnimationData;
import zygame.utils.load.Frame;

class BAnimation extends BImage {
	private var _animation:AnimationData;

	/**
	 *  播放次数
	 */
	public var loop:Int = -1;

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
		if (_animation.update()) {
			if (_delayFrame > 0) {
				_delayFrame--;
				return;
			}
			currentFrame++;
			if (currentFrame >= _animation.frames.length) {
				currentFrame = 0;
				if (loop > 0)
					loop--;
				onComplete();
			}
			// 设置间隔帧
			if (_animation != null) {
				var frameData:FrameData = _animation.getFrame(currentFrame);
				if (frameData != null) {
					_delayFrame = frameData.delayFrame;
					frameData.tryCall();
					this.setFrame(frameData.bitmapData);
				}
			}
		}
	}

	public var dataProvider(get, set):AnimationData;

	private function get_dataProvider():AnimationData {
		return _animation;
	}

	private function set_dataProvider(value:AnimationData):AnimationData {
        _animation = value;
        if(_animation != null && _animation.getFrame(currentFrame) != null)
		    this.setFrame(_animation.getFrame(currentFrame).bitmapData);
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
