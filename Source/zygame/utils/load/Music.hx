package zygame.utils.load;

#if qq
import qq.media.Sound;
// #elseif android
// import zygame.media.Sound;
#elseif extsound
import common.media.Sound;
#else
import openfl.media.Sound;
#end
import zygame.utils.load.MusicChannel;

class Music {

    private var _sound:Sound;

    public var path:String;

    public function new(sound:Sound)
    {
        _sound = sound;
    }

    /**
     * 播放
     * @param loop 
     */
    public function play(loop:Int):MusicChannel
    {
        #if (qq || extsound)
        return new MusicChannel(_sound.play(0,-1,true));
        #else
        return new MusicChannel(_sound.play(0,loop));
        #end
    }

    /**
     * 关闭
     */
    public function close():Void
    {
        _sound.close();
        _sound = null;
    }

}