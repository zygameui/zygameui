package zygame.shader;

import glsl.GLSL.texture2D;
import glsl.Sampler2D;
import glsl.OpenFLGraphicsShader;
import VectorMath;

/**
 * 用于实现Spine在Sprite模式下的透明值、BlendMode等支持
 */
class SpineRenderShader extends OpenFLGraphicsShader {
	/**
	 * 纹理透明度
	 */
	@:attribute public var texalpha:Float;

	/**
	 * BlendMode: 1:BlendMode.ADD
	 */
	@:attribute public var texblendmode:Float;

	/**
	 * 颜色变更：rgba，其中a代表是否需要计算颜色变更
	 */
	@:attribute public var texcolor:Vec4;

	/**
	 * x:透明度
	 * y:BlendMode
	 */
	@:varying public var alphaBlendMode:Vec2;

	/**
	 * 颜色相乘
	 */
	@:varying public var mulcolor:Vec4;

	/**
	 * 透明度
	 */
	@:uniform public var malpha:Float;

	/**
	 * 第二个纹理
	 */
	@:uniform public var bitmap2:Sampler2D;

	override function fragment() {
		super.fragment();
		if (mulcolor.a == 1) {
			color +=  texture2D(bitmap2, gl_openfl_TextureCoordv);
		} else {
			color = texture2D(bitmap, gl_openfl_TextureCoordv);
		}
		gl_FragColor = color * alphaBlendMode.x;
		if (alphaBlendMode.y == 1) {
			gl_FragColor.a = gl_FragColor.a * 0;
		}
		// if (mulcolor.a == 1) {
		gl_FragColor.rgb = gl_FragColor.rgb * mulcolor.rgb;
		// }
		gl_FragColor = gl_FragColor * malpha;
	}

	/**
	 * 顶点着色器
	 */
	override function vertex() {
		super.vertex();
		alphaBlendMode = vec2(texalpha, texblendmode);
		mulcolor = texcolor;
	}
}
