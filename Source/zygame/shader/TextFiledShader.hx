package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 灰度着色器
 */
class TextFiledShader extends DisplayObjectShader {

    @:glFragmentSource("
		
		#pragma header
			
		void main(void) {
			
			#pragma body
			// float mColor = 0.0;
			// mColor += gl_FragColor.r + gl_FragColor.g + gl_FragColor.b;
			// mColor = mColor/3.0;
            // if(mColor > 0)
            // {
            //     gl_FragColor.a = 1;
            // }
            // if((color.r + color.g + color.b)/3. > 0.2)
            // {
            //     color.r *= 1.2;
            //     color.g *= 1.2;
            //     color.b *= 1.2;
            // }
            // gl_FragColor = vec4 (color.rgb * openfl_Alphav,color.a * openfl_Alphav);
            if(color.a < 0.8)
                color.a = 0.;
            else
                color.a = 1.;
            gl_FragColor = color;
		}
		
	")
    public function new(){
        super();
    }

}