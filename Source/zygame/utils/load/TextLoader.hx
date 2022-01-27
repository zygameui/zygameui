package zygame.utils.load;

import zygame.utils.AssetsUtils in Assets;

/**
 * 文本载入
 */
class TextLoader {

    private var _path:String;

    public function new(path:String)
    {
        _path = path;
    }

    public function load(call:String->Void,errorCall:String->Void):Void
    {
        Assets.loadText(_path).onComplete(call).onError(errorCall);
    }

}