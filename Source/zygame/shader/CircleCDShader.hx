package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL.texture2D;
import VectorMath;

/**
 * 圆CD进度效果的GLSL
 */
class CircleCDShader extends OpenFLShader {
	@:uniform public var scale:Float;

	override function fragment() {
		super.fragment();
		// 获得UV
		var uv:Vec2 = gl_openfl_TextureCoordv * gl_openfl_TextureSize;
		// 中心点UV
		var centerUv:Vec2 = vec2(0.5) * gl_openfl_TextureSize;
		// 计算角度
		var r:Float = atan2(uv.x - centerUv.y, uv.y - centerUv.x);
		r = r * (180 / 3.14) + 180;
		if (r < (360) * scale) {
			var len:Float = gl_openfl_TextureSize.x < gl_openfl_TextureSize.y ? gl_openfl_TextureSize.x : gl_openfl_TextureSize.y;
			if (distance(vec2(0.5) * gl_openfl_TextureSize, gl_openfl_TextureCoordv.xy * gl_openfl_TextureSize) < len * 0.5) {
				gl_FragColor = texture2D(gl_openfl_Texture, gl_openfl_TextureCoordv);
			} else {
				gl_FragColor = vec4(0);
			}
		} else {
			gl_FragColor = vec4(0);
		}
	}

	public function new() {
		super();
		this.u_scale.value = [0];
	}

	/**
	 * 设置进度值，0-1
	 * @param pro 
	 */
	public function setProgress(pro:Float):Void {
		this.u_scale.value[0] = pro;
	}
}
