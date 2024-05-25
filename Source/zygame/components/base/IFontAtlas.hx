package zygame.components.base;

import zygame.utils.load.FntLoader.FntFrame;

interface IFontAtlas {
	/**
	 * 文本的最高高度
	 */
	public var maxHeight:Float;

	/**
	 * 文本字体的高度
	 */
	public function getFontHeight():Float;

	/**
	 * 获得一个纹理
	 * @param id 
	 * @return BaseFrame
	 */
	public function getTileFrame(id:Int):FntFrame;

	/**
	 * 通过emoj获得一个纹理
	 * @param emoj 
	 * @return FntFrame
	 */
	public function getTileFrameByEmoj(emoj:String):FntFrame;
}
