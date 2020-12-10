package zygame.net;


/**
 * 游戏服务器管理器，用于管理用户的状态同步、帧同步流程。此类为一个单例
 */
class GameServerManager {
    
    private static var _server:BaseServer;

    private static var _ip:String;

    private static var _port:Int;

    /**
     * 初始化服务器配置
     * @param ip 远程服务器的IP
     * @param port 远程服务器的端口
     */
    public static function initServerConfig(ip:String,port:Int):Void
    {
        _ip = ip;
        _port = port;
        
    }

    /**
     * 获取服务器
     * @return BaseServer
     */
    public static function getServer():BaseServer
    {
        if(_server == null)
            _server = new zygame.net.server.SocketIOServer();
        return _server;
    }

    /**
     * 获取IP
     * @return String
     */
    public static function getIp():String
    {
        return _ip;
    }

    /**
     * 获取IP端口
     * @return Int
     */
    public static function getPort():Int
    {
        return _port;
    }

}