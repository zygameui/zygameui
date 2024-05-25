package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 图层透明着色器
 */
class TextColorShader extends DisplayObjectShader {

    @:glFragmentSource("
		
		#pragma header

        uniform vec3 mcolorvalue;
        uniform vec3 msoureColor;
				
		void main(void) {
			
			#pragma body
			
			float a = gl_FragColor.a;
			if(distance(gl_FragColor.rgb, msoureColor.rgb * a) < 0.01)
                gl_FragColor.rgb = mcolorvalue;
			gl_FragColor *= a * openfl_Alphav;
		}
		
	")
    public function new(color:UInt = 1,soureColor:UInt = 1){
        super();
		updateColor(color);
		var r = (soureColor >> 16) & 0xFF;
		var g = (soureColor >> 8) & 0xFF;
		var b = soureColor & 0xFF;
		this.msoureColor.value = [r/255,g/255,b/255];
    }

	public function updateColor(color:UInt):Void
	{
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
        this.mcolorvalue.value = [r/255,g/255,b/255];
	}

}