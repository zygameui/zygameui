package zygame.components.base;

import zygame.utils.load.FntLoader.FntFrame;

interface IFontAtlas {
	/**
	 * 文本的最高高度
	 */
	public var maxHeight:Float;

	/**
	 * 获得一个纹理
	 * @param id 
	 * @return BaseFrame
	 */
	public function getTileFrame(id:Int):FntFrame;
}
