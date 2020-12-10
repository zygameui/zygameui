package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 图层透明着色器
 */
class LayerAlphaShader extends DisplayObjectShader {

    @:glFragmentSource("
		
		#pragma header

        uniform float malpha;
				
		void main(void) {
			
			#pragma body
			gl_FragColor.r *= malpha;
			gl_FragColor.g *= malpha;
			gl_FragColor.b *= malpha;
			gl_FragColor.a *= malpha;
		}
		
	")
    public function new(a:Float = 1){
        super();
		this.malpha.value = [a];
    }

}