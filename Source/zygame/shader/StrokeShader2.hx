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
	 * 加粗的大小
	 */
	@:uniform public var boldsize:Float;

	/**
	 * 描边的颜色
	 */
	@:uniform public var storkcolor:Vec4;

	/**
	 * 字体原本的颜色
	 */
	@:uniform public var textcolor:Vec4;

	/**
	 * 字体开始的颜色（顶部）
	 */
	@:uniform public var startcolor:Vec4;

	/**
	 * 字体结束的颜色（底部）
	 */
	@:uniform public var endcolor:Vec4;

	/**
	 * 每个点都做一次圆检测
	 * @param v2 
	 * @return Bool
	 */
	@:glsl public function circleBlodCheck(v2:Vec2, len:Float):Float {
		var setpX:Float = 1 / gl_openfl_TextureSize.x * len;
		var setpY:Float = 1 / gl_openfl_TextureSize.y * len;
		var checkTimes = 36.;
		var setp:Float = 6.28 / checkTimes;
		var allAlpha:Float = 0.;
		for (i in 0...36) {
			var r:Float = setp * float(i);
			var checkPos:Vec2 = v2 + vec2(setpX * sin(r), setpY * cos(r));
			var color:Vec4 = texture2D(gl_openfl_Texture, checkPos);
			var alpha:Float = color.a;
			allAlpha += alpha;
		}
		return clamp(allAlpha / (checkTimes * 0.5) * 2, 0., 1.);
	}

	/**
	 * 检测当前这个点的偏移位置是否包含透明度
	 * @param v2 
	 * @param offestX 
	 * @param offestY 
	 * @return Bool
	 */
	@:glsl public function getAlpha(v2:Vec2, offestX:Float, offestY:Float):Float {
		var checkPos:Vec2 = v2 + vec2(offestX, offestY);
		var color:Vec4 = texture2D(gl_openfl_Texture, checkPos);
		// 加粗支持
		for (i in 0...6) {
			if (float(i) > (boldsize))
				break;
			var alpha:Float = circleBlodCheck(checkPos, float(i));
			if (alpha > 0.) {
				color = textcolor * alpha;
				if (color.a > 0.) {
					color = vec4(color.rgb, 1);
				}
			}
		}
		return color.a;
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
		// 加粗支持
		for (i in 0...6) {
			if (float(i) > (boldsize))
				break;
			var alpha:Float = circleCheck(gl_openfl_TextureCoordv, float(i));
			if (alpha > 0.) {
				color = textcolor * alpha;
				if (color.a > 0.) {
					color = vec4(color.rgb, 1);
				}
			}
		}
		// 渐变色支持
		color = mix(startcolor, endcolor, gl_openfl_TextureCoordv.y) * color.a;
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
		u_boldsize.value = [0];
		updateParam(size, color, 0, 0);
		updateMixColor(scolor, ecolor);
	}

	public function updateParam(size:Float, blod:Float, color:UInt, textcolor:UInt):Void {
		u_storksize.value = [size > 0 ? size + 1 : -1];
		u_boldsize.value = [blod > 0 ? blod : -1];
		var scolor = ColorUtils.toShaderColor(color);
		var tcolor = ColorUtils.toShaderColor(textcolor);
		u_textcolor.value = [tcolor.r, tcolor.g, tcolor.b, 1];
		u_storkcolor.value = [scolor.r, scolor.g, scolor.b, 1];
	}

	public function updateMixColor(start:Float, end:Float):Void {
		var scolor = ColorUtils.toShaderColor(start);
		var ecolor = ColorUtils.toShaderColor(end);
		u_startcolor.value = [scolor.r, scolor.g, scolor.b, 1];
		u_endcolor.value = [ecolor.r, ecolor.g, ecolor.b, 1];
	}
}
