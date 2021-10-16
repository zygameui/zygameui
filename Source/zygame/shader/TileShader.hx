package zygame.shader;

import glsl.OpenFLShader;
import VectorMath;
import glsl.GLSL.texture2D;

/**
 * 瓦片平铺着色器
 */
class TileShader extends OpenFLShader {
	@:uniform public var size:Vec2;

	override function vertex() {
		super.vertex();
	}

	override function fragment() {
		super.fragment();
		// 计算平铺位置，但这里的(8,8)需要根据比例计算，才能得到图片的正常尺寸
		var uv:Vec2 = gl_openfl_TextureCoordv * gl_openfl_TextureSize * (size / gl_openfl_TextureSize) / gl_openfl_TextureSize;
		var v:Vec2 = fract(vec2(uv.x, uv.y));
		gl_FragColor = texture2D(gl_openfl_Texture, v);
	}

	/**
	 * 
	 * @param w 画布宽度
	 * @param h 画布高度
	 */
	public function new(w:Float, h:Float) {
		super();
		this.u_size.value = [w, h];
	}

}
