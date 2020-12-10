package zygame.utils.load;

import openfl.Vector;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.BaseFrame;
import openfl.geom.Rectangle;
import openfl.display.Tileset;

@:keep
class Frame extends BaseFrame {

	public var name:String = null;

	public var frameX:Float = 0;

	public var frameY:Float = 0;

	public var frameWidth:Float = 0;

	public var frameHeight:Float = 0;

	public var rotate:Bool = false;

	/**
	 * UVS数据
	 */
	private var uvs:Array<Float>;

	public var parent:TextureAtlas;

	public function copy():Frame{
		var frame = new Frame();
		frame.name = name;
		frame.frameX = frameX;
		frame.frameY = frameY;
		frame.frameWidth = frameWidth;
		frame.frameHeight = frameHeight;
		frame.parent = parent;
		frame.rotate = rotate;
		frame.id = id;
		frame.width = width;
		frame.height = height;
		frame.x = x;
		frame.y = y;
		return frame;
	}

	/**
	 * 九宫格配置
	 */
	public var scale9frames(get, never):Array<Frame>;
    private var _scale9frames:Array<Frame>;

	public var scale9rect(get,set):Rectangle;
	private var _rect:Rectangle = null;
	private function get_scale9rect():Rectangle{
		return _rect;
	}
	private function set_scale9rect(rect:Rectangle):Rectangle {
		_rect = rect;
		if(_scale9frames != null){
			_scale9frames = null;
		}
		return _rect;
	}

	public function new() {}

	private function get_scale9frames():Array<Frame> {
        if(scale9rect == null)
        {
            return null;
        }
        if(_scale9frames != null)
            return _scale9frames;
		var rects:Array<Rectangle> = zygame.utils.Scale9Utils.createScale9Rects(this.x, this.y, this.width, this.height, scale9rect);
		_scale9frames = [];
		for (rect in rects) {
			@:privateAccess parent._tileset.addRect(rect);
			// 创建批处理帧
			var frame:Frame = new Frame();
			frame.id = @:privateAccess parent._tileset.numRects - 1;
			frame.x = rect.x;
			frame.y = rect.y;
			frame.width = rect.width;
			frame.height = rect.height;
			frame.parent = parent;
			_scale9frames.push(frame);
		}
		return _scale9frames;
	}

	/**
	 * 获取九宫格配置
	 * 九宫格用于指定缩放的区域，如一个图形的大小为100,100 scaleGrid参数设置为scaleGridTop=2，scaleGridBottom=98， scaleGridLeft=2， scaleGridRight=98，
	 * 则当对此图形做缩放时，x轴是2-98之间的像素做缩放 y轴是2-98之间的像素做缩放， x轴0-2,98-100的像素保持不变，y轴0-2，98-100的像素保持不变。如下图红色区域表示拉伸的像素，
	 * 绿色区域表示不变的像素。
	 * @return Tileset
	 */
	public function getScale9GirdTileset(rect:Rectangle):Tileset {
		return new Tileset(parent.getRootBitmapData(), zygame.utils.Scale9Utils.createScale9Rects(x, y, width, height, rect));
	}

	/**
	 * 获取图片的矩形
	 */
	public function getRect():Rectangle
	{
		return new Rectangle(x,y,width,height);
	}

	public function getUv():Array<Float> {
		if (uvs == null) {
			var x1 = this.x + 1;
			var y1 = this.y + 1;
			var w1 = this.width - 2;
			var h1 = this.height - 2;
			uvs = [];
			uvs.push(x1 / parent.getRootBitmapData().width);
			uvs.push(y1 / parent.getRootBitmapData().height);
			uvs.push((x1 + w1) / parent.getRootBitmapData().width);
			uvs.push(y1 / parent.getRootBitmapData().height);
			uvs.push(x1 / parent.getRootBitmapData().width);
			uvs.push((y1 + h1) / parent.getRootBitmapData().height);
			uvs.push((x1 + w1) / parent.getRootBitmapData().width);
			uvs.push((y1 + h1) / parent.getRootBitmapData().height);
		}
		return uvs;
	}
}
