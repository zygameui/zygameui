package zygame.components.skin;

import zygame.components.skin.BaseSkin;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.Frame;

/**
 * 按钮皮肤，需要提供精灵图对象
 */
class ButtonFrameSkin extends ButtonSkin {

    public var textureAtlas:TextureAtlas;
    
    public function new(sprites:TextureAtlas){
        super();
        textureAtlas = sprites;
    }

    /**
     * 获取批渲染使用的帧图片
     * @param skin 
     * @return Frame
     */
    public function getFrameSkin(skin:Dynamic):Frame
    {
        if(skin == null)
            return null;
        if(Std.is(skin,Frame))
            return skin;
        return null;

        // 2.25弃用
        // if(textureAtlas == null)
        //     return null;
        // return textureAtlas.getBitmapDataFrameFromBitmapData(skin);
    }

}