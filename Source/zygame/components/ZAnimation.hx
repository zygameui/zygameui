package zygame.components;

import zygame.components.ZImage;
import zygame.components.data.AnimationData;
import openfl.events.Event;

/**
 *  动画组件，可用于渲染帧动画使用。
 */
class ZAnimation extends ZImage {
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
	public var loop:Int = -1;

	/**
	 *  是否播放中
	 */
	public var isPlaying:Bool = false;

	/**
	 *  当前帧
	 */
	public var currentFrame:Int;

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

	/**
	 * 下一帧
	 */
	public function nextFrame():Void {
		currentFrame++;
		if (currentFrame >= _animation.frames.length) {
			if (loop > 0)
				loop--;
			if (loop > 0) {
				currentFrame = 0;
			} else
				currentFrame = _animation.frames.length - 1;
			if (this.hasEventListener(Event.COMPLETE))
				this.dispatchEvent(new Event(Event.COMPLETE));
		}
		updateFrame();
	}

	private function updateFrame():Void {
		// 设置间隔帧
		var frameData:FrameData = _animation.getFrame(currentFrame);
		if (frameData != null) {
			_delayFrame = frameData.delayFrame;
			frameData.tryCall();
			super.dataProvider = frameData.bitmapData;
		}
	}

	override public function onFrame():Void {
		if (_animation == null || !isPlaying || loop == 0)
			return;
		if (_animation.update()) {
			if (_delayFrame > 0) {
				_delayFrame--;
				return;
			}
			nextFrame();
		}
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
		if (isPlaying)
			this.playGo(0);
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
			this.loop = loop;
		isPlaying = true;
	}

	/**
	 * 停止至某一帧
	 * @param frame - 指定停止帧
	 */
	public function stop(frame:Int = -1):Void {
		isPlaying = false;
		if (frame >= 0)
			currentFrame = frame;
		if (_animation != null) {
			if (_animation.getFrame(currentFrame) != null)
				super.dataProvider = _animation.getFrame(currentFrame).bitmapData;
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
			isPlaying = true;
			if (frame >= 0)
				currentFrame = frame;
			if (_animation.getFrame(currentFrame) != null)
				super.dataProvider = _animation.getFrame(currentFrame).bitmapData;
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

	override public function onRemove():Void {
		super.onRemove();
		this.setFrameEvent(false);
	}
}
