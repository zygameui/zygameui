package zygame.display.batch;

import openfl.geom.Rectangle;

/**
 * 批渲染的基础属性
 */
interface ITileDisplayObject {

    /**
     * 获取显示对象的宽度
     */
    public var width(get,set):Float;

    /**
     * 获取显示对象的高度
     */
    public var height(get,set):Float;

    /**
     * 获取原图尺寸
     */
    public var curWidth(get,never):Float;

    /**
     * 获取原图尺寸
     */
    public var curHeight(get,never):Float;

    #if(openfl<'8.7.0')
    /**
     * 获取尺寸
     * @return Rectangle
     */
    public function getBounds(title:openfl.display.Tile):Rectangle;
    #end
}