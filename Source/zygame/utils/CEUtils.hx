package zygame.utils;

import haxe.io.Bytes;
import haxe.crypto.Base64;

class CEUtils {
    
    public static function encode(data:String):String{
        return Base64.encode(Bytes.ofString(data));
    }

    public static function decode(data:String):String {
        return Base64.decode(data).toString();
    }

}