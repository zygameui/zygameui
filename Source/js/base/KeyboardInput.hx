package js.base;

import zygame.components.ZLabel;

interface KeyboardInput {
	/**
	 * 开始输入文本
	 * @param text 
	 */
	public function input(text:ZLabel):Void;

	/**
	 * 键盘回收事件
	 * @param call 
	 */
	public function onKeyboardComplete(call:Void->Void):Void;
}
