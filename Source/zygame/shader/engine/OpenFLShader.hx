package zygame.shader.engine;

import openfl.display.DisplayObjectShader;
import haxe.macro.Expr.Field;

@:autoBuild(zygame.macro.OpenFLShaderMacro.buildShader())
class OpenFLShader extends DisplayObjectShader {
	/** 
	 * 纹理UV
	 */
	public var gl_openfl_TextureCoordv:Vec2;

	/**
	 * 纹理尺寸
	 */
	public var gl_openfl_TextureSize:Vec2;

	/**
	 * 纹理对象
	 */
	public var gl_openfl_Texture:Dynamic;

	/**
	 * 当前纹理透明度
	 */
	public var gl_openfl_Alphav:Float;

	public var gl_FragColor:Vec4;

	public var color:Vec4;

	public function asVec2(data:Dynamic):Vec2 {
		return data;
	}

	public function asVec3(data:Dynamic):Vec3 {
		return data;
	}

	public function asVec4(data:Dynamic):Vec4 {
		return data;
	}

	public function floor(f:Float):Dynamic {
		return f;
	};

	public function texture2D(texture:Dynamic, vec2:Float):Vec4 {
		return null;
	}

	public function fragment():Void {}

	public function vertex():Void {}

	public function new() {
		super();
	}
}