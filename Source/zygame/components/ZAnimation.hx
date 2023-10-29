package zygame.components;

import zygame.components.data.TimelineData;
import zygame.components.ZImage;
import zygame.components.data.AnimationData;
import openfl.events.Event;

/**
 *  动画组件，可用于渲染帧动画使用。
 */
class ZAnimation extends ZImage {
	/**
	 * 时间轴
	 */
	public var timeline:TimelineData = new TimelineData(0, 60);

	/**
	 * 快捷创建一个动画
	 * @param fps 动画频率
	 * @param bitmaps 动画帧动画列表
	 * @return ZAnimation
	 */
	public static function createAnimation(fps:Int, bitmaps:Array<Dynamic>):ZAnimation {
		var an:ZAnimation = new ZAnimation();
		var anData:AnimationData = new AnimationData(fps);
		anData.addFrames(bitmaps);
		an.dataProvider = anData;
		return an;
	}

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
	public var currentFrame(get, set):Int;

	private function get_currentFrame():Int {
		return timeline.currentFrame;
	}

	private function set_currentFrame(f:Int):Int {
		timeline.currentFrame = f;
		return f;
	}

	/**
	 *  延迟计算
	 */
	private var _delayFrame:Int;

	/**
	 * 动画数据
	 */
	private var _animation:AnimationData;

	/**
	 * 当构造出一个ZAnimation对象时，可以通过dataProvider赋值一个AnimationData对象来进行获取动画数据，这个类很适合处理简单的动画。
	 * 也可以通过ZAnimation.createAnimation工厂模式进行快捷创建动画。
	 */
	public function new() {
		super();
		timeline.onFrame = __onFrameUpdate;
	}

	override public function initComponents():Void {
		super.initComponents();
	}

	override public function onAddToStage():Void {
		this.setFrameEvent(true);
	}

	override public function onRemoveToStage():Void {
		this.setFrameEvent(false);
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
			super.dataProvider = frameData.bitmapData;
		}
		if (frame == this.timeline.maxFrame - 1) {
			if (this.hasEventListener(Event.COMPLETE))
				this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	override public function onFrame():Void {
		if (_animation == null || !isPlaying)
			return;
		this.timeline.advanceTime(this.delay);
	}

	/**
	 * 获取动画数据，内含有FPS
	 * @return AnimationData
	 */
	public function getData():AnimationData {
		return this.dataProvider;
	}

	private override function set_dataProvider(data:Dynamic):Dynamic {
		_animation = cast data;
		if (_animation != null) {
			this.timeline.fps = _animation.fps;
			this.timeline.maxFrame = _animation.frames.length;
		}
		if (isPlaying)
			this.gotoAndPlay(0);
		else
			this.stop(0);
		return data;
	}

	private override function get_dataProvider():Dynamic {
		return _animation;
	}

	/**
	 * 播放动画
	 * @param loop 播放次数
	 */
	public function play(loop:Int = 0):Void {
		if (loop != 0)
			this.timeline.loop = loop == 0 ? 1 : loop;
		isPlaying = true;
	}

	/**
	 * 停止至某一帧
	 * @param frame - 指定停止帧
	 */
	public function stop(frame:Int = -1):Void {
		isPlaying = false;
		if (frame >= 0)
			timeline.currentFrame = frame;
		if (_animation != null) {
			if (_animation.getFrame(timeline.currentFrame) != null)
				super.dataProvider = _animation.getFrame(timeline.currentFrame).bitmapData;
		}
	}

	/**
	 * 在指定帧开始播放
	 * @param frame - 指定播放帧
	 * @param loop - 播放次数
	 */
	@:deprecated("弃用playGo接口，请改使用gotoAndPlay接口")
	public function playGo(frame:Int, loop:Int = 0):Void {
		gotoAndPlay(frame, loop);
	}

	/**
	 * 跳转到某一帧开始播放
	 * @param frame 
	 * @param loop 
	 */
	public function gotoAndPlay(frame:Int, loop:Int = 0):Void {
		if (_animation != null) {
			this.timeline.loop = loop == 0 ? 1 : loop;
			isPlaying = true;
			if (frame >= 0)
				timeline.currentFrame = frame;
			if (_animation.getFrame(timeline.currentFrame) != null)
				super.dataProvider = _animation.getFrame(timeline.currentFrame).bitmapData;
		}
	}

	/**
	 * 跳转到某一帧停止
	 * @param frame 
	 */
	public function gotoAndStop(frame:Int):Void {
		gotoAndPlay(frame, 0);
		isPlaying = false;
	}
}
