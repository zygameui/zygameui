package zygame.net.server;

import zygame.utils.FrameEngine;
import zygame.utils.Lib;
import openfl.events.EventDispatcher;
import haxe.io.Bytes;
import openfl.utils.ByteArray;
import haxe.Json;
import openfl.events.ProgressEvent;
import openfl.events.Event;
import openfl.net.Socket;

/**
 * 基于Socket.io实现的服务器系统
 */
class SocketIOServer extends EventDispatcher implements BaseServer {
	public var _socket:Socket;

	/**
	 * 登陆凭证
	 */
	private var _accessToken:String;

	private var _reqId:Int = 0;

	private var _calls:Map<Int, ServerCall> = [];

	private var _roomInfo:Dynamic;

	private var _frameEngine:FrameEngine;

	/**
	 * 延迟计算，只记录最近10条延迟操作
	 */
	private var _delay:Array<Float> = [];

	private var _delayTime:Float = 50;

	public function new() {
		super(null);
		this.addEventListener(GameServerEvent.GAME_START, onGameStart);
		this.addEventListener(GameServerEvent.PLAYER_STATS_UPDATE, onPlayerStatsUpdate);
		this.addEventListener(GameServerEvent.ROOM_INFO_CHANGE, onRoomInfoChange);
		UDP.onUDPMessage = function(data) {
			if (data.indexOf(":") != -1) {
				var array = data.split(":");
				switch (array[0]) {
					case "f":
						this.dispatchEvent(new GameServerEvent(GameServerEvent.SYNC_FRAME, array[1]));
				}
			}
		}
		Lib.setInterval(onUploadFrame, 50);
		Lib.setInterval(onUploadHeartbeat, 5000);
	}

	private function onRoomInfoChange(e:GameServerEvent):Void {
		_roomInfo = e.data;
	}

	/**
	 * 获取本地的状态信息
	 * @return Dynamic
	 */
	public function getLocalRoomInfo():Dynamic {
		return _roomInfo;
	}

	/**
	 * 玩家的状态更新发生
	 * @param e
	 */
	private function onPlayerStatsUpdate(e:GameServerEvent):Void {
		var userData = getSelfPlayerData(e.data.pos);
		if (userData != null) {
			var keys = Reflect.fields(e.data.data);
			for (key in keys) {
				Reflect.setProperty(userData.stats, key, Reflect.getProperty(e.data.data, key));
			}
		}
	}

	/**
	 * 需要处理服务器接口时，需要先login登录完成
	 * @param msg {name:昵称,uid:平台OPENID,version:游戏版本号,app:游戏名,einfo:扩展数据}
	 * @param success
	 * @param fail
	 */
	public function login(msg:Dynamic, success:Dynamic->Void, fail:Int->Void = null):Void {
		_socket = new Socket(GameServerManager.getIp(), GameServerManager.getPort());
		_socket.addEventListener(Event.CONNECT, function(e:Event):Void {
			trace("[Socket]连接成功");
			request("user.login", msg, function(data) {
				if (data.code == 0) {
					_accessToken = data.data.accessToken;
				}
				success(data);
			});
		});
		_socket.addEventListener(Event.CLOSE, function(e:Event):Void {
			trace("[Socket]连接断开");
		});
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
	}

	/**
	 * 获取与服务器请求的延迟
	 * @return Float
	 */
	public function getDelay():Float {
		if (_delayTime > 460)
			return 460;
		return _delayTime;
	}

	private var _lastFrameSyncTime:Float = 0;

	private function pushDelay(delay:Float):Void {
		_delay.push(delay);
		if (_delay.length > 10) {
			_delay.shift();
		}
		_delayTime = 0;
		for (f in _delay) {
			_delayTime += f;
		}
		_delayTime = Std.int(_delayTime / _delay.length);
	}

	/**
	 * 接受到消息
	 * @param data
	 */
	private function onSocketData(data:ProgressEvent):Void {
		var data:String = _socket.readMultiByte(_socket.bytesAvailable, "utf-8");
		var json = Json.parse(data);
		if (json.rid != null) {
			var scb = _calls.get(json.rid);
			scb.call(json);
			this.pushDelay(scb.getDelay());
			_calls.remove(json.rid);
		} else if (json.action == "server.notiy") {
			// 服务器广播事件
			switch (json.code) {
				case 1001:
					// 房间发生数据变化
					this.dispatchEvent(new GameServerEvent(GameServerEvent.ROOM_INFO_CHANGE, json.data));
				case 1002:
					// 被房主踢出房间
					this.dispatchEvent(new GameServerEvent(GameServerEvent.BE_KICKED_OUT, json.data));
				case 1003:
					// 游戏开始
					// 先补帧
					this.getLostFrames(0, 999999, function(data) {
						// 补帧成功
					});
					this.dispatchEvent(new GameServerEvent(GameServerEvent.GAME_START, json.data));
				case 1004:
					// 帧同步事件（TCP协议）
					this.dispatchEvent(new GameServerEvent(GameServerEvent.SYNC_FRAME, json.data));
				case 1005:
					// 房间列表更新
					this.dispatchEvent(new GameServerEvent(GameServerEvent.ROOM_LIST_UPDATE, json.data));
				case 1006:
					// 房间信息广播
					this.dispatchEvent(new GameServerEvent(GameServerEvent.ROOM_MESSAGE, json.data));
				case 1007:
					// 玩家状态更新
					this.dispatchEvent(new GameServerEvent(GameServerEvent.PLAYER_STATS_UPDATE, json.data));
			}
		}
	}

	/**
	 * 获取需要补帧的帧数据
	 * @param start
	 * @param end
	 * @param success
	 * @param fail
	 */
	public function getLostFrames(start:Int, end:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("game.getLostFrames", {
			start: start,
			end: end
		}, function(data) {
			// 开始补帧处理
			var list:Array<String> = data.data;
			for (s in list) {
				this.dispatchEvent(new GameServerEvent(GameServerEvent.SYNC_FRAME, s));
			}
			success(data);
		});
	}

	/**
	 * 发送消息
	 * @param data
	 */
	private function request(action:String, data:Dynamic, call:Dynamic->Void = null):Void {
		if (_socket == null || !_socket.connected)
			return;
		_reqId++;
		data = {
			action: action,
			data: data,
		};
		if (_accessToken != null)
			data.token = _accessToken;
		data.rid = _reqId;
		if (call != null)
			_calls.set(data.rid, new ServerCall(call));
		var sendData:String = haxe.Json.stringify(data);
		var bytes = ByteArray.fromBytes(Bytes.ofString(sendData));
		_socket.writeBytes(bytes, 0, bytes.bytesAvailable);
		_socket.flush();
	}

	/**
	 * 获取历史数据
	 */
	public function getGameHistoryData(roomid:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.getGameHistoryData", {
			id: roomid,
		}, success);
	}

	/**
	 * 获取历史记录列表
	 */
	public function getGameHistoryList(page:Int, count:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.getGameHistoryList", {
			page: page,
			count: count
		}, success);
	}

	/**
	 * 登出服务器，在不需要服务器对战时，则自行登出
	 */
	public function logout():Void {
		if (_socket != null) {
			if (_socket.connected)
				_socket.close();
			_socket = null;
		}
	};

	/**
	 * 在房间内进行广播
	 * @param msg 广播的消息
	 * @param toPosNumList 给座位号为哪些的玩家发送信息，不填代表给房间所有人发送
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function broadcastInRoom(msg:Dynamic, toPosNumList:Array<Int> = null, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.broadcastInRoom", msg, success);
	}

	/**
	 * 切换房间座位
	 * @param pos
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function changeSeat(pos:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {}

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
			needGameSeedCount:Int = 0,gameTick:Int = 0, success:Dynamic->Void = null, fail:Int->Void = null, passworld:String = null):Void {
		this.request("room.createRoom", {
			startPercent: startPercent,
			gameLastTime: gameLastTime,
			roomExtInfo: roomExtInfo,
			memberExtInfo: memberExtInfo,
			needGameSeedCount: needGameSeedCount,
			gameTick: gameTick,
			passworld: passworld
		}, function(data) {
			_roomInfo = data.data;
			success(data);
		});
	}

	/**
	 * 加入房间
	 * @param accessInfo 房间唯一标示
	 * @param memberExtInfo 个人扩展信息，最多32个字节
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function joinRoom(accessInfo:Dynamic, memberExtInfo:String = null, success:Dynamic->Void = null, fail:Int->Void = null,
			passworld:String = null):Void {
		request("room.joinRoom", {
			accessInfo: accessInfo,
			passworld: passworld,
			memberExtInfo: memberExtInfo
		}, function(data) {
			_roomInfo = data.data;
			success(data);
		});
	}

	/**
	 * 把一名玩家踢出房间（仅房主有权限）
	 * @param kickoutPos 欲踢除的玩家的座位号
	 * @param success 成功回调
	 * @param fail 失败回调
	 */
	public function kickoutMember(kickoutPos:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.kickout", {
			kickoutPos: kickoutPos
		}, success);
	}

	/**
	 * 普通成员退出房间
	 */
	public function memberLeaveRoom(accessInfo:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.exitRoom", {}, success);
	}

	/**
	 * 是否已登录
	 * @return Bool
	 */
	public function isLogin():Bool {
		return _accessToken != null && _socket != null && _socket.connected;
	};

	/**
	 * 重连游戏服务。如果此时连接并未断开或游戏未开始，会直接成功；如果游戏已开始并且连接已断开，会进行重连，并返回此时服务器的最大帧号。
	 * @param success
	 * @param fail
	 */
	public function reconnect(success:Dynamic->Void, fail:Int->Void = null):Void {};

	/**
	 * 房主退出房间
	 * @param accessInfo 房间唯一标示
	 * @param success
	 * @param fail
	 */
	public function ownerLeaveRoom(accessInfo:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.exitRoom", {}, success);
	}

	/**
	 * 更新准备状态
	 * @param accessInfo 房间唯一标示
	 * @param isReady 是否准备好
	 * @param success
	 * @param fail
	 */
	public function updateReadyStatus(accessInfo:Dynamic, isReady:Bool, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.updateReady", {
			reday: isReady
		}, success);
	}

	/**
	 * 更新该玩家的状态，状态同步
	 * @param data
	 * @param success
	 * @param fail
	 */
	public function setStats(data2:Dynamic, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.setStats", data2, function(data) {
			if (data.code == 0) {
				var userData = getSelfPlayerData();
				if (userData != null) {
					var keys = Reflect.fields(data2);
					for (key in keys) {
						Reflect.setProperty(userData.stats, key, Reflect.getProperty(data2, key));
					}
				}
				if (success != null)
					success(data);
			}
		});
	}

	/**
	 * 获取当前客户端的用户数据
	 * @return Dynamic
	 */
	public function getSelfUser():Dynamic {
		return getSelfPlayerData();
	}

	/**
	 * 获取self玩家数据
	 * @return Dynamic
	 */
	private function getSelfPlayerData(pos:Int = -1):Dynamic {
		if (_roomInfo == null)
			return null;
		var users:Array<Dynamic> = _roomInfo.users;
		if (pos != -1)
			return users[pos];
		for (user in users) {
			if (user.self == true)
				return user;
		}
		return null;
	}

	/**
	 * 开始帧同步（仅房主有权限）
	 */
	public function startGame(success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.startGame", null, success);
	}

	/**
	 * 上传帧数据的间隔
	 */
	// private var uploadFrameTime:Int = 0;

	/**
	 * 上传帧数据的数据列表
	 */
	private var uploadFrameList:Array<Dynamic> = [];

	/**
	 * 上传心跳处理
	 */
	private function onUploadHeartbeat():Void {
		request("user.heartbeat", null, onUploadHeartbeated);
	}

	/**
	 *
	 */
	private function onUploadHeartbeated(data:Dynamic):Void {}

	/**
	 * 上传帧数据处理
	 */
	private function onUploadFrame():Void {
		if (uploadFrameList.length > 0) {
			// 默认不使用
			// if (false && UDP.isSupport()) {
			// 	// UDP协议
			// 	var room = getLocalRoomInfo().id;
			// 	var pos = getSelfUser().pos;
			// 	UDP.send("uf:" + room + "," + frame + "," + data, 36669, GameServerManager.getIp());
			// } else {
			// TCP协议，当UDP不可用时，则以TCP协议为上传手段
			request("game.uf", uploadFrameList);
			// }
			uploadFrameList = [];
		}
	}

	/**
	 * 上传游戏帧
	 * @param actionList 指令数组
	 * @param success
	 * @param fail
	 */
	public function uploadFrame(frame:Int, data:String, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		// 每50ms上传一批操作
		uploadFrameList.push({
			frame: frame,
			key: data
		});
	}

	/**
	 * 游戏结束事件(停止帧事件)
	 */
	public function gameOver(success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("game.gameOver", null, success);
	}

	/**
	 * 获取房间列表
	 * @param page
	 * @param count
	 * @param success
	 * @param fail
	 */
	public function getRoomList(page:Int, count:Int, success:Dynamic->Void = null, fail:Int->Void = null):Void {
		request("room.getRoomList", {
			page: page,
			count: count
		}, success);
	}

	/**
	 * 游戏开始时，需要使用UDP打洞
	 * @param e
	 */
	private function onGameStart(e:GameServerEvent):Void {
		onUDPConnect();
	}

	/**
	 * UDP打洞
	 */
	private function onUDPConnect():Void {
		UDP.send("udp:" + getLocalRoomInfo().id + "," + getSelfUser().pos, 36669, GameServerManager.getIp());
	}
}

class ServerCall {
	public var call:Dynamic->Void;

	public var sendtiem:Float;

	public function new(cb:Dynamic->Void):Void {
		call = cb;
		sendtiem = Date.now().getTime();
	}

	/**
	 * 获取延迟
	 * @return Int
	 */
	public function getDelay():Float {
		var now = Date.now().getTime();
		return now - sendtiem;
	}
}
