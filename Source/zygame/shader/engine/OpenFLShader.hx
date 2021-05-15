package zygame.shader.engine;

import zygame.core.Start;
import openfl.display.DisplayObjectShader;
import haxe.macro.Expr.Field;

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
	 * 返回小于等于x的最大整数值
	 * @param f 
	 * @return Dynamic
	 */
	public function floor(f:Dynamic):Dynamic {
		return f;
	};

	public function mod(a:Dynamic, b:Dynamic):Dynamic {
		return a;
	}

	public function float(a:Dynamic):Dynamic {
		return a;
	}

	public function int(a:Dynamic):Dynamic {
		return a;
	}

	public function cos(a:Dynamic):Dynamic {
		return a;
	}

	public function sin(a:Dynamic):Dynamic {
		return a;
	}

	public function length(a:Dynamic):Dynamic {
		return a;
	}

	public function pow(a:Dynamic, a:Dynamic):Dynamic {
		return a;
	}

	/**
	 * 获得三个参数中大小处在中间的那个值，如果minVal > minMax的话，函数返回的结果是未定的。也就是说x的值大小没有限制，但是minval的值必须比maxVal小
	 * @param a 
	 * @param b 
	 * @param c 
	 * @return Dynamic
	 */
	public function clamp(a:Dynamic, b:Dynamic, c:Dynamic):Dynamic {
		return a;
	}

	public function abs(a:Dynamic):Dynamic {
		return a;
	}

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
