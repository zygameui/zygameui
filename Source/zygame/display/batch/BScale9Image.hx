package zygame.display.batch;

import zygame.display.batch.BScale9Image2;
import zygame.shader.Slice9Shader;
import zygame.utils.load.Frame;
import zygame.display.batch.BImage;

/**
 * 九宫格批渲染支持，需要在精灵表中进行bindScale9后的frame才能正常使用
 */
class BScale9Image extends BImage {
	public function new(frame:Frame = null) {
		super();
		this.width;
		this.height;
		// BScale9Image使用Slice9Shader着色器
		this.shader = new zygame.shader.Slice9Shader(0, 0, 0, 0, 0, 0);
		cast(this.shader, Slice9Shader).u_isFrameSprite.value = [true];
		setFrame(frame);
	}

	override function setFrame(frame:Frame) {
		super.setFrame(frame);
		if (frame != null)
			cast(this.shader, Slice9Shader).updateFrame(frame);
	}

	override private function set_width(value:Float):Float {
		super.set_width(value);
		updateScale9();
		return value;
	}

	override private function set_height(value:Float):Float {
		super.set_height(value);
		updateScale9();
		return value;
	}

	/**
	 * 更新刷新9宫格
	 */
	private function updateScale9():Void {
		if (curFrame == null)
			return;
		var left:Float = curFrame.scale9rect.x;
		var right:Float = curFrame.width - curFrame.scale9rect.x - curFrame.scale9rect.width;
		var bottom:Float = curFrame.height - curFrame.scale9rect.y - curFrame.scale9rect.height;
		var top:Float = curFrame.scale9rect.y;
		cast(this.shader, Slice9Shader).updateArgs(left, top, bottom,right, this.width, this.height);
	}
}