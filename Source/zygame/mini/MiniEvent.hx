package zygame.mini;

/**
 * 迷你游戏引擎事件，请直接使用Event接收
 */
@:keep
class MiniEvent {

    /**
     * 游戏失败（结束）
     */
    public static var GAME_OVER:String = "gameOver";

    /**
     * 游戏胜利
     */
    public static var GAME_WIN:String = "gameWin";

    /**
     * 游戏得分
     */
    public static var ADD_SCORE:String = "addScore";

}