package zygame;

class ZStd {
    
    public static function is(v:Dynamic,v2:Dynamic):Bool
    {
        #if hl

        #else 
        return v == v2;
        #end
    }

    public static function isNot(v:Dynamic,v2:Dynamic):Bool
    {
        #if hl

        #else 
        return v != v2;
        #end
    }
}