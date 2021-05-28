package zygame.shader;

import glsl.OpenFLShader;
import glsl.GLSL;
import VectorMath;

/**
 * 图层透明着色器
 */
class ColorShader extends OpenFLShader {
	/**
	 * 建立着色器访问
	 */
	@:uniform public var mcolorvalue:Vec3;

	public function new(color:UInt = 1) {
		super();
		updateColor(color);
	}

	/**
	 * 着色器代码
	 */
	override function fragment() {
		super.fragment();
		// 更改颜色
		this.gl_FragColor.rgb = mcolorvalue * color.a;
		// 同步透明度
		this.gl_FragColor.w = color.w;
		this.gl_FragColor *= gl_openfl_Alphav;
	}

	/**
	 * 将颜色传递到着色器
	 * @param color 
	 */
	public function updateColor(color:UInt):Void {
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		if (this.u_mcolorvalue != null)
			this.u_mcolorvalue.value = [r / 255, g / 255, b / 255];
	}
}
