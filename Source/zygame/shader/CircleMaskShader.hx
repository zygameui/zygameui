package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL.texture2D;
import VectorMath;

/**
 * 圆形遮罩，正中间的圆形渲染
 */
class CircleMaskShader extends OpenFLShader {
	@:uniform public var scale:Float;

	override function fragment() {
		super.fragment();
		var len:Float = gl_openfl_TextureSize.x < gl_openfl_TextureSize.y ? gl_openfl_TextureSize.x : gl_openfl_TextureSize.y;
		if (distance(vec2(0.5) * gl_openfl_TextureSize, gl_openfl_TextureCoordv.xy * gl_openfl_TextureSize) < len * 0.5 * scale) {
			gl_FragColor = texture2D(gl_openfl_Texture, gl_openfl_TextureCoordv);
		} else {
			gl_FragColor = vec4(0);
		}
	}

	/**
	 * 圆形遮罩，设置比例来覆盖圆形的范围。
	 * @param circleScale 
	 */
	public function new(circleScale:Float = 1) {
		super();
		u_scale.value = [circleScale];
	}
}
