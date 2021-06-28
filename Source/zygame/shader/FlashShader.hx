package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL;
import VectorMath;

/**
 * 闪光效果：从左下角开始闪
 */
class FlashShader extends OpenFLShader {
	@:uniform public var time:Float;

	/**
	 * 尺寸
	 */
	@:uniform public var size:Float;

	/**
	 * 叠加颜色
	 */
	@:uniform public var mulcolor:Vec4;

	/**
	 * 角度
	 */
	@:uniform public var angle:Float;

	/**
	 * 新建闪光效果
	 * @param size 
	 * @param color 
	 * @param angle 角度，默认为-0.2 左下角扫入
	 */
	public function new(size:Float, color:UInt, angle:Float = -0.2) {
		super();
		this.setFrameEvent(true);
		u_time.value = [0];
		u_size.value = [size];
		u_angle.value = [angle];
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		u_mulcolor.value = [r / 255, g / 255, b / 255, 1];
	}

	override function fragment() {
		super.fragment();
		var lightLen:Float = size / gl_openfl_TextureSize.x;
		var bright:Float = distance(gl_openfl_TextureCoordv.x + angle * gl_openfl_TextureCoordv.y, tan(time));
		if (bright < lightLen) {
			// 在闪光范围内：闪光叠加颜色 * 光亮强度
			this.gl_FragColor = color + mulcolor * color.a * ((lightLen - bright) / lightLen);
		}
	}

	override function onFrame() {
		super.onFrame();
		u_time.value[0] += 1 / 60;
	}
}
