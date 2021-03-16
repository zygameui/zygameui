package zygame.components;

import zygame.core.Start;
import zygame.core.Refresher;
import zygame.script.ZHaxe;
import zygame.utils.Lib;
import zygame.components.ZBuilder;

using tweenxcore.Tools;

/**
 * 过渡库实现
 */
class ZTween implements Refresher {
	private var _baseXml:Xml;

	private var _baseFrames:Array<TweenFrame> = [];

	private var _builder:Builder;

	private var _crrentFrame:Int = 0;

	private var _maxFrame:Int = 0;

	private var _isPlay:Bool = false;

	private var _onFrameId:Int = -1;

	/**
	 * 循环次数
	 */
	public var loop:Int = 0;

	/**
	 * 需要根据XML定义的动画配置进行播放动画
	 * @param xml 动画配置
	 */
	public function new(xml:Xml) {
		_baseXml = xml;
	}

	public function bindBuilder(builder:Builder, parentid:String = null):Void {
		_builder = builder;
		if (_baseXml.get("auto") == "true") {
			play();
		}
		if (_baseXml.exists("loop")) {
			loop = Std.parseInt(_baseXml.get("loop"));
		}
		// 解析帧动画
		var frames = _baseXml.elements();
		var lastStart = 0;
		while (frames.hasNext()) {
			var xml = frames.next();
			var tw = new TweenFrame(xml, builder.ids.get((parentid == null ? "" : parentid + "_") + xml.get("bind")));
			if (!xml.exists("start"))
				tw.start = lastStart;
			lastStart = tw.end + 1;
			if (xml.exists("onend"))
				tw.onend = builder.getFunction(xml.get("onend"));
			if (xml.exists("onstart"))
				tw.onstart = builder.getFunction(xml.get("onstart"));
			if (xml.exists("onframe"))
				tw.onframe = builder.getFunction(xml.get("onframe"));
			if (tw.end > _maxFrame)
				_maxFrame = tw.end;
			_baseFrames.push(tw);
		}
	}

	public function nextFrame():Void {
		_crrentFrame++;
		if (_crrentFrame > _maxFrame)
			_crrentFrame = _maxFrame;
		update();
	}

	public function lastFrame():Void {
		_crrentFrame--;
		if (_crrentFrame < 0)
			_crrentFrame = 0;
		update();
	}

	/**
	 * 触发播放
	 */
	public function play(frame:Int = -1):Void {
		if (frame >= 0)
			_crrentFrame = frame;
		if (!_isPlay) {
			_isPlay = true;
			if (_crrentFrame >= _maxFrame || _crrentFrame < 0)
				_crrentFrame = 0;
		}
		Start.current.addToUpdate(this);
	}

	public function getFrameList():Array<TweenFrame> {
		return _baseFrames;
	}

	public function onFrame():Void {
		if (!_isPlay)
			return;
		_crrentFrame++;
		if (_crrentFrame > _maxFrame) {
			if (_isPlay) {
				_crrentFrame--;
				if (loop <= 0) {
					stop();
					return;
				} else {
					loop--;
				}
			}
			_crrentFrame = 0;
		}
		update();
	}

	public function update():Void {
		for (frame in _baseFrames) {
			frame.update(_crrentFrame);
		}
	}

	/**
	 * 停止播放
	 */
	public function stop():Void {
		Start.current.removeToUpdate(this);
		_isPlay = false;
	}
}

class TweenFrame {
	public var start:Int = 0;

	public var end:Int = 0;

	public var type:String = null;

	public var from:Float = 0;

	public var to:Float = 0;

	public var key:String = "";

	public var bind:Dynamic = null;

	private var _canUpdateData:Bool = false;

	private var _baseXml:Xml;

	public var onend:Void->Void;

	public var onstart:Void->Void;

	public var onframe:Void->Void;

	public var lastFrame:Int = 0;

	public function new(tween:Xml, bind:Dynamic) {
		this.bind = bind;
		key = tween.get("key");
		_baseXml = tween;
		start = Std.parseInt(tween.get("start"));
		end = Std.parseInt(tween.get("end"));
		updateData();
	}

	public function updateData():Void {
		_canUpdateData = false;
		switch (_baseXml.nodeName) {
			case "add":
				from = _baseXml.exists("from") ? (Reflect.getProperty(bind, key) + Std.parseFloat(_baseXml.get("from"))) : Reflect.getProperty(bind, key);
				to = Reflect.getProperty(bind, key) + Std.parseFloat(_baseXml.get("to"));
				type = _baseXml.get("type");
			default:
				from = _baseXml.exists("from") ? Std.parseFloat(_baseXml.get("from")) : Reflect.getProperty(bind, key);
				to = Std.parseFloat(_baseXml.get("to"));
				type = _baseXml.get("type");
		}
	}

	public function update(frame:Int):Void {
		if (lastFrame == frame)
			return;
		lastFrame = frame;
		var timeline:Float = end;
		if (frame >= start && frame <= end) {
			if (_canUpdateData || frame == start + 1)
				updateData();
			timeline = (frame - start) / (timeline - start);
			if (frame == end && onend != null)
				onend();
			if (frame == start && onstart != null)
				onstart();
			if (onframe != null)
				onframe();
		} else {
			_canUpdateData = true;
			return;
		}
		switch (type) {
			case "backOut":
				Reflect.setProperty(bind, key, timeline.backOut().lerp(from, to));
			default:
				Reflect.setProperty(bind, key, timeline.linear().lerp(from, to));
		}
	}
}
