package zygame.shader.particle;

import glsl.OpenFLGraphicsShader;
import zygame.core.Start;
import openfl.display.Stage;
import glsl.GLSL;
import VectorMath;

/**
 * GPU粒子系统着色器
 */
class GPUParticleShader extends OpenFLGraphicsShader {
	/**
	 * 初始化坐标
	 */
	@:attribute public var pos:Vec2;

	/**
	 * 随机值
	 */
	@:attribute public var random:Float;

	/**
	 * 向量方向
	 */
	@:attribute public var velocity:Vec2;

	/**
	 * 加速力
	 */
	@:attribute public var acceleration:Vec2;

	/**
	 * 粒子时长，秒
	 */
	@:attribute public var life:Float;

	/**
	 * 当前运行时
	 */
	@:uniform public var time:Float;

	/**
	 * 舞台尺寸
	 */
	@:uniform public var stageSize:Vec2;

	/**
	 * 是否循环
	 */
	@:uniform public var loop:Float;

	/**
	 * 是否循环播放
	 */
	// @:uniform

	/**
	 * 剩余的生命周期
	 */
	@:varying public var outlife:Float;

	/**
	 * 生命可见度
	 */
	@:varying public var lifeAlpha:Float;

	public function new() {
		super();
		u_time.value = [0];
		a_random.value = [];
		a_acceleration.value = [];
		a_velocity.value = [];
		u_loop.value = [1];
		u_stageSize.value = [Start.current.getStageWidth(), Start.current.getStageHeight()];
		this.setFrameEvent(true);
	}

	/**
	 * 旋转实现
	 * @return Mat4
	 */
	@:vertexglsl public function rotaion(degrees:Float, axis:Vec3, ts:Vec3):Mat4 {
		var tx:Float = ts.x;
		var ty:Float = ts.y;
		var tz:Float = ts.z;

		var radian:Float = degrees * 3.14 / 180;
		var c:Float = cos(radian);
		var s:Float = sin(radian);
		var x:Float = axis.x;
		var y:Float = axis.y;
		var z:Float = axis.z;
		var x2:Float = x * x;
		var y2:Float = y * y;
		var z2:Float = z * z;
		var ls:Float = x2 + y2 + z2;
		if (ls != 0) {
			var l:Float = sqrt(ls);
			x /= l;
			y /= l;
			z /= l;
			x2 /= ls;
			y2 /= ls;
			z2 /= ls;
		}
		var ccos:Float = 1 - c;
		var d:Mat4 = gl_openfl_Matrix;
		d[0].x = x2 + (y2 + z2) * c;
		d[0].y = x * y * ccos + z * s;
		d[0].z = x * z * ccos - y * s;
		d[1].x = x * y * ccos - z * s;
		d[1].y = y2 + (x2 + z2) * c;
		d[1].z = y * z * ccos + x * s;
		d[2].x = x * z * ccos + y * s;
		d[2].y = y * z * ccos - x * s;
		d[2].z = z2 + (x2 + y2) * c;
		d[3].x = (tx * (y2 + z2) - x * (ty * y + tz * z)) * ccos + (ty * z - tz * y) * s;
		d[3].y = (ty * (x2 + z2) - y * (tx * x + tz * z)) * ccos + (tz * x - tx * z) * s;
		d[3].z = (tz * (x2 + y2) - z * (tx * x + ty * y)) * ccos + (tx * y - ty * x) * s;
		return d;
	}

	/**
	 * 比例缩放
	 * @param scaleX 
	 * @param scaleY 
	 */
	@:vertexglsl public function scale(xScale:Float, yScale:Float):Mat4 {
		return mat4(xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 1.0);
	}

	/**
	 * 平移
	 * @param x 
	 * @param y 
	 */
	@:vertexglsl public function translation(x:Float, y:Float):Mat4 {
		return mat4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, x, y, 0, 0);
	}

	override function vertex() {
		super.vertex();

		// 生命
		var nowtime:Float = time - life * random;
		var aliveTime:Float = mod(nowtime, life);
		aliveTime = aliveTime * step(0, nowtime);

		// 剩余的生命周期
		this.outlife = (life - aliveTime) / life;

		lifeAlpha = 1;

		// 非循环
		if (loop == 0 && nowtime >= life || nowtime < 0) {
			lifeAlpha = 0;
		}

		// 角度
		var d:Mat4 = rotaion(0, vec3(0, 0, 1), vec3(gl_openfl_TextureSize.x * 0.5, gl_openfl_TextureSize.y * 0.5, 0));

		// 缩放
		var sx:Float = 1. * outlife;
		var sy:Float = 1. * outlife;
		var s:Mat4 = scale(sx, sy);
		// 平移
		var smove:Vec2 = vec2((sx - 1.) * 0.25 * 0.25 * gl_openfl_TextureSize.x, (sy - 1.) * 0.25 * 0.25 * gl_openfl_TextureSize.y);

		// UV位移
		var uv:Vec2 = 2. / stageSize.xy;

		// 坐标实现
		var positionNew:Vec2 = pos + velocity * aliveTime + acceleration * aliveTime * aliveTime * 0.5;

		// 最终位移
		var t:Mat4 = translation(-uv.x * (gl_openfl_TextureSize.x * 0.5 + smove.x - positionNew.x),
			uv.y * (gl_openfl_TextureSize.y * 0.5 + smove.y - positionNew.y));
		// 位移
		this.gl_Position = (gl_openfl_Matrix + t) * d * s * gl_openfl_Position;
	}

	override function fragment() {
		super.fragment();
		// color.a = 0.;
		color.rgba *= outlife;
		// color.rgb *= vec3(1,0.1,0.1);
		this.gl_FragColor = color * lifeAlpha;
	}

	override function onFrame() {
		super.onFrame();
		u_stageSize.value = [Start.current.getStageWidth(), Start.current.getStageHeight()];
	}
}
