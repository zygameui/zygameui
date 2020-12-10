package zygame.mini;

import zygame.components.ZBuilder.Builder;

/**
 * 迷你小游戏引擎扩展实现
 */
interface MiniExtend {
	/**
	 * 基础生成baseBuilder，该属性只有通过MiniEngine创建时生效。
	 */
	public var baseBuilder:Builder;
}
