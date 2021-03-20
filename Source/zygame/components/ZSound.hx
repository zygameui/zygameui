package zygame.components;

import zygame.core.Start;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;

class ZSound implements zygame.core.Refresher {
	/**
	 * 停止所有ZSound逻辑
	 */
	public static function stopAllSound():Void {
		var array = @:privateAccess Start.current.updates;
		var len = array.length;
		while (len >= 0) {
			len--;
			if (Std.is(array[len], ZSound)) {
				array.removeAt(len);
			}
		}
	}

	public var src:String;

	public var isBgMusic:Bool = false;

	private var _channels:Array<SoundChannel> = [];

	private var _soundPlayTimes:Array<Int> = [];

	private var _soundIndex:Int = 0;

	private var _currentFrame = 0;

	private var _loop:Int = 0;

	/**
	 * 设置音频的节奏
	 */
	public var rhythm(get, set):String;

	private function get_rhythm():String {
		return null;
	}

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
			_channels.push(sound.play(0, loop));
			_currentFrame = 0;
			_soundIndex++;
			if (_soundIndex >= _soundPlayTimes.length) {
				_soundIndex = 0;
				if (_loop > 0) {
					_loop--;
					if (_loop == 0)
						Start.current.removeToUpdate(this);
				}
			}
		} else {
			// 已成为无效音频，直接停止
			stop();
		}
	}

	/**
	 * 开始播放
	 */
	public function play(loop:Int = 1):Void {
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
	}

	/**
	 * 停止所有音频
	 */
	public function stop():Void {
		for (channel in _channels) {
			channel.stop();
		}
		_channels = [];
		Start.current.removeToUpdate(this);
	}
}
