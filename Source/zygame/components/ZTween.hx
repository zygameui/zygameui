package zygame.components;

import zygame.components.data.TimelineData;
import zygame.display.DisplayObjectContainer;
import zygame.core.Start;
import zygame.core.Refresher;
import zygame.components.ZBuilder;

using tweenxcore.Tools;

/**
 * 过渡库实现
 */
class ZTween implements Refresher {
	private var _baseXml:Xml;

	private var _baseFrames:Array<TweenFrame>;

	/**
	 * 时间戳
	 */
	public var timeline:TimelineData = new TimelineData(0, 60);

	private var _isPlay:Bool = false;

	/**
	 * 是否正在播放中，可通过`stop`进行停止，`play`进行播放
	 */
	public var isPlay(get, never):Bool;

	/**
	 * 是否立即同步
	 */
	public var sync:Bool = false;

	private function get_isPlay():Bool {
		return _isPlay;
	}

	/**
	 * 需要根据XML定义的动画配置进行播放动画
	 * @param xml 动画配置
	 */
	public function new(xml:Xml) {
		if (xml.nodeType == Document)
			_baseXml = xml.firstElement();
		else
			_baseXml = xml;
		this.timeline.onFrame = __updateFrame;
		this.timeline.onComplete = this.stop;
		this.timeline.loop = 1;
	}

	/**
	 * 绑定显示对象
	 * @param display 
	 */
	public function bindDisplayObject(display:DisplayObjectContainer):Void {
		_baseFrames = [];
		if (_baseXml.get("auto") == "true") {
			play();
		}
		if (_baseXml.exists("loop")) {
			timeline.loop = Std.parseInt(_baseXml.get("loop"));
			if (timeline.loop == 0)
				timeline.loop = 1;
		}
		// 解析帧动画
		var frames = _baseXml.elements();
		var lastStart = 0;
		while (frames.hasNext()) {
			var xml = frames.next();
			var tw = new TweenFrame(xml, display, sync);
			if (!xml.exists("start"))
				tw.start = lastStart;
			lastStart = tw.end + 1;
			if (tw.end > timeline.maxFrame)
				timeline.maxFrame = tw.end;
			pushTweenFrame(tw);
		}
	}

	/**
	 * 追加`TweenFrame`帧数据
	 * @param tw 
	 */
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
					_baseFrames.push(new TweenFrame(newtwXml, tw.bind, sync));
				case "scaleY":
					var yvalue = Reflect.getProperty(tw.bind, "y");
					var hvalue = Reflect.getProperty(tw.bind, "height");
					newtwXml.set("from", Std.string(yvalue + hvalue / 2 * (1 - tw.from)));
					newtwXml.set("to", Std.string(yvalue));
					newtwXml.set("start", tw.getXml().get("start"));
					newtwXml.set("end", tw.getXml().get("end"));
					newtwXml.set("type", tw.getXml().get("type"));
					newtwXml.set("key", "y");
					_baseFrames.push(new TweenFrame(newtwXml, tw.bind, sync));
				default:
					throw "ZTween.scale标签仅可以提供给scaleX,scaleY属性使用";
			}
		}
	}

	public function bindBuilder(builder:Builder, parentid:String = null):Void {
		_baseFrames = [];
		this.sync = _baseXml.get("sync") == "true";
		if (_baseXml.get("auto") == "true") {
			play();
		}
		if (_baseXml.exists("loop")) {
			timeline.loop = Std.parseInt(_baseXml.get("loop"));
			if (timeline.loop == 0)
				timeline.loop = 1;
		}
		// 解析帧动画
		var frames = _baseXml.elements();
		var lastStart = 0;
		while (frames.hasNext()) {
			var xml = frames.next();
			var bindid = (parentid != null ? parentid + "_" : "") + xml.get("bind");
			if (!builder.ids.exists(bindid))
				throw xml.toString() + ":Bind Error (" + bindid + ")";
			var tw = new TweenFrame(xml, builder.ids.get(bindid), sync);
			if (!xml.exists("start"))
				tw.start = lastStart;
			lastStart = tw.end + 1;
			if (xml.exists("onend"))
				tw.onend = builder.getFunction(xml.get("onend"));
			if (xml.exists("onstart"))
				tw.onstart = builder.getFunction(xml.get("onstart"));
			if (xml.exists("onframe"))
				tw.onframe = builder.getFunction(xml.get("onframe"));
			if (tw.end > timeline.maxFrame)
				timeline.maxFrame = tw.end;
			_baseFrames.push(tw);
		}
	}

	/**
	 * 前往下一帧
	 */
	public function nextFrame():Void {
		timeline.nextFrame();
	}

	/**
	 * 回到上一帧
	 */
	public function lastFrame():Void {
		timeline.lastFrame();
	}

	/**
	 * 触发播放
	 */
	public function play(frame:Int = -1, loop:Int = 1):Void {
		if (frame >= 0) {
			timeline.loop = loop;
			timeline.currentFrame = frame;
		}
		_isPlay = true;
		Start.current.addToUpdate(this);
		for (f in _baseFrames) {
			if (f.getNodeName() == "tween")
				f.update(frame);
		}
	}

	/**
	 * 获得帧列表
	 * @return Array<TweenFrame>
	 */
	public function getFrameList():Array<TweenFrame> {
		return _baseFrames;
	}

	public function onFrame():Void {
		if (!_isPlay)
			return;
		timeline.advanceTime(Start.current.frameDt);
	}

	/**
	 * 更新当前帧所有事件
	 */
	public function update():Void {
		__updateFrame(timeline.currentFrame);
	}

	private function __updateFrame(frame:Int):Void {
		for (f in _baseFrames) {
			f.update(frame + 1);
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

	public function new(tween:Xml, bind:Dynamic, parentSync:Bool) {
		this.bind = bind;
		key = tween.get("key");
		_baseXml = tween;
		start = Std.parseInt(tween.get("start"));
		end = Std.parseInt(tween.get("end"));
		updateData((parentSync && tween.get("sync") != "false") || tween.get("start") == "0" || tween.get("sync") == "true");
	}

	public function updateData(setKey:Bool):Void {
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
				if (setKey)
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
				updateData(true);
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
					// quartOut在压缩状态下，会丢失真实的计算方式，会转换为quintOut进行计算
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
