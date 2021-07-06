package zygame.components;

import zygame.display.DisplayObjectContainer;
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

	private var _baseFrames:Array<TweenFrame>;

	private var _crrentFrame:Int = 0;

	private var _maxFrame:Int = 0;

	private var _isPlay:Bool = false;

	public var isPlay(get, never):Bool;

	private function get_isPlay():Bool {
		return _isPlay;
	}

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
		if (xml.nodeType == Document)
			_baseXml = xml.firstElement();
		else
			_baseXml = xml;
	}

	public function bindDisplayObject(display:DisplayObjectContainer):Void {
		_baseFrames = [];
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
			var tw = new TweenFrame(xml, display);
			if (!xml.exists("start"))
				tw.start = lastStart;
			lastStart = tw.end + 1;
			// if (xml.exists("onend"))
			// 	tw.onend = builder.getFunction(xml.get("onend"));
			// if (xml.exists("onstart"))
			// 	tw.onstart = builder.getFunction(xml.get("onstart"));
			// if (xml.exists("onframe"))
			// 	tw.onframe = builder.getFunction(xml.get("onframe"));
			if (tw.end > _maxFrame)
				_maxFrame = tw.end;
			pushTweenFrame(tw);
		}
	}

	public function pushTweenFrame(tw:TweenFrame):Void {
		_baseFrames.push(tw);
		if (tw.getNodeName() == "scale") {
			// 如果是缩放计算,则需要绑定X/Y位移的TweenFrame
			var key = tw.getXml().get("key");
			var newtwXml = Xml.createElement("tween");
			switch (key) {
				case "scaleX":
					var xvalue:Float = Reflect.getProperty(tw.bind, "x");
					var wvalue:Float = Reflect.getProperty(tw.bind, "width");
					newtwXml.set("from", Std.string(xvalue + wvalue / 2 * (1 - tw.from)));
					newtwXml.set("to", Std.string(xvalue));
					newtwXml.set("start", tw.getXml().get("start"));
					newtwXml.set("end", tw.getXml().get("end"));
					newtwXml.set("type", tw.getXml().get("type"));
					newtwXml.set("key", "x");
					_baseFrames.push(new TweenFrame(newtwXml, tw.bind));
				case "scaleY":
					var yvalue = Reflect.getProperty(tw.bind, "y");
					var hvalue = Reflect.getProperty(tw.bind, "height");
					newtwXml.set("from", Std.string(yvalue + hvalue / 2 * (1 - tw.from)));
					newtwXml.set("to", Std.string(yvalue));
					newtwXml.set("start", tw.getXml().get("start"));
					newtwXml.set("end", tw.getXml().get("end"));
					newtwXml.set("type", tw.getXml().get("type"));
					newtwXml.set("key", "y");
					_baseFrames.push(new TweenFrame(newtwXml, tw.bind));
				default:
					throw "ZTween.scale标签仅可以提供给scaleX,scaleY属性使用";
			}
		}
	}

	public function bindBuilder(builder:Builder, parentid:String = null):Void {
		_baseFrames = [];
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
			var bindid = (parentid != null ? parentid + "_" : "") + xml.get("bind");
			if (!builder.ids.exists(bindid))
				throw xml.toString() + ":Bind Error (" + bindid + ")";
			var tw = new TweenFrame(xml, builder.ids.get(bindid));
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
		for (frame in _baseFrames) {
			if (frame.getNodeName() == "tween")
				frame.update(_crrentFrame);
		}
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
				if (loop < 0) {
					// 无限循环
				} else if (loop == 0) {
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

	private var _lockTo:Null<Float>;

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
				to = _baseXml.exists("to") ? Std.parseFloat(_baseXml.get("to")) : Reflect.getProperty(bind, key);
				if (_lockTo != null)
					to = _lockTo;
				if (!_baseXml.exists("to"))
					_lockTo = to;
				type = _baseXml.get("type");
				Reflect.setProperty(bind, key, from);
		}
	}

	public function getNodeName():String {
		return _baseXml.nodeName;
	}

	public function getXml():Xml {
		return _baseXml;
	}

	public function update(frame:Int):Void {
		if (lastFrame == frame)
			return;
		lastFrame = frame;
		var timeline:Float = end;
		if (frame >= start && frame <= end) {
			if (_canUpdateData || frame == start + 1) {
				updateData();
			}
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
		if (type != null) {
			switch (type) {
				case "quartOut":
					// trace("Warring:quartOut在压缩状态下，会丢失真实的计算方式，会转换为quintOut进行计算");
					Reflect.setProperty(bind, key, timeline.quintOut().lerp(from, to));
				default:
					var call = Reflect.getProperty(Easing, type);
					if (call != null) {
						var value:Float = cast(call(timeline), Float);
						value = FloatTools.lerp(value, from, to);
						Reflect.setProperty(bind, key, value);
					} else {
						Reflect.setProperty(bind, key, FloatTools.lerp(timeline.linear(), from, to));
					}
			}
		} else {
			Reflect.setProperty(bind, key, timeline.linear().lerp(from, to));
		}
	}
}
