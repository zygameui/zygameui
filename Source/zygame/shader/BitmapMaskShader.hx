package zygame.shader;

import openfl.display.DisplayObjectShader;

class BitmapMaskShader extends DisplayObjectShader {
	@:glFragmentSource("

        #pragma header

        uniform sampler2D mask_Texture;
				
		void main(void) {
			
			#pragma body

            vec4 finalColor = texture2D(mask_Texture, openfl_TextureCoordv);
            if(finalColor.a + finalColor.r + finalColor.g + finalColor.b == 0.)
            {
                color.r = 0.;
                color.g = 0.;
                color.b = 0.;
                color.a = 0.;
            }
            else
            {
                color.r *= finalColor.a;
                color.g *= finalColor.a;
                color.b *= finalColor.a;
                color.a *= finalColor.a;
            }

			gl_FragColor = color * openfl_Alphav;
			
		}

    ")
	public function new(bitmapData:openfl.display.BitmapData):Void {
		super();
		this.mask_Texture.input = bitmapData;
	}
}
