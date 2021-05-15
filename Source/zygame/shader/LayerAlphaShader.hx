package zygame.shader;

import zygame.shader.engine.OpenFLShader;

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
		gl_FragColor.r *= malpha;
		gl_FragColor.g *= malpha;
		gl_FragColor.b *= malpha;
		gl_FragColor.a *= malpha;
	}
}
