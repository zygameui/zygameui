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

	public var gl_FragColor:Vec4;

	public var color:Vec4;

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

extern class Vec4 {
	public var r:Float;
	public var b:Float;
	public var g:Float;
	public var a:Float;
	public var rgba:Float;
	public var rgb:Float;
	public var rga:Float;
	public var rba:Float;
	public function new(r:Float, g:Float, b:Float, a:Float);
}

extern class Vec2 {
	public var x:Float;
	public var y:Float;
	public var xy:Float;
	public function new(x:Float, y:Float);
}
