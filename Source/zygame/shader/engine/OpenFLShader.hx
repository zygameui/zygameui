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

	/**
	 * 最终值输出
	 */
	public var gl_FragColor:Vec4;

	/**
	 * 当前着色器获得到的颜色
	 */
	public var color:Vec4;

	/**
	 * 返回小于等于x的最大整数值
	 * @param f 
	 * @return Dynamic
	 */
	public function floor(f:Dynamic):Dynamic {
		return f;
	};


	/**
	 * 获取Texture2D颜色
	 * @param texture 纹理对象
	 * @param vec2 UV位置
	 * @return Vec4
	 */
	public function texture2D(texture:Dynamic, vec2:Float):Vec4 {
		return null;
	}

	/**
	 * 片段着色器，需要时，请重写这个
	 */
	public function fragment():Void {}

	/**
	 * 顶点着色器，需要时，请重写这个
	 */
	public function vertex():Void {}

	public function new() {
		super();
	}
}
