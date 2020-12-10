package zygame.utils.load;

import zygame.utils.load.Music;
#if qq
import qq.media.Sound;
// #elseif android
// import zygame.media.Sound;
#elseif extsound
import common.media.Sound;
#else
import openfl.media.Sound;
#end
// import openfl.Assets;
import zygame.utils.AssetsUtils in Assets;

/**
 * 加载音频使用，长音频
 */
class MusicLoader {

    public var path:String;

    public function new(path:String):Void
    {
        this.path = path;
    }

    /**
     * 加载音频
     * @param call 
     */
    public function load(call:Music->Void,errorCall:String->Void)
    {
        #if (android || mac || ios)
        var ogg:String = cast path;
        ogg = ogg.substr(0,ogg.lastIndexOf(".")) + ".ogg";
        path = ogg;
        #end
        Assets.loadSound(path,false).onComplete(function(sound:Sound):Void{
            var music:Music = new Music(sound);
            music.path = path;
            call(music);
        }).onError(errorCall);
    }

}
