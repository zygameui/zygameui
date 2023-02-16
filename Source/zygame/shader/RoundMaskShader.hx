package zygame.shader;

import glsl.OpenFLShader;
import VectorMath;

/**
 * 圆角遮罩，可以设置四个角的圆角大小
 */
class RoundMaskShader extends OpenFLShader {
	@:uniform public var px:Vec4;

	/**
	 * 检查点是否在圆的范围内
	 * @param x 检索圆心X
	 * @param y 检索圆心Y
	 * @param size 圆的半径
	 * @return Bool
	 */
	@:glsl public function checkRound(x:Float, y:Float, size:Float):Bool {
		return distance(vec2(x, y) * gl_openfl_TextureSize, gl_openfl_TextureCoordv.xy * gl_openfl_TextureSize) < size * gl_openfl_TextureSize.x;
	}

	override function fragment() {
		super.fragment();
		// 左
		var xsize:Float = px.x / gl_openfl_TextureSize.x;
		var xsize_y:Float = px.x / gl_openfl_TextureSize.y;
		// 右
		var ysize:Float = px.y / gl_openfl_TextureSize.x;
		var ysize_y:Float = px.y / gl_openfl_TextureSize.y;
		// 左下
		var zsize:Float = px.z / gl_openfl_TextureSize.x;
		var zsize_y:Float = px.z / gl_openfl_TextureSize.y;
		// 右下
		var wsize:Float = px.w / gl_openfl_TextureSize.x;
		var wsize_y:Float = px.w / gl_openfl_TextureSize.y;
		// 矩形补充
		gl_FragColor = vec4(0);
		if ((gl_openfl_TextureCoordv.x >= xsize || gl_openfl_TextureCoordv.y >= xsize_y)
			&& gl_openfl_TextureCoordv.x <= 0.5
			&& gl_openfl_TextureCoordv.y <= 0.5) {
			gl_FragColor = color;
		}
		if ((gl_openfl_TextureCoordv.x <= 1 - ysize || gl_openfl_TextureCoordv.y >= ysize_y)
			&& gl_openfl_TextureCoordv.x >= 0.5
			&& gl_openfl_TextureCoordv.y <= 0.5) {
			gl_FragColor = color;
		}
		if ((gl_openfl_TextureCoordv.x >= zsize || gl_openfl_TextureCoordv.y <= 1 - zsize_y)
			&& gl_openfl_TextureCoordv.x <= 0.5
			&& gl_openfl_TextureCoordv.y >= 0.5) {
			gl_FragColor = color;
		}
		if ((gl_openfl_TextureCoordv.x <= 1 - wsize || gl_openfl_TextureCoordv.y <= 1 - wsize_y)
			&& gl_openfl_TextureCoordv.x >= 0.5
			&& gl_openfl_TextureCoordv.y >= 0.5) {
			gl_FragColor = color;
		}
		if (checkRound(xsize, xsize_y, xsize)
			|| checkRound(1 - ysize, ysize_y, ysize)
			|| checkRound(zsize, 1 - zsize_y, zsize)
			|| checkRound(1 - wsize, 1 - wsize_y, wsize))
			gl_FragColor = color;
		gl_FragColor *= gl_openfl_Alphav;
	}

	/**
	 * 圆角遮罩
	 * @param lefttop 左上
	 * @param righttop 右上
	 * @param leftbottom 左下
	 * @param rightbottom 右下
	 */
	public function new(lefttop:Float = 16, righttop:Float = 16, leftbottom:Float = 16, rightbottom:Float = 16) {
		super();
		u_px.value = [lefttop, righttop, leftbottom, rightbottom];
	}
}
