package zygame.media.base;

#if extsound

import openfl.utils.ByteArray;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoaderDataFormat;

/**
 * 音频接口
 */
interface Sound {
    
    public function load(url:URLRequest):Void;

    public function play(startTime:Int = 0,loop:Int = 1,isLoop:Bool = false):SoundChannel;

    public function close():Void;

	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void;

}

#else

typedef Sound = openfl.media.Sound;

#end