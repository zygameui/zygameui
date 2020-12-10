package zygame.utils;

import openfl.media.SoundMixer;
import openfl.media.SoundTransform;

/**
 * 音乐工具
 */
class SoundUtils {

    // /**
    //  * 安卓使用
    //  */
    // #if (android && KengSDK)
    // public static var soundPool:SoundPool = new SoundPool();
    // #end

    private static var _curVolume:Float = 1;
    
    /**
     * 设置整体游戏的音量大小
     * @param v 
     */
    public static function setVolume(v:Float):Void
    {
        _curVolume = v;
    }

    /**
     * 启动静音
     */
    public static function muteMusic():Void
    {
        // #if (android && KengSDK)
        // SoundMixer.soundTransform = new SoundTransform(0,0);
        // soundPool.setVolume(0);
        // #else
        SoundMixer.soundTransform = new SoundTransform(0,0);
        // #end
        #if (qq && (qq < "2.0.0"))
        //qqplaycore2.0.0以下版本支持
        untyped __js__("BK.Audio.switch = false");
        SoundMixer.stopAll();
        #end
    }

    /**
     * 恢复音量
     */
    public static function livenUpMusic():Void
    {
        // #if (android && KengSDK)
        // SoundMixer.soundTransform = new SoundTransform(_curVolume,0);
        // soundPool.setVolume(_curVolume);
        // #else
        SoundMixer.soundTransform = new SoundTransform(_curVolume,0);
        // #end
        #if (qq && (qq < "2.0.0"))
        //qqplaycore2.0.0以下版本支持
        untyped __js__("BK.Audio.switch = true");
        #end
    }
}