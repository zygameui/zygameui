package zygame.utils;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.macro.Compiler;
import zygame.core.Start;
#if html5
import js.Browser;
#end
import haxe.crypto.Md5;
import openfl.net.SharedObject;
import openfl.utils.Function;
import openfl.display.BitmapData;
import zygame.utils.load.Frame;
import openfl.geom.Rectangle;
import zygame.utils.TimeRuntime;

/**
 * 实用库
 */
@:keep
class Lib {
	public static var saveName:String = "zygame-lib";

	private static var sharedObject:SharedObject;

	/**
	 * 获取当前渲染模式
	 * @return String
	 */
	public static function getRenderMode():String {
		return Start.current.stage.window.context.type;
	}

	/**  
	 * 设置值
	 * @param key
	 * @param data
	 */
	public static function setData(key:String, data:Dynamic):Void {
		if (sharedObject == null)
			sharedObject = SharedObject.getLocal(saveName);
		// 防CE逻辑实现
		if (Std.isOfType(data, Int) || Std.isOfType(data, Float)) {
			// 如果是数字，需要进行加密处理
			data = ceEncode(data);
		}
		Reflect.setField(sharedObject.data, key, data);
		sharedObject.flush();
	}

	/**
	 * 锁定CE2
	 */
	public static function lockCE2():Void{

	}

	/**
	 * CE加密
	 * @param data
	 * @return String
	 */
	public static function ceEncode(data:Dynamic):String {
		#if ce2
		return "CE#" + Base64.encode(Bytes.ofString(Std.string(data)));
		#else
		return "CE#" + Base64.encode(Bytes.ofString(Std.string(data)));
		#end
	}

	/**
	 * CE解密
	 * @param value
	 * @return Float
	 */
	public static function ceDecode(value:Dynamic):Float {
		if (value == null)
			return 0;
		if (!Std.isOfType(value, String))
			return value;
		#if ce2
		value = StringTools.replace(value, "CE#", "");
		var bytes = Base64.decode(value);
		value = Std.parseFloat(bytes.getString(0, bytes.length));
		return value;
		#else
		value = StringTools.replace(value, "CE#", "");
		var bytes = Base64.decode(value);
		value = Std.parseFloat(bytes.getString(0, bytes.length));
		return value;
		#end
	}

	/**
	 * 获取zygame-lib本地储存数据
	 * @return SharedObject
	 */
	public static function getSharedObject():SharedObject {
		if (sharedObject == null)
			sharedObject = SharedObject.getLocal(saveName);
		return sharedObject;
	}

	/**
	 * 获取值
	 * @param key
	 * @param defulatData
	 * @return Dynamic
	 */
	public static function getData(key:String, defulatData:Dynamic = null):Dynamic {
		if (sharedObject == null)
			sharedObject = SharedObject.getLocal(saveName);
		var value:Dynamic = Reflect.field(sharedObject.data, key);
		if (value == null)
			return defulatData;
		// 防CE逻辑实现
		if (Std.isOfType(value, String) && cast(value, String).indexOf("CE#") != -1) {
			// 如果是数字，需要进行加密处理
			value = ceDecode(value);
		}
		return value;
	}

	private static var _timeRuntimes:Map<String, TimeRuntime> = new Map();

	/**
	 * 每帧发生处理，由Start执行
	 */
	public static function onFrame():Void {
		for (runtime in _timeRuntimes) {
			runtime.onFrame();
		}
	}

	/**
	 * 当活动恢复时触发
	 */
	public static function onResume():Void {
		for (runtime in _timeRuntimes) {
			runtime.onResume();
		}
	}

	/**
	 * 是否存在渲染事件
	 * @return Bool
	 */
	public static function hasRenderEvent():Bool {
		for (runtime in _timeRuntimes) {
			if (runtime.hasRenderEvent())
				return true;
		}
		return false;
	}

	/**
	 * 当渲染时触发
	 */
	public static function onRender():Void {
		for (runtime in _timeRuntimes) {
			runtime.onRender();
		}
	}

	/**
	 * 获取时间运行器
	 * @param tag
	 * @return TimeRuntime
	 */
	public static function getTimeRuntime(tag:String = "defalut"):TimeRuntime {
		var runtime = _timeRuntimes[tag];
		if (runtime == null) {
			runtime = new TimeRuntime();
			_timeRuntimes.set(tag, runtime);
		}
		return runtime;
	}

	/**
	 * 清空所有计时器运行器
	 */
	public static function clearAllTimeRuntime():Void {
		for (runtime in _timeRuntimes) {
			runtime.clear();
		}
	}

	/**
	 * 清理某个指定的计时器
	 * @param tag
	 */
	public static function clearTimeRuntime(tag:String = "defalut"):Void {
		getTimeRuntime(tag).clear();
	}

	/**
	 * 下一帧调用
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function nextFrameCall(closure:Function, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setTimeout(closure, 0, args);
	}

	/**
	 * 处理了自动释放处理
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function setTimeout(closure:Function, delay:Int, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setTimeout(closure, delay, args);
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public static function clearTimeout(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).clearTimeout(id);
	}

	/**
	 * 设置循环事件
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function setInterval(closure:Function, delay:Int = 0, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setInterval(closure, delay, args);
	}

	/**
	 * 重置计时器，重新计算
	 * @param id
	 */
	public static function resetInterval(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).resetInterval(id);
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public static function clearInterval(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).clearInterval(id);
	}

	/**
	 * 当活动恢复时，进行调用
	 * 请注意，从2021年9月29日开始，该接口需要恢复触发才会进行刷新。如果需要安全线程的恢复接口，请使用renderCall。
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function resumeCall(closure:Function, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).resumeCall(closure, args);
	}

	/**
	 * 当渲染时进行调用
	 * @param closure
	 * @param args
	 * @param runtimeTag
	 * @return Int
	 */
	public static function renderCall(closure:Function, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).renderCall(closure, args);
	}

	/**
	 * 提供CSS格式，进行转换
	 * @param bitmapData
	 * @param css 字符串格式，分别对应left/top/right/bottom
	 * @return openfl.geom.Rectangle
	 */
	public static function cssRectangle(bitmapData:Dynamic, css:String):openfl.geom.Rectangle {
		var width:Float = 0;
		var height:Float = 0;
		if (Std.isOfType(bitmapData, BitmapData)) {
			width = cast(bitmapData, BitmapData).width;
			height = cast(bitmapData, BitmapData).height;
		} else if (Std.isOfType(bitmapData, Frame)) {
			width = cast(bitmapData, Frame).width;
			height = cast(bitmapData, Frame).height;
		}
		if (width == 0 || height == 0)
			return null;
		// 上右下左
		var arr:Array<String> = css.split(" ");
		return new Rectangle(Std.parseFloat(arr[3]), Std.parseFloat(arr[0]), width
			- Std.parseFloat(arr[1])
			- Std.parseFloat(arr[3]),
			height
			- Std.parseFloat(arr[0])
			- Std.parseFloat(arr[2]));
	}

	/**
	 * 判断是否为base64
	 * @param str
	 * @return Bool
	 */
	public static function isBase64(str:String):Bool {
		var req = new EReg("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$", "g");
		return req.match(str);
	}

	/**
	 * 获取渠道名
	 */
	public static function getChannel():String {
		#if g4399
		return "g4399";
		#elseif bili
		return "bilibili";
		#elseif ios
		return "appstore";
		#elseif huawei
		return "huawei";
		#elseif qihoo
		return "qihoo";
		#elseif meizu
		return "meizu";
		#elseif mgc
		return "mgc";
		#elseif (qq || qqquick)
		return "qq";
		#elseif baidu
		return "baidu";
		#elseif tt
		return "tt";
		#elseif weixin
		return "wechat";
		#elseif oppo
		return "oppo";
		#elseif vivo
		return "vivo";
		#elseif (android && kengsdk)
		return KengSDK.globalChannel();
		#else
		var channel = Compiler.getDefine("channel");
		if (channel == null)
			channel = "default";
		return channel;
		#end
	}

	/**
	 * 判断环境是否为电脑
	 * @return Bool
	 */
	public static function isPc():Bool {
		#if (android || ios)
		return false;
		#elseif html5
		var userAgent = Browser.navigator.userAgent;
		var Agents = [
			  "Android",        "iPhone",
			"SymbianOS", "Windows Phone",
			     "iPad",          "iPod"
		];
		for (tag in Agents) {
			if (userAgent.indexOf(tag) != -1)
				return false;
		}
		return true;
		#else
		return true;
		#end
	}

	/**
	 * 获取唯一的UUID值
	 */
	public static function getUUID():String {
		if (sharedObject == null)
			sharedObject = SharedObject.getLocal("zygame-lib");
		#if (android && kengsdk)
		return KengSDK.getDeviceId();
		#else
		var uuid:String = sharedObject.data.uuid;
		if (uuid != null)
			return uuid.toUpperCase();
		var time:String = Std.string(Date.now().getTime());
		var random:String = "qwertyuioplkjhgfdsazxcvbnm";
		var format:String = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
		var len:Int = format.length;
		var path:String = "";
		for (i in 0...len) {
			path += format.charAt(i) == "x" ? random.charAt(Std.random(random.length)) : "-";
		}
		path = "guest_" + Md5.encode(path);
		sharedObject.data.uuid = path;
		sharedObject.flush();
		return path.toUpperCase();
		#end
	}

	/**
	 * 获取版本号
	 * @return String
	 */
	public static function getVersion():String {
		var version = Compiler.getDefine("version");
		if (version != null) {
			return version;
		}
		#if html5
		return Std.string(untyped window.GAME_VERSION == null ? "1001" : untyped window.GAME_VERSION);
		#elseif kengsdk
		return Std.string(KengSDK.getVersion());
		#else
		return "1000";
		#end
	}

	/**
	 * 根据两点坐标获取角度
	 * @param x1
	 * @param y1
	 * @param x2
	 * @param y2
	 * @return Float
	 */
	public static function getAngleByPos(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var angle:Float = Math.atan2((y2 - y1), (x2 - x1)); // 弧度
		return angle;
	}

	/**
	 * 角度转弧度
	 * @param angle
	 * @return Float
	 */
	public static function angleToRadian(angle:Float):Float {
		return angle * (Math.PI / 180);
	}

	/**
	 * 弧度转角度
	 * @param radian
	 * @return Float
	 */
	public static function radianToAngle(radian:Float):Float {
		return radian * (180 / Math.PI);
	}

	/**
	 * 可用于ZHaxe中解析浮点为整数
	 * @param num
	 * @return Int
	 */
	public static function int(num:Float):Int {
		return Std.int(num);
	}

	/**
	 * 获取运行平台名称，如IOS、Android等，如果无法识别，则会返回null
	 * @return String 
	 */
	public static function getPlatformName():String {
		#if wechat
		return untyped window.platform;
		#else
		return null;
		#end
	}
}
