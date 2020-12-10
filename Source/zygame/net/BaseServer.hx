package zygame.net;

import openfl.events.IEventDispatcher;

/**
 * 服务器接口实现
 */
interface BaseServer extends IEventDispatcher {
	/**
	 * 获取本地的房间数据信息
	 * @return Dynamic
	 */
	public function getLocalRoomInfo():Dynamic;

	/**
	 * 获取当前客户端的用户数据
	 * @return Dynamic
	 */
	public function getSelfUser():Dynamic;

	/**
	 * 需要处理服务器接口时，需要先login登录完成
	 * @param success
	 * @param fail
	 */
	public function login(msg:Dynamic, success:Dynamic->Void, fail:Int->Void = null):Void;

	/**
	 * 登出服务器，在不需要服务器对战时，则自行登出
	 */
	public function logout():Void;

	/**
	 * 是否已登录
	 * @return Bool
	 */
	public function isLogin():Bool;

	/**
	 * 重连游戏服务。如果此时连接并未断开或游戏未开始，会直接成功；如果游戏已开始并且连接已断开，会进行重连，并返回此时服务器的最大帧号。
	 * @param success
	 * @param fail
	 */
	public function reconnect(success:Dynamic->Void, fail:Int->Void = null):Void;

	/**
	 * 获取历史数据
	 */
	public function getGameHistoryData(roomid:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 获取历史记录列表
	 */
	public function getGameHistoryList(page:Int, count:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 在房间内进行广播
	 * @param msg 广播的消息
	 * @param toPosNumList 给座位号为哪些的玩家发送信息，不填代表给房间所有人发送
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function broadcastInRoom(msg:Dynamic, toPosNumList:Array<Int> = null, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 更新玩家状态信息
	 * @param data 玩家状态信息，推荐长度256字符以内
	 * @param success
	 * @param fail
	 */
	public function setStats(data:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 获取与服务器请求的延迟
	 * @return Float
	 */
	public function getDelay():Float;

	/**
	 * 获取需要补帧的帧数据
	 * @param start
	 * @param end
	 * @param success
	 * @param fail
	 */
	public function getLostFrames(start:Int, end:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 切换房间座位
	 * @param pos
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function changeSeat(pos:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 创建房间
	 * @param maxMemberNum 房间最大人数，支持2 - 10。
	 * @param startPercent 需要满足百分比的玩家都发送了开始指令才能启动游戏。有效范围 0~100，0 表示只要有一个人调用开始就启动，100 表示要求所有人都开始才能启动。
	 * @param gameLastTime 游戏对局时长，到达指定时长时游戏会结束，最大值
	 * @param roomExtInfo 房间扩展信息，最多32个字节
	 * @param memberExtInfo 个人扩展信息，最多32个字节
	 * @param gameTick 游戏帧同步时间刻，默认为0（不需要帧同步）传入的代表多少帧下发一次帧同步数据
	 * @param needGameSeed 是否需要创建房间随机种子，默认为0不创建，1为创建
     * @param success 成功回调
	 * @param fail 失败回调
	 * @return
	 */
	public function createRoom(maxMemberNum:Int, startPercent:Int = 0, gameLastTime:Int = 1200, roomExtInfo:String = null, memberExtInfo:String = null,
		needGameSeedCount:Int = 0, gameTick:Int = 0, success:Dynamic->Void = null, fail:Int->Void = null, passworld:String = null):Void;

	/**
	 * 加入房间
	 * @param accessInfo 房间唯一标示
	 * @param memberExtInfo 个人扩展信息，最多32个字节
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function joinRoom(accessInfo:Dynamic, memberExtInfo:String = null, success:Dynamic->Void = null, fail:Int->Void = null,
		passworld:String = null):Void;

	/**
	 * 把一名玩家踢出房间（仅房主有权限）
	 * @param kickoutPos 欲踢除的玩家的座位号
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function kickoutMember(kickoutPos:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 普通成员退出房间
	 */
	public function memberLeaveRoom(accessInfo:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 房主退出房间
	 * @param accessInfo 房间唯一标示
	 * @param success
	 * @param fail
	 */
	public function ownerLeaveRoom(accessInfo:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 更新准备状态
	 * @param accessInfo 房间唯一标示
	 * @param isReady 是否准备好
	 * @param success
	 * @param fail
	 */
	public function updateReadyStatus(accessInfo:Dynamic, isReady:Bool, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 开始帧同步
	 */
	public function startGame(success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 上传游戏帧
	 * @param actionList 指令数组
	 * @param success
	 * @param fail
	 */
	public function uploadFrame(frame:Int, data:String, success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 游戏结束事件
	 */
	public function gameOver(success:Dynamic->Void = null, fail:Int->Void = null):Void;

	/**
	 * 获取房间列表
	 * @param page
	 * @param count
	 * @param success
	 * @param fail
	 */
	public function getRoomList(page:Int, count:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void;
}
