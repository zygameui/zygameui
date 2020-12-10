package zygame.media.base;

#if extsound

interface SoundChannel {

    public function stop():Void;

}

#else

typedef SoundChannel = openfl.media.SoundChannel;

#end