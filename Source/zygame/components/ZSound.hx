package zygame.components;

import zygame.media.SoundChannelManager;
import zygame.utils.ZLog;
import zygame.core.Start;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;

/**
 * 音频对象，默认允许XML中使用。
 * ```xml
 * <ZSound id="soundName" src="soundName"/>
 * ```
 */
class ZSound implements zygame.core.Refresher {
	private static var _soundlist:Array<ZSound> = [];

	/**
	 * 停止所有ZSound逻辑
	 */
	public static function stopAllSound():Void {
		var array = _soundlist;
		var len = array.length;
		while (len >= 0) {
			len--;
			if (Std.isOfType(array[len], ZSound)) {
				cast(array[len], ZSound).stop();
			}
		}
	}

	/**
	 * 设置播放源
	 */
	public var src:String;

	/**
	 * 是否为背景音乐
	 */
	public var isBgMusic:Bool = false;

	private var _channels:Array<SoundChannel> = [];

	private var _soundPlayTimes:Array<Int> = [];

	private var _soundIndex:Int = 0;

	private var _currentFrame = 0;

	private var _loop:Int = 0;

	/**
	 * 设置音频的节奏
	 */
	public var rhythm(never, set):String;

	private function set_rhythm(value:String):String {
		_soundPlayTimes = [];
		if (value == null || value == "")
			return value;
		var array = value.split(" ");
		for (s in array) {
			var value = Std.int(Std.parseInt(s) / 1000 * 60);
			_soundPlayTimes.push(value);
		}
		return value;
	}

	/**
	 * 多功能音频组件
	 * @param src 音频
	 * @param bgmusic 是否为背景音乐
	 */
	public function new(src:String, bgmusic:Bool) {
		isBgMusic = bgmusic;
		this.src = src;
	}

	/**
	 * 帧事件处理
	 */
	public function onFrame():Void {
		if (_soundPlayTimes[_soundIndex] == _currentFrame) {
			__playSound(1);
		}
		_currentFrame++;
	}

	private function __playSound(loop:Int = 1):Void {
		var sound:Sound = ZBuilder.getBaseSound(src);
		if (sound != null) {
			// 开始播放
			ZLog.warring("ZSound:" + src + "播放");
			_channels.push(sound.play(0, loop));
			_currentFrame = 0;
			_soundIndex++;
			if (_soundPlayTimes.length != 0 && _soundIndex >= _soundPlayTimes.length) {
				_soundIndex = 0;
				if (_loop > 0) {
					_loop--;
					if (_loop == 0)
						stop();
				}
			}
		} else {
			ZLog.warring("ZSound:" + src + "不存在");
			// 已成为无效音频，直接停止
			stop();
		}
	}

	/**
	 * 强制播放：该方法会独立播放，不会停止已播放的音频
	 */
	public function playForce():Void {
		this.__playSound(1);
	}

	/**
	 * 开始播放
	 * @param loop 是否循环，默认为1次
	 */
	public function play(loop:Int = 1):Void {
		if (!SoundChannelManager.current.isEffectAvailable())
			return;
		this.stop();
		this._loop = loop;
		if (_soundPlayTimes.length == 0) {
			__playSound(loop);
		} else {
			_soundIndex = 0;
			if (_soundPlayTimes[_soundIndex] != 0) {
				__playSound(1);
			}
			Start.current.addToUpdate(this);
		}
		_soundlist.push(this);
	}

	/**
	 * 停止所有音频
	 */
	public function stop():Void {
		for (channel in _channels) {
			if (channel != null)
				channel.stop();
		}
		_channels = [];
		Start.current.removeToUpdate(this);
		_soundlist.remove(this);
	}
}
