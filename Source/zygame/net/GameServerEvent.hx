package zygame.net;

import zygame.events.ZEvent;

/**
 * 游戏服务器事件
 */
class GameServerEvent extends ZEvent {

    /**
     * 监听用户登出游戏服务事件，可能是主动登出也可能是其他原因被动登出。
     */
    public static var LOGOUT:String = "logout";

    /**
     * 帧同步开始
     */
    public static var GAME_START:String = "gamestart";

    /**
     * 监听同个房间的帧同步消息
     */
    public static var SYNC_FRAME:String = "ayncframe";

    /**
     * 房间信息发生变化
     */
    public static var ROOM_INFO_CHANGE:String = "room_info_change";

    /**
     * 监听帧同步游戏结束
     */
    public static var GAME_END:String = "gameend";

    /**
     * 监听断开连接，收到此事件后，需要调用 GameServerManager.reconnect 进行重连
     */
    public static var DISCONNECT:String = "disconnect";

    /**
     * 监听收到同个房间内的广播消息
     */
    public static var BROADCAST:String = "broadcast";

    /**
     * 监听自己被踢出当前房间
     */
    public static var BE_KICKED_OUT:String = "bekickedout";

    /**
     * 监听房间列表是否有更新
     */
    public static var ROOM_LIST_UPDATE:String = "roomlistupdate";

    /**
     * 房间消息广播
     */
    public static var ROOM_MESSAGE:String = "roommsg";

    /**
     * 某个玩家的状态变更
     */
    public static var PLAYER_STATS_UPDATE:String = "playerstatsupdate";

}