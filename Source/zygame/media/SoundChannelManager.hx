package zygame.media;

import openfl.media.SoundTransform;
import zygame.utils.ZLog;
import haxe.Exception;
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

	/**
	 * 获取背景音乐渠道
	 * @return MusicChannel
	 */
	public function getMusicChannel():MusicChannel {
		return _musicChannel;
	}

	private var _effectChannel:Array<SoundChannel> = [];

	/**
	 * 背景音频的可用性
	 */
	private var _musicAvailable:Bool = true;

	private var _musicVolume:SoundTransform = new SoundTransform();

	/**
	 * 音效音频的可用性
	 */
	private var _effectAvailable:Bool = true;

	private var _effectVolume:SoundTransform = new SoundTransform();

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
					#if (!minigame || minigame_sound_v2)
					c.soundTransform = _effectVolume;
					#end
					_effectChannel.push(c);
					cast(c, EventDispatcher).addEventListener(Event.SOUND_COMPLETE, function(e) {
						_effectChannel.remove(c);
					});
					return c;
				}
			} catch (e:Exception) {
				ZLog.exception(e);
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
		if (sound.isDispose())
			return;
		if (_musicChannel != null && sound == _music) {
			ZLog.warring("[背景音乐]不能重复播放");
			return;
		}
		this.stopMusic();
		_music = sound;
		try {
			if (_musicAvailable) {
				if (_music != null) {
					_musicChannel = _music.play(99999);
					_musicChannel.setVolume(_musicVolume.volume);
				}
			}
		} catch (e:Exception) {
			ZLog.exception(e);
		}
	}

	/**
	 * 停止背景音效
	 */
	public function stopMusic(canResume:Bool = false):Void {
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
		if (force) {
			stopMusic(true);
		}
		if (_music != null) {
			#if weixin
			// 微信需要延迟一下
			zygame.utils.Lib.setTimeout(() -> {
				this.playMusic(_music);
			}, 1000);
			#else
			this.playMusic(_music);
			#end
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
			this.stopMusic(true);
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
	 * 设置背景音乐音量
	 * @param volume 
	 */
	public function setMusicVolume(volume:Float):Void {
		_musicVolume.volume = volume;
		_musicChannel?.setVolume(volume);
	}

	/**
	 * 设置音频音乐音量
	 * @param volume 
	 */
	public function setEffectVolume(volume:Float):Void {
		_effectVolume.volume = volume;
		for (channel in _effectChannel) {
			#if (!minigame || minigame_sound_v2)
			channel.soundTransform = _effectVolume;
			#end
		}
	}

	/**
	 * 音效是否可用
	 * @return Bool
	 */
	public function isEffectAvailable():Bool {
		return _effectAvailable && _effectVolume.volume > 0;
	}

	/**
	 * 背景音乐是否可用
	 * @return Bool
	 */
	public function isMusicAvailable():Bool {
		return _musicAvailable && _musicVolume.volume > 0;
	}
}
