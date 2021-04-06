package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 显示对象描边着色器
 */
class TextStrokeShader extends DisplayObjectShader {
	@:glFragmentSource("
		
		#pragma header

        uniform vec3 strokeColor;

        uniform float stroke;

        uniform float textsize;

		void main(void) {
			
			#pragma body
            
            float radius = 0.00005 * stroke * textsize;
            vec4 framecolor = vec4(0.,0.,0.,0.);
            for(int i = 1;i>0;i--)
            {
                float radius2 = float(i) * radius;
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x + radius2,openfl_TextureCoordv.y));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x - radius2,openfl_TextureCoordv.y));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x,openfl_TextureCoordv.y + radius2));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x,openfl_TextureCoordv.y - radius2));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x + radius2,openfl_TextureCoordv.y + radius2));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x + radius2,openfl_TextureCoordv.y - radius2));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x - radius2,openfl_TextureCoordv.y + radius2));
                framecolor += texture2D(openfl_Texture, vec2(openfl_TextureCoordv.x - radius2,openfl_TextureCoordv.y - radius2));
            }
            framecolor *= 1.0;
            framecolor.rgb = vec3(strokeColor.r,strokeColor.g,strokeColor.b)*framecolor.a;
            color = (framecolor * (1.0 - color.a)) + (color * color.a);
            gl_FragColor = color * openfl_Alphav;
			
		}

		
	")
	/**
	 * 描边渲染
	 * @param color 描边颜色
	 * @param strokeNum 描边厚度
     * @param textsize 字体大小
	 */
	public function new(color:UInt, strokeNum:Int = 1, textsize:Int = 24) {
		super();
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		this.strokeColor.value = [r / 255, g / 255, b / 255];
		this.stroke.value = [strokeNum];
		this.textsize.value = [textsize];
	}
}
