package zygame.media;

import zygame.events.SoundChannelManagerEvent;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import zygame.utils.load.MusicChannel;
import zygame.utils.load.Music;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;

/**
 * 声音渠道管理中心，用于控制所有的音频出入口
 */
class SoundChannelManager extends EventDispatcher {
	private static var _current:SoundChannelManager;

	public static var current(get, never):SoundChannelManager;

	private static function get_current():SoundChannelManager {
		if (_current == null)
			_current = new SoundChannelManager();
		return _current;
	}

	/**
	 * 背景音乐
	 */
	private var _music:Music;

	private var _musicChannel:MusicChannel;

	private var _effectChannel:Array<SoundChannel> = [];

	/**
	 * 背景音频的可用性
	 */
	private var _musicAvailable:Bool = true;

	/**
	 * 音效音频的可用性
	 */
	private var _effectAvailable:Bool = true;

	public function new() {
		super();
	}

	/**
	 * 播放音效入口
	 * @param sound
	 * @param loop
	 */
	private function playEffect(sound:Sound, loop:Int):SoundChannel {
		if (sound != null) {
			try {
				if (_effectAvailable) {
					var c = sound.play(0, loop);
					if (c == null)
						return c;
					_effectChannel.push(c);
					cast(c, EventDispatcher).addEventListener(Event.SOUND_COMPLETE, function(e) {
						_effectChannel.remove(c);
					});
					return c;
				}
			} catch (e:Dynamic) {
				trace("音频播放异常：", e);
			}
			return null;
		}
		return null;
	}

	/**
	 * 播放背景音乐入口
	 * @param sound
	 */
	private function playMusic(sound:Music):Void {
		trace("[背景音乐]playMusic");
		if (_musicChannel != null && sound == _music) {
			trace("[背景音乐]不能重复播放");
			return;
		}
		this.stopMusic();
		_music = sound;
		try {
			if (_musicAvailable) {
				if (_music != null) {
					trace("[背景音乐]开始播放");
					_musicChannel = _music.play(99999);
				}
			}
		} catch (e:Dynamic) {
			trace("音频播放异常：", e);
		}
	}

	/**
	 * 停止背景音效
	 */
	public function stopMusic(canResume:Bool = false):Void {
		trace("[背景音乐]stopMusic");
		if (_musicChannel != null) {
			_musicChannel.stop();
			_musicChannel = null;
		}
		if (!canResume)
			_music = null;
		this.dispatchEvent(new SoundChannelManagerEvent(SoundChannelManagerEvent.STOP_MUSIC));
	}

	/**
	 * 恢复背景音效
	 * @param force 是否强制恢复
	 */
	public function resumeMusic(force:Bool = false):Void {
		trace("[背景音乐]resumeMusic:force="+force);
		if (force) {
			stopMusic(true);
		}
		if (_music != null) {
			this.playMusic(_music);
		}
		this.dispatchEvent(new SoundChannelManagerEvent(SoundChannelManagerEvent.RESUME_MUSIC));
	}

	/**
	 * 停止所有音效播放
	 */
	public function stopAllEffect():Void {
		for (channel in _effectChannel) {
			channel.stop();
		}
		while (_effectChannel.length > 0)
			_effectChannel.remove(_effectChannel[0]);
	}

	/**
	 * 停止所有音效和背景
	 */
	public function stopAllEffectAndMusic(canResume:Bool = false):Void {
		this.stopAllEffect();
		this.stopMusic(canResume);
	}

	/**
	 * 设置背景音乐是否可用
	 * @param bool
	 */
	public function setMusicAvailable(bool:Bool):Void {
		_musicAvailable = bool;
		if (bool) {
			this.resumeMusic();
		} else {
			this.stopMusic();
		}
	}

	/**
	 * 设置音效是否可用
	 * @param bool
	 */
	public function setEffectAvailable(bool:Bool):Void {
		_effectAvailable = bool;
		if (!bool)
			this.stopAllEffect();
	}

	/**
	 * 音效是否可用
	 * @return Bool
	 */
	public function isEffectAvailable():Bool {
		return _effectAvailable;
	}

	/**
	 * 背景音乐是否可用
	 * @return Bool
	 */
	public function isMusicAvailable():Bool {
		return _musicAvailable;
	}
}
