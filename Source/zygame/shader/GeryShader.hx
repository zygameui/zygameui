package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 灰度着色器
 */
class GeryShader extends DisplayObjectShader {

	public static var shader:GeryShader = new GeryShader();

    @:glFragmentSource("
		
		#pragma header
				
		void main(void) {
			
			#pragma body
			float mColor = 0.0;
			mColor += gl_FragColor.r + gl_FragColor.g + gl_FragColor.b;
			mColor = mColor/3.0;
			gl_FragColor.r = mColor;
			gl_FragColor.g = mColor;
			gl_FragColor.b = mColor;
			gl_FragColor *= openfl_Alphav;
			
		}
		
	")
    public function new(){
        super();
    }

}