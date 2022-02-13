package zygame.net;

import openfl.events.TimerEvent;
import openfl.net.URLRequest;
import openfl.utils.Timer;

/**
 * 支持超时的请求支持 
**/
class URLLoader extends openfl.net.URLLoader {
	/**
	 * 计时器
	**/
	private var _timer:Timer;

	/**
	 * 超时设定，默认8秒超时
	**/
	public var timeout:Float = 8000;

	public function new(url:URLRequest = null) {
		super(url);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
	}

	/**
	 * 超时事件
	**/
	private function onTimeOut(e:TimerEvent):Void {
		this.close();
	}

	override function load(request:URLRequest) {
		_timer.delay = timeout;
		_timer.repeatCount = 1;
		super.load(request);
		_timer.reset();
		_timer.start();
	}
}
