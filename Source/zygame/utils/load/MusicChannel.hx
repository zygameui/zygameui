package zygame.utils.load;

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
}
