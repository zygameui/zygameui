package zygame.shader;

import zygame.shader.engine.Vec2;
import zygame.shader.engine.OpenFLShader;

/**
 * 像素化对象
 */
class PixelShader extends OpenFLShader {
	/**
	 * 像素间隔定义
	 */
	@:uniform public var px:Float;

	public function new(px:Int) {
		super();
		this.u_px.value = [px];
	}

	/**
	 * 编写fragment
	 */
	override function fragment() {
		super.fragment();
		// 像素化效果
		var s:Vec2 = this.floor(gl_openfl_TextureCoordv * gl_openfl_TextureSize / px) * px;
		gl_FragColor = texture2D(gl_openfl_Texture, s / gl_openfl_TextureSize);
	}
}
