package zygame.utils.load;

import openfl.events.Event;
import openfl.media.SoundTransform;
#if qq
import qq.media.SoundChannel;
// #elseif android
// import zygame.media.SoundChannel;
#elseif extsound
import common.media.SoundChannel;
#else
import openfl.media.SoundChannel;
#end

class MusicChannel {
	private var _channel:SoundChannel;

	public function new(channel:SoundChannel) {
		_channel = channel;
		_channel.addEventListener(Event.SOUND_COMPLETE, function(e) {
			if (onSoundComplete != null)
				onSoundComplete();
		});
	}

	/**
	 * 当音频播放完成后
	 */
	public var onSoundComplete:Void->Void;

	public function stop():Void {
		if (_channel != null)
			_channel.stop();
		_channel = null;
	}

	private var transform = new SoundTransform();

	/**
	 * 设置音量
	 * @param volume 
	 */
	public function setVolume(volume:Float):Void {
		transform.volume = volume;
		#if (wechat)
		@:privateAccess _channel._sound.volume = volume;
		#elseif (!vivo && !oppo && !huawei && !xiaomi)
		if (_channel != null)
			_channel.soundTransform = transform;
		#end
	}
}
