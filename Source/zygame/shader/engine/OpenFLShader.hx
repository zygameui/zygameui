package zygame.shader.engine;

import haxe.macro.Expr.Field;

@:autoBuild(zygame.macro.OpenFLShaderMacro.buildShader())
class OpenFLShader {
	/** 
	 * 纹理UV
	 */
	public var openfl_TextureCoordv:Vec2;

	/**
	 * 纹理尺寸
	 */
	public var openfl_TextureSize:Vec2;

	public var gl_FragColor:Vec4;

	public var color:Vec4;

	public function floor(f:Float):Dynamic{
		return f;
	};

	public function new() {}
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
