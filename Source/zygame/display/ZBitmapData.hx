package zygame.display;

import openfl.display3D.textures.TextureBase;
import openfl.display.BitmapData;
import lime.graphics.Image;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3D;
import zygame.utils.ZAssets;

/**
 * 纹理实现
 */
@:access(openfl.display.BitmapData)
class ZBitmapData  extends BitmapData {

    /**
     * 位图的路径
     */
    public var path:String;
    
    public static function fromImage (image:Image, transparent:Bool = true):ZBitmapData {
        
        if (image == null || image.buffer == null) return null;
        
        var bitmapData = new ZBitmapData (0, 0, transparent, 0);
        bitmapData.__fromImage (image);
        bitmapData.image.transparent = transparent;
        return bitmapData.image != null ? bitmapData : null;
        
    }

    #if html5
    override public function getTexture (context:Context3D):TextureBase {
        var t:TextureBase = super.getTexture(context);
        this.disposeCavansImage();
        return t;
    }

    private function disposeCavansImage() {
        super.disposeImage();
        var getImage:Image = image;
        if(getImage != null && getImage.buffer != null && untyped getImage.buffer.__srcImage != null && untyped getImage.buffer.__srcImage.disposeImage != null)
        {
            //卸载内存
            untyped getImage.buffer.__srcImage.disposeImage();
        }
    }
    #end

    override function dispose() {
        super.dispose();
        #if html5
        // this.disposeCavansImage();
        #end
    }

}