package zygame.shader;

import glsl.OpenFLShader;
import VectorMath;

/**
 * 流光效果渲染
 */
@:debug
class FluxaySuperShader extends OpenFLShader {
	@:uniform public var speed:Float;

	@:precision("highp float")
	@:define("TAU 6.12")
	@:define("MAX_ITER 5")
	override function fragment() {
		super.fragment();
		var time:Float = speed * 0.5 + 5;
		// uv should be the 0-1 uv of texture...
		var uv:Vec2 = gl_openfl_TextureCoordv.xy;
		var p:Vec2 = mod(uv * TAU, TAU) - 250.0;
		var i:Vec2 = vec2(p);
		var c = 1.;
		var inten = .0045;
		for (n in 0...MAX_ITER) {
			var t:Float = time * (1 - (3.5 / float(n + int(1))));
			i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(1.5 * t + i.x));
			c += 1.0 / length(vec2(p.x / (cos(i.x + t) / inten), p.y / (cos(i.y + t) / inten)));
		}
		c /= float(MAX_ITER);
		c = 1.17 - pow(c, 1.4);
		var tex:Vec4 = texture2D(openfl_Texture, uv);
		var colour:Vec3 = vec3(pow(abs(c), 20.0));
		colour = clamp(colour + vec3(0.0, 0.0, .0), 0.0, tex.a);
		// 混合波光
		var alpha:Float = c * tex[3];
		tex[0] = tex[0] + colour[0] * alpha;
		tex[1] = tex[1] + colour[1] * alpha;
		tex[2] = tex[2] + colour[2] * alpha;
		gl_FragColor = tex + color * tex;
	}

	public function new(speed:Float = 1) {
		super();
		this.setFrameEvent(true);
		this.speed = speed;
	}

	override function onFrame() {
		super.onFrame();
		if (this.u_speed.value == null) {
			this.u_speed.value = [0];
		}
		this.u_speed.value[0] += 1 / 60 * speed;
	}
}
