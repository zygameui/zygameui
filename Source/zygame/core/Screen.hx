package zygame.core;

import zygame.display.DisplayObjectContainer;

/**
 * 游戏显示层，一般用于需要分层的时候使用
 */
class Screen extends DisplayObjectContainer {
    
    /**
     * 是否忽略舞台发生变化时的更改，默认为false
     */
    public var igoneChange:Bool = false;

}