package zygame.shader;

import zygame.utils.load.Frame;
import glsl.GLSL;
import VectorMath;
import glsl.OpenFLShader;

/**
 * 九宫格渲染着色器
 */
class Slice9Shader extends OpenFLShader {
	/**
	 * 精灵图的尺寸
	 */
	@:uniform public var frameSpriteRect:Vec4;

	/**
	 * 九宫格数据
	 */
	@:uniform public var s9d:Vec4;

	/**
	 * 显示对象尺寸
	 */
	@:uniform public var size:Vec4;

	/**
	 * 获取精灵图的Uv值
	 * @return Vec2
	 */
	@:glsl public function getFrameCoodv():Vec2 {
		return vec2(fract((gl_openfl_TextureSize.x * gl_openfl_TextureCoordv.x - frameSpriteRect.x) / frameSpriteRect.z),
			fract((gl_openfl_TextureSize.y * gl_openfl_TextureCoordv.y - frameSpriteRect.y) / frameSpriteRect.w));
	}

	/**
	 * 获取指定位置的UV图
	 * @param x 
	 * @param y 
	 * @return Vec2
	 */
	@:glsl public function getUv(x:Float, y:Float):Vec2 {
		if (size.z == 1) {
			return vec2(frameSpriteRect.x + x, frameSpriteRect.y + y) / gl_openfl_TextureSize;
		}
		return vec2(x / gl_openfl_TextureSize.x, y / gl_openfl_TextureSize.y);
	}

	@:glsl public function texture2Dgery(u:Vec2):Vec4 {
		var color:Vec4 = texture2D(gl_openfl_Texture, u);
		var colorAdd:Float = (color.r + color.b + color.g) / 3.;
		// 灰度实现
		color.r = step(size.w, 0.5) * color.r + colorAdd * step(0.5, size.w);
		color.g = step(size.w, 0.5) * color.g + colorAdd * step(0.5, size.w);
		color.b = step(size.w, 0.5) * color.b + colorAdd * step(0.5, size.w);
		return color;
	}

	#if vivo
	override function fragment() {
		super.fragment();
		var uv:Vec2 = size.z == 1 ? getFrameCoodv() * size.xy : gl_openfl_TextureCoordv * size.xy;
		var centerWidth:Float = size.x - s9d.x - s9d.y; // 中间宽度
		var centerHeight:Float = size.y - s9d.z - s9d.w; // 中间高度
		var centerSliceWidth:Float = (size.z == 1 ? frameSpriteRect.z : gl_openfl_TextureSize.x) - s9d.x - s9d.y; // 中间原图宽度
		var centerSliceHeight:Float = (size.z == 1 ? frameSpriteRect.w : gl_openfl_TextureSize.y) - s9d.z - s9d.w; // 中间原图高度
		color = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
		if (color.a == 0) {
			gl_FragColor *= 0.;
		} else {
			gl_FragColor.rgba = color.rgba;
		}
		if (uv.x <= s9d.x && uv.y <= s9d.z) {
			// 左上(ok)
			color = texture2Dgery(getUv(uv.x, uv.y));
			gl_FragColor = color;
		} else if (uv.x >= size.x - s9d.y && uv.y <= s9d.z) {
			// 右上(ok)
			color = texture2Dgery(getUv(s9d.x + centerSliceWidth + uv.x - (size.x - s9d.y), uv.y));
			gl_FragColor = color;
		} else if (uv.x <= s9d.x && uv.y >= size.y - s9d.w) {
			// 左下
			color = texture2Dgery(getUv(uv.x, centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
			gl_FragColor = color;
		} else if (uv.x >= size.x - s9d.y && uv.y >= size.y - s9d.w) {
			// 右下
			color = texture2Dgery(getUv(s9d.x + centerSliceWidth + uv.x - (size.x - s9d.y), centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
			gl_FragColor = color;
		} else if (uv.y <= s9d.z) {
			// 上
			color = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, uv.y));
			gl_FragColor = color;
		} else if (uv.x <= s9d.x) {
			// 左(ok)
			color = texture2Dgery(getUv(uv.x, s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
			gl_FragColor = color;
		} else if (uv.y >= size.y - s9d.w) {
			// 下
			color = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
			gl_FragColor = color;
		} else if (uv.y >= size.y - s9d.w) {
			// 下
			color = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
			gl_FragColor = color;
		} else if (uv.x >= size.x - s9d.y) {
			// 右(ok)
			color = texture2Dgery(getUv(centerSliceWidth + s9d.x + uv.x - (size.x - s9d.y), s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
			gl_FragColor = color;
		}
		gl_FragColor *= gl_openfl_Alphav;
		if (size.w == 1) {
			gl_FragColor = vec4(vec3((gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3), gl_FragColor.a);
		}
	}
	#else
	override function fragment() {
		super.fragment();
		var uv:Vec2 = size.z == 1 ? getFrameCoodv() * size.xy : gl_openfl_TextureCoordv * size.xy;
		var centerWidth:Float = size.x - s9d.x - s9d.y; // 中间宽度
		var centerHeight:Float = size.y - s9d.z - s9d.w; // 中间高度
		var centerSliceWidth:Float = (size.z == 1 ? frameSpriteRect.z : gl_openfl_TextureSize.x) - s9d.x - s9d.y; // 中间原图宽度
		var centerSliceHeight:Float = (size.z == 1 ? frameSpriteRect.w : gl_openfl_TextureSize.y) - s9d.z - s9d.w; // 中间原图高度
		var color2:Vec4 = vec4(0);
		if (uv.x <= s9d.x && uv.y <= s9d.z) {
			// 左上(ok)
			color2 = texture2Dgery(getUv(uv.x, uv.y));
		} else if (uv.x >= size.x - s9d.y && uv.y <= s9d.z) {
			// 右上(ok)
			color2 = texture2Dgery(getUv(s9d.x + centerSliceWidth + uv.x - (size.x - s9d.y), uv.y));
		} else if (uv.x <= s9d.x && uv.y >= size.y - s9d.w) {
			// 左下
			color2 = texture2Dgery(getUv(uv.x, centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
		} else if (uv.x >= size.x - s9d.y && uv.y >= size.y - s9d.w) {
			// 右下
			color2 = texture2Dgery(getUv(s9d.x + centerSliceWidth + uv.x - (size.x - s9d.y), centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
		} else if (uv.y <= s9d.z) {
			// 上
			color2 = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, uv.y));
		} else if (uv.y >= size.y - s9d.w) {
			// 下
			color2 = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, centerSliceHeight + s9d.z + uv.y - (size.y - s9d.w)));
		} else if (uv.x <= s9d.x) {
			// 左(ok)
			color2 = texture2Dgery(getUv(uv.x, s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
		} else if (uv.x >= size.x - s9d.y) {
			// 右(ok)
			color2 = texture2Dgery(getUv(centerSliceWidth + s9d.x + uv.x - (size.x - s9d.y), s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
		} else {
			// 中间
			color2 = texture2Dgery(getUv(s9d.x + (uv.x - s9d.x) / centerWidth * centerSliceWidth, s9d.z + (uv.y - s9d.z) / centerHeight * centerSliceHeight));
		}
		// if (size.w == 1) {
		// color2 = vec4(vec3((color2.r + color2.g + color2.b) / 3), gl_FragColor.a);
		// }
		gl_FragColor = color2 * gl_openfl_Alphav;
	}
	#end

	/**
		* Bate 测试内容
		* override function fragment() {
			super.fragment();
			var uv:Vec2 = size.z == 1 ? getFrameCoodv() * size.xy : gl_openfl_TextureCoordv * size.xy;
			var centerWidth:Float = size.x - s9d.x - s9d.y; // 中间宽度
			var centerHeight:Float = size.y - s9d.z - s9d.w; // 中间高度
			var centerSliceWidth:Float = (size.z == 1 ? frameSpriteRect.z : gl_openfl_TextureSize.x) - s9d.x - s9d.y; // 中间原图宽度
			var centerSliceHeight:Float = (size.z == 1 ? frameSpriteRect.w : gl_openfl_TextureSize.y) - s9d.z - s9d.w; // 中间原图高度
			var color2:Vec4 = vec4(0);

			var uvx:Float = uv.x;
			var uvy:Float = uv.y;
			var s9dx:Float = s9d.x;
			var s9dy:Float = s9d.y;
			var s9dz:Float = s9d.z;
			var s9dw:Float = s9d.w;
			var sizex:Float = size.x;
			var sizey:Float = size.y;

			// 左上
			// if (uv.x <= s9d.x && uv.y <= s9d.z) {
			var if1:Float = step(uvx, s9dx);
			var if2:Float = step(uvy, s9dy);
			color2 += texture2Dgery( getUv(uvx, uvy)) * if1 * if2;
			// 右上
			// } else if (uv.x >= size.x - s9d.y && uv.y <= s9d.z) {
			var if3:Float = step(sizex - s9dy, uvx);
			var if4:Float = step(uvy, s9dz);
			color2 += if3 * if4 * texture2Dgery( getUv(s9dx + centerSliceWidth + uvx - (sizex - s9dy), uvy));
			// 左下
			var if5:Float = step(uvx, s9dx);
			var if6:Float = step(sizey - s9dw, uvy);
			color2 += if5 * if6 * texture2Dgery( getUv(uvx, centerSliceHeight + s9dz + uvy - (sizey - s9dw)));
			// 右下
			var if7:Float = step(sizex - s9dy, uvx);
			var if8:Float = step(sizey - s9dw, uvy);
			color2 += if7 * if8 * texture2Dgery(
				getUv(s9dx + centerSliceWidth + uvx - (sizex - s9dy), centerSliceHeight + s9dz + uvy - (sizey - s9dw)));
			// 上
			var if9:Float = step(uvy , s9dz);
			color2 += if9 * texture2Dgery( getUv(s9dx + (uvx - s9dx) / centerWidth * centerSliceWidth, uvy));
			// 下
			var if10:Float = step(sizey - s9dw, uvy);
			color2 += if10 * texture2Dgery(
				getUv(s9d.x + (uvx - s9dx) / centerWidth * centerSliceWidth, centerSliceHeight + s9dz + uvy - (sizey - s9dw)));
			// 左
			var if11:Float = step(uvx, s9dx);
			color2 += if11 * texture2Dgery( getUv(uvx, s9dz + (uvy - s9dz) / centerHeight * centerSliceHeight));
			// 右
			var if12:Float = step(sizex - s9dy, uvx);
			color2 += if12
				+ texture2Dgery(
					getUv(centerSliceWidth + s9dx + uvx - (sizex - s9dy), s9dz + (uvy - s9dz) / centerHeight * centerSliceHeight));

			if (color.rgb == vec3(0, 0, 0)) {
				// 中间
				color2 = texture2Dgery(
					getUv(s9dx + (uvx - s9dx) / centerWidth * centerSliceWidth, s9dz + (uvy - s9dz) / centerHeight * centerSliceHeight));
			}

			if (size.w == 1) {
				var rgb:Float = (color2.r + color2.g + color2.b) / 3.;
				color2 = vec4(rgb, rgb, rgb, gl_FragColor.a);
			}
			gl_FragColor = color2 * gl_openfl_Alphav;
		}
		#end
	 */
	/**
	 * @param left 左间距
	 * @param top 上间距
	 * @param right 右间距
	 * @param bottom 下间距
	 */
	public function new(left:Float, top:Float, bottom:Float, right:Float, width:Float, height:Float) {
		super();
		// left/right/top/bottom
		u_s9d.value = [left, right, top, bottom];
		u_size.value = [width, height, 0, 0];
	}

	public function updateFrame(frame:Frame):Void {
		u_frameSpriteRect.value = [frame.x, frame.y, frame.width, frame.height];
	}

	public function updateArgs(left:Float, top:Float, bottom:Float, right:Float) {
		u_s9d.value = [left, right, top, bottom];
	}

	public function updateSize(width:Float, height:Float) {
		u_size.value[0] = width;
		u_size.value[1] = height;
	}
}
