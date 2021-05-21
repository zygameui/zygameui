package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL;
import VectorMath;

/**
 * 用于实现Spine在Sprite模式下的透明值、BlendMode等支持
 */
class SpineRenderShader extends OpenFLShader {
	/**
	 * 纹理透明度
	 */
	@:attribute public var texalpha:Float;

	/**
	 * BlendMode: 1为BlendMode.ADD
	 */
	@:attribute public var texblendmode:Float;

	/**
	 * x:透明度
	 * y:BlendMode
	 */
	@:varying public var alphaBlendMode:Vec2;

	override function fragment() {
		super.fragment();
		gl_FragColor = color * alphaBlendMode.x * gl_openfl_Alphav;
		if (alphaBlendMode.y == 1) {
			gl_FragColor.w = 0;
		}
	}

	/**
	 * 顶点着色器
	 */
	override function vertex() {
		super.vertex();
		alphaBlendMode = vec2(texalpha, texblendmode);
	}
}
