package zygame.shader;

import openfl.display.BitmapData;
import glsl.OpenFLShader;
import glsl.Sampler2D;

class BitmapMaskShader extends OpenFLShader {
	@:uniform var bitmapData:Sampler2D;

	public function new(bitmapData:BitmapData) {
		super();
		this.u_bitmapData.input = bitmapData;
	}

	override function fragment() {
		super.fragment();
		var maskColor:Vec4 = texture2D(bitmapData, gl_openfl_TextureCoordv);
		gl_FragColor = maskColor.a * color * gl_openfl_Alphav;
	}
}
