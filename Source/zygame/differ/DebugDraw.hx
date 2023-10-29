package zygame.differ;

import openfl.display.BitmapData;
import zygame.utils.load.TextureLoader.TextureAtlas;
import zygame.components.ZQuad;
import zygame.components.ZGraphics;
import differ.ShapeDrawer;

/**
 * 用于渲染Shapes的碰撞结果的调试渲染
 */
class DebugDraw extends ShapeDrawer {
	/**
	 * 绘制显示对象
	 */
	public var display:ZGraphics;

	public function new() {
		super();
		display = new ZGraphics();
		#if (zygameui >= '14.0.0')
		var atlas = TextureAtlas.createTextureAtlasByOne(new BitmapData(1, 1, true, 0xffffffff));
		#else
		var atlas = TextureAtlas.createTextureAtlasByOne(ZQuad.quadBitmapData);
		#end
		display.beginTextureAtlas(atlas);
		display.beginFrameByName("img");
	}

	/**
	 * 清理当前画面
	 */
	public function clear():Void {
		display.clear();
	}

	/**
	 * 渲染碰撞图形
	 * @param shapes 
	 */
	public function drawShapes(shapes:Shapes) {
		for (shape in shapes.list) {
			this.drawShape(shape);
		}
		this.display.fillEnd();
	}

	override function drawLine(p0x:Float, p0y:Float, p1x:Float, p1y:Float, ?startPoint:Bool = true) {
		super.drawLine(p0x, p0y, p1x, p1y, startPoint);
		display.drawLine(p0x, p0y, p1x, p1y);
	}
}
