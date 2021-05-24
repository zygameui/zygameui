package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL;

/**
 * 图层透明着色器
 */
class LayerAlphaShader extends OpenFLShader {
	@:uniform public var malpha:Float;

	public function new(a:Float = 1) {
		super();
		this.u_malpha.value = [a];
	}

	override function fragment() {
		super.fragment();
		gl_FragColor.x *= malpha;
		gl_FragColor.y *= malpha;
		gl_FragColor.z *= malpha;
		gl_FragColor.w *= malpha;
	}
}
