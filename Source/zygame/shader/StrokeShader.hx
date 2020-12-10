package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 显示对象描边着色器
 */
class StrokeShader extends DisplayObjectShader{

     @:glFragmentSource("
		
		#pragma header

        uniform vec3 strokeColor;

        uniform float stroke;

        uniform float palpha;

		void main(void) {
			
			#pragma body
            
            if(color.a > 0.5)
            {
                gl_FragColor = color * openfl_Alphav;
                return;
            }

            float isStroke = 0.0;
            for(int i = 0;i<12;i++)
            {
                float agnle = 30.0 * float(i);
                float rad = agnle * 0.01745329252;
                vec2 unit = 1.0 / openfl_TextureSize.xy;
                vec2 offset = vec2(stroke * cos(rad) * unit.x, stroke * sin(rad) * unit.y);
                float a = texture2D(openfl_Texture, openfl_TextureCoordv + offset).a;
                if(a > palpha)
                {
                    isStroke = 1.0;
                    break;
                }
            }

            if(isStroke == 1.0)
            {
                color.rgb = strokeColor;
                color.a = 1.0;
            }

            gl_FragColor = color * openfl_Alphav;
			
		}

		
	")
    public function new(color:UInt,strokeNum:Int = 1,strokeIfAlpha:Float = 0){
        super();
        var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
        this.strokeColor.value = [r/255,g/255,b/255];
        this.stroke.value = [strokeNum];
        this.palpha.value = [strokeIfAlpha];
    }
}