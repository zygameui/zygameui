package zygame.shader;

import openfl.display.DisplayObjectShader;

/**
 * 马赛克渲染
 */
class MaskShader extends DisplayObjectShader{

    @:glFragmentSource("

        #pragma header

		uniform vec2 mosaicSize;
					
		void main(void) {
			
			#pragma body

			vec2 xy = vec2(openfl_TextureCoordv.x * openfl_TextureSize.x, openfl_TextureCoordv.y * openfl_TextureSize.y);
			vec2 xyMosaic = vec2(floor(xy.x / mosaicSize.x) * mosaicSize.x, 
					floor(xy.y / mosaicSize.y) * mosaicSize.y )
					+ .5*mosaicSize;
			vec2 delXY = xyMosaic - xy;
			float delL = length(delXY);
			vec2 uvMosaic = vec2(xyMosaic.x / openfl_TextureSize.x, xyMosaic.y / openfl_TextureSize.y);
			
			vec4 finalColor;
			if(delL<0.5*mosaicSize.x)
			{
				finalColor = texture2D(openfl_Texture, uvMosaic);
			}
			else
			{
				finalColor = texture2D(openfl_Texture, uvMosaic);
				// finalColor = vec4(0., 0., 0., 1.);
			}
			gl_FragColor = finalColor * openfl_Alphav;
			
		}
		
	")  
	/**
	 * 马赛克渲染
	 * @param mosaicWidth 宽度间隔
	 * @param mosaicHeight 高度间隔
	 */
	public function new(mosaicWidth:Int = 8,mosaicHeight:Int = 8){
		super();
        this.mosaicSize.value = [mosaicWidth,mosaicHeight];
	}

}