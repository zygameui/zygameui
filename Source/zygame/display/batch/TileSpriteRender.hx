package zygame.display.batch;

import openfl.geom.Matrix;
import openfl.Vector;
import openfl.display.Sprite;
import zygame.utils.Align;
import zygame.utils.load.Frame;
import zygame.utils.load.Atlas;
import openfl.display.Graphics;

/**
 * Tile渲染器
 */
class TileSpriteRender extends Sprite {
	public var smoothing:Bool = false;

	public var curFrame:Frame;

	public function setFrame(frame:Frame):Void {
		if (frame != this.curFrame) {
			this.curFrame = frame;
			if (this.curFrame != null) {
				__updateSize();
			}
			this.render();
		}
	}

	private function __updateSize():Void {
		var isFrameRect = curFrame.frameWidth != 0 || curFrame.frameHeight != 0;
		if (isFrameRect) {
			this.width = curFrame.width + Math.abs(curFrame.frameX);
			this.height = curFrame.height + Math.abs(curFrame.frameY);
			if (this.width < curFrame.frameWidth)
				this.width = curFrame.frameWidth;
			if (this.height < curFrame.frameHeight)
				this.height = curFrame.frameHeight;
		} else {
			this.width = curFrame.width;
			this.height = curFrame.height;
		}
	}

	/**
	 * 开始绘制
	 */
	public function render():Void {
		this.graphics.clear();
		if (curFrame != null && this.visible) {
			// TODO 渲染渲染
			var _quads:Vector<Float> = new Vector();
			var _transform:Vector<Float> = new Vector();
			var atlas = curFrame.parent;
			this.graphics.beginBitmapFill(atlas.getRootBitmapData());
			var rect = atlas.getTileset().getRect(curFrame.id);
			_quads.push(rect.x);
			_quads.push(rect.y);
			_quads.push(rect.width);
			_quads.push(rect.height);
			var matrix = new Matrix();
			_transform.push(matrix.a);
			_transform.push(matrix.b);
			_transform.push(matrix.c);
			_transform.push(matrix.d);
			_transform.push(matrix.tx);
			_transform.push(matrix.ty);
			this.graphics.drawQuads(_quads, null, _transform);
			this.graphics.endFill();
			this.alpha = 0.5;
		}
	}
}
