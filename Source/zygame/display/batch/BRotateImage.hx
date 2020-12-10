package zygame.display.batch;

import zygame.utils.load.Frame;

/**
 * 兼容旋转后的精灵图片
 */
class BRotateImage extends BDisplayObjectContainer {
    
    private var bimg:BImage;

    public var curFrame(get,never):Frame;
    private function get_curFrame():Frame{
        return bimg.curFrame;
    }

    public function new(frame:Frame) {
        super();
        this.setFrame(frame);
    }

    public function setFrame(frame:Frame):Void{
        if(bimg == null){
            bimg = new BImage();
            this.addChild(bimg);
        }
        bimg.setFrame(frame);
        if(frame.rotate){
            bimg.rotation = 90;
            bimg.x += bimg.curHeight;
        }
    }

}