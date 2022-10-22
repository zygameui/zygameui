package zygame.utils.load;

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
	}

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
		#if weixin
		@:privateAccess _channel._sound.volume = volume;
		#else
		_channel.soundTransform = transform;
		#end
	}
}
