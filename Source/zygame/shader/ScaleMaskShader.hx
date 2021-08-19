package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 *             //计算纹理的映射，公式：（当前图片宽度 * 当前纹理坐标 - 当前图片精灵偏移X） / 当前图片精灵宽度 
 */
class ScaleMaskShader extends DisplayObjectShader {
    
    @:glFragmentSource("
		
		#pragma header

        uniform vec3 scale;

		void main(void) {
			#pragma body
            float value = (openfl_TextureSize.x * openfl_TextureCoordv.x - scale.g) / scale.b;
			if(value > scale.r)
                gl_FragColor.rgba *= 0.;
		}
		
	")
	public function new(scaleX:Float,offectX:Float,imgWidth:Float) {
		super();
		this.scale.value = [scaleX,offectX,imgWidth];
	}

    public function setScaleX(scaleX:Float):Void
    {
        this.scale.value[0] = scaleX;
	}
	
	public function getScaleX():Float{
		return this.scale.value[0];
	}

	public var scaleX(get,set):Float;
	private function get_scaleX():Float{
		return getScaleX();
	}
	private function set_scaleX(value:Float):Float{
		setScaleX(value);
		return value;
	}

}