package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 图层透明着色器
 */
class ColorShader extends DisplayObjectShader {

    @:glFragmentSource("
		
		#pragma header

        uniform vec3 mcolorvalue;
				
		void main(void) {
			
			#pragma body
			
			gl_FragColor.rgb = mcolorvalue * color.a;
			gl_FragColor.a = color.a;
			gl_FragColor *= openfl_Alphav;
		}
		
	")
    public function new(color:UInt = 1){
        super();
		updateColor(color);
    }

	public function updateColor(color:UInt):Void
	{
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
        this.mcolorvalue.value = [r/255,g/255,b/255];
	}

}