package zygame.shader;

import zygame.utils.ColorUtils;
import glsl.OpenFLShader;
import VectorMath;
import glsl.GLSL;

/**
 * 描边着色器
 */
class StrokeShader extends OpenFLShader {
	/**
	 * 描边的大小
	 */
	@:uniform public var storksize:Float;

	/**
	 * 描边的颜色
	 */
	@:uniform public var storkcolor:Vec4;

	/**
	 * 字体开始的颜色（顶部）
	 */
	@:uniform public var startcolor:Vec4;

	/**
	 * 字体结束的颜色（底部）
	 */
	@:uniform public var endcolor:Vec4;

	/**
	 * 是否启动颜色
	 */
	@:uniform public var availableColor:Bool;

	/**
	 * 检测当前这个点的偏移位置是否包含透明度
	 * @param v2 
	 * @param offestX 
	 * @param offestY 
	 * @return Bool
	 */
	@:glsl public function getAlpha(v2:Vec2, offestX:Float, offestY:Float):Float {
		return texture2D(gl_openfl_Texture, v2 + vec2(offestX, offestY)).a;
	}

	/**
	 * 每个点都做一次圆检测
	 * @param v2 
	 * @return Bool
	 */
	@:glsl public function circleCheck(v2:Vec2, len:Float):Float {
		var setpX:Float = 1 / gl_openfl_TextureSize.x * len;
		var setpY:Float = 1 / gl_openfl_TextureSize.y * len;
		var checkTimes = 36.;
		var setp:Float = 6.28 / checkTimes;
		var allAlpha:Float = 0.;
		for (i in 0...36) {
			var r:Float = setp * float(i);
			var alpha:Float = getAlpha(v2, setpX * sin(r), setpY * cos(r));
			allAlpha += alpha;
		}
		return clamp(allAlpha / (checkTimes * 0.5) * 2, 0., 1.);
	}

	override function fragment() {
		super.fragment();
		// 渐变色支持
		if (availableColor) {
			color = mix(startcolor, endcolor, gl_openfl_TextureCoordv.y) * color.a;
		}
		for (i in 0...6) {
			if (float(i) > (storksize))
				break;
			var alpha:Float = circleCheck(gl_openfl_TextureCoordv, float(i));
			if (alpha > 0.) {
				gl_FragColor = storkcolor * alpha;
				if (color.a > 0.) {
					gl_FragColor = vec4(color.rgb, 1);
				}
			}
		}
		gl_FragColor *= gl_openfl_Alphav;
	}

	public function new(size:Float = 1.5, color:UInt = 0x0, scolor:UInt = 0, ecolor:UInt = 0) {
		super();
		// 初始化渐变色
		u_startcolor.value = [0, 0, 0, 1];
		u_endcolor.value = [0, 0, 0, 1];
		u_availableColor.value = [false];
		updateParam(size, color);
		updateMixColor(scolor, ecolor);
	}

	public function updateParam(size:Float, color:UInt):Void {
		u_storksize.value = [size > 0 ? size + 1 : size];
		var scolor = ColorUtils.toShaderColor(color);
		u_storkcolor.value = [scolor.r, scolor.g, scolor.b, 1];
		u_availableColor.value = [false];
	}

	public function updateMixColor(start:Float, end:Float):Void {
		var scolor = ColorUtils.toShaderColor(start);
		var ecolor = ColorUtils.toShaderColor(end);
		u_startcolor.value = [scolor.r, scolor.g, scolor.b, 1];
		u_endcolor.value = [ecolor.r, ecolor.g, ecolor.b, 1];
		u_availableColor.value = [start != end];
	}
}
