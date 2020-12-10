package zygame.utils.load;

import openfl.display.Tileset;
import openfl.display.BitmapData;

/**
 * 精灵图渲染基类，提供给ImageBatchs获取Tileset使用
 */
class Atlas {

    /**
     * 是否为文本缓存精灵表
     */
    public var isTextAtlas:Bool = false;


    public function getTileset():openfl.display.Tileset
    {
        return null;
    }

}