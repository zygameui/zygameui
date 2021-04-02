package zygame.shader.engine;

import haxe.Exception;
import zygame.utils.load.Frame;
import zygame.core.Start;
import zygame.script.ZHaxe;
import openfl.display.DisplayObjectShader;

/**
 * 可读取XML配置的着色器
 */
class ZShader extends DisplayObjectShader implements zygame.core.Refresher {
	private static var defalutGLFragmentSourceBody = "vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

		if (color.a == 0.0) {

			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

		} else if (openfl_HasColorTransform) {

			color = vec4 (color.rgb / color.a, color.a);

			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			if (color.a > 0.0) {

				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);

			} else {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			}

		} else {

			gl_FragColor = color * openfl_Alphav;

		}";

	private static var defalutGLFragmentSourceHeader = "varying float openfl_Alphav;
        varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
 		varying vec2 openfl_TextureCoordv;

 		uniform bool openfl_HasColorTransform;
        uniform sampler2D openfl_Texture;
        uniform vec2 openfl_TextureSize;
        
        uniform vec2 frameOffest;
        uniform vec2 frameSize;
        vec2 getFrameCoordv(){
            return vec2(
                (openfl_TextureSize.x * openfl_TextureCoordv.x - frameOffest.x) / frameSize.x,
                (openfl_TextureSize.y * openfl_TextureCoordv.y - frameOffest.y) / frameSize.y
            );
        }";

	private static var defalutGLVertexHeader:String = "attribute float openfl_Alpha;
    attribute vec4 openfl_ColorMultiplier;
    attribute vec4 openfl_ColorOffset;
    attribute vec4 openfl_Position;
    attribute vec2 openfl_TextureCoord;

    varying float openfl_Alphav;
    varying vec4 openfl_ColorMultiplierv;
    varying vec4 openfl_ColorOffsetv;
    varying vec2 openfl_TextureCoordv;

    uniform mat4 openfl_Matrix;
    uniform bool openfl_HasColorTransform;
    uniform vec2 openfl_TextureSize;";

	private static var defalutGLVertexBody:String = "openfl_Alphav = openfl_Alpha;
    openfl_TextureCoordv = openfl_TextureCoord;

    if (openfl_HasColorTransform) {

        openfl_ColorMultiplierv = openfl_ColorMultiplier;
        openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

    }

    gl_Position = openfl_Matrix * openfl_Position;";

	public var haxeScript:ZHaxe;

	/**
	 * 动态GLSL实现
	 * @param glVertexSource 
	 * @param glFragmentSource 
	 */
	public function new(xml:Xml) {
		var glVertexSource:String = null;
		var glFragmentSource:String = null;
		var xmls = xml.elements();
		for (item in xmls) {
			switch (item.nodeName) {
				case "glVertexSource":
					glVertexSource = item.firstChild().nodeValue;
				case "glFragmentSource":
					glFragmentSource = item.firstChild().nodeValue;
				case "update":
					haxeScript = new ZHaxe(item.firstChild().nodeValue);
					#if hscript
					haxeScript.interp.variables.set("this", this);
					#end
					Start.current.addToUpdate(this);
			}
		}
		if (glVertexSource != null) {
			glVertexSource = StringTools.replace(glVertexSource, "#header", defalutGLVertexHeader);
			glVertexSource = StringTools.replace(glVertexSource, "#body", defalutGLVertexBody);
			glVertexSource = StringTools.replace(glVertexSource, "#pragma header", defalutGLVertexHeader);
			glVertexSource = StringTools.replace(glVertexSource, "#pragma body", defalutGLVertexBody);
			this.glVertexSource = glVertexSource;
		}
		if (glFragmentSource != null) {
			glFragmentSource = StringTools.replace(glFragmentSource, "#header", defalutGLFragmentSourceHeader);
			glFragmentSource = StringTools.replace(glFragmentSource, "#body", defalutGLFragmentSourceBody);
			glFragmentSource = StringTools.replace(glFragmentSource, "#pragma header", defalutGLFragmentSourceHeader);
			glFragmentSource = StringTools.replace(glFragmentSource, "#pragma body", defalutGLFragmentSourceBody);
			this.glFragmentSource = glFragmentSource;
		}
		super();
	}

	/**
	 * 设置uniform值
	 * @param key 
	 * @param data 
	 */
	public function setValue(key:String, data:Dynamic):Void {
		var value:Dynamic = Reflect.getProperty(this, key);
		if (value == null) {
			trace("key '" + key + "' is null");
			return;
		}
		value.value = Std.is(data, Array) ? data : [data];
	}

	/**
	 * 获取uniform值
	 * @param key 
	 * @return Array<Dynamic>
	 */
	public function getValue(key:String):Array<Dynamic> {
		return Reflect.getProperty(this, key).value;
	}

	public function onFrame():Void {
		if (haxeScript != null)
			haxeScript.call();
	}

	public function dipose():Void {
		Start.current.removeToUpdate(this);
	}

	public function updateFrame(frame:Frame):Void {
		#if cpp
		return;
		#end
		if (frame == null)
			return;
		setValue("frameOffest", [frame.x, frame.y]);
		setValue("frameSize", [frame.width, frame.height]);
	}

	override private function __updateGL():Void {
		try {
			super.__updateGL();
		} catch (e:Exception) {
			trace("Shader.__updateGL:" + e.message);
		}
	}

	override private function __init():Void {
		try {
			super.__init();
		} catch (e:Exception) {
			this.dipose();
			trace("Shader.__init:" + e.message);
		}
	}

	override private function __enable():Void {
		try {
			super.__enable();
		} catch (e:Exception) {
			trace("Shader.__enable:" + e.message);
		}
	}
}
