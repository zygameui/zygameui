package zygame.media;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import zygame.utils.load.MusicChannel;
import zygame.utils.load.Music;
import zygame.media.base.Sound;
import zygame.media.base.SoundChannel;

/**
 * 声音渠道管理中心，用于控制所有的音频出入口
 */
class SoundChannelManager {
	private static var _current:SoundChannelManager;

	public static function current():SoundChannelManager {
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

	public function new() {}

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
					if(c == null)
						return c;
					_effectChannel.push(c);
					cast(c,EventDispatcher).addEventListener(Event.SOUND_COMPLETE, function(e) {
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
        if(_musicChannel != null && sound == _music){
			trace("Muisc is repat:" + sound.path);
			return;
		}
		this.stopMusic();
		_music = sound;
		try {
			if (_musicAvailable){
                if(_music != null)
                    _musicChannel = _music.play(99999);
            }
		} catch (e:Dynamic) {
			trace("音频播放异常：", e);
		}
	}

	/**
	 * 停止背景音效
	 */
	public function stopMusic():Void {
		if (_musicChannel != null) {
			trace("[背景音乐]stopMusic");
			_musicChannel.stop();
			_musicChannel = null;
		}
	}

	/**
	 * 恢复背景音效
	 */
	public function resumeMusic():Void {
		if (_music != null) {
			trace("[背景音乐]resumeMusic");
			this.playMusic(_music);
		}
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
	public function stopAllEffectAndMusic():Void {
		this.stopAllEffect();
		this.stopMusic();
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
        if(!bool)
            this.stopAllEffect();
    }

    /**
     * 音效是否可用
     * @return Bool
     */
    public function isEffectAvailable():Bool{
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
