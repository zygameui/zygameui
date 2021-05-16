package zygame.shader.engine;

import zygame.core.Start;
import openfl.display.DisplayObjectShader;
import haxe.macro.Expr.Field;

function float(a:Dynamic):Float {
	return a;
}

function int(a:Dynamic):Int {
	return a;
}

/**
 * 获取Texture2D颜色
 * @param texture 纹理对象
 * @param vec2 UV位置
 * @return Vec4
 */
function texture2D(texture:Dynamic, vec2:Vec2):Vec4 {
	return null;
}

@:autoBuild(zygame.macro.OpenFLShaderMacro.buildShader())
class OpenFLShader extends DisplayObjectShader implements zygame.core.Refresher {
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

	public function setFrameEvent(bool:Bool):Void {
		if (bool)
			Start.current.addToUpdate(this);
		else
			Start.current.removeToUpdate(this);
	}

	/**
	 * 释放当前着色器
	 */
	public function dispose():Void {
		Start.current.removeToUpdate(this);
	}

	public function onFrame():Void {}
}
