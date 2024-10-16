package zygame.components;

import zygame.core.Start;
import zygame.utils.FrameEngine;
import zygame.components.data.MixColorData;
import haxe.Timer;
import openfl.events.TouchEvent;
import zygame.media.SoundChannelManager;
import openfl.events.MouseEvent;
import zygame.components.base.ToggleButton;
import zygame.components.skin.BaseSkin;
import zygame.components.ZLabel;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * 实现单张图片时，会有点击缩放效果，或者是点击切换的按钮效果，默认允许XML中使用。
 * ```xml
 * <ZButton id="btn" src="img_name" text="按钮文本"/>
 * ```
 */
class ZButton extends ToggleButton {
	/**
	 * 默认音频，设置该参数可以获得全局的音频
	 * ```haxe
	 * ZButton.defaultSound = "playSoundName";
	 * ```
	 */
	public static var defaultSound:String;

	private var _text:ZLabel;

	/**
	 * 当前按钮的文本对象
	 */
	public var label(get, never):ZLabel;

	/**
	 * 创建模态按钮（zygame框架中的按钮样式）
	 * @param txt 按钮文本
	 * @return ZButton
	 */
	public static function createModelButton(txt:String):ZButton {
		var button:ZButton = new ZButton();
		button.skin = createSkin(@:privateAccess ZModel._modelBitmapData, null, null, null);
		button.setText(txt);
		button.width = 100;
		button.height = 32;
		return button;
	}

	/**
	 * 快捷创建按钮
	 * @param up 默认松开的按钮图片；如果只提供up图片，按钮会呈缩放效果，如果包含有down图片，按钮会呈切换效果
	 * @param down 默认按下的按钮图片
	 * @param over 当鼠标滑过按钮时显示的图片
	 * @param out 当鼠标滑出的时显示的图片
	 * @return ZButton
	 */
	public static function createButton(up:Dynamic, down:Dynamic = null, over:Dynamic = null, out:Dynamic = null):ZButton {
		var button:ZButton = new ZButton();
		var skins = createSkin(up, down, over, out);
		button.skin = skins;
		return button;
	}

	/**
	 * 快捷创建皮肤
	 * @param up 默认松开的按钮图片；如果只提供up图片，按钮会呈缩放效果，如果包含有down图片，按钮会呈切换效果
	 * @param down 默认按下的按钮图片
	 * @param over 当鼠标滑过按钮时显示的图片
	 * @param out 当鼠标滑出的时显示的图片
	 * @return ButtonSkin
	 */
	public static function createSkin(up:Dynamic, down:Dynamic = null, over:Dynamic = null, out:Dynamic = null):ButtonSkin {
		var s:ButtonSkin = new ButtonSkin();
		s.upSkin = up;
		s.downSkin = down;
		s.overSkin = over;
		s.outSkin = out;
		return s;
	}

	/**
	 * 构造一个按钮
	 */
	public function new() {
		super();
		this.addEventListener("click", _clickCall);
	}

	/**
	 * 使用`TouchEvent`事件触发
	 */
	public function useTouchEvent():Void {
		this.removeEventListener("click", _clickCall);
		this.removeEventListener(TouchEvent.TOUCH_BEGIN, _touchBegin);
		this.removeEventListener(TouchEvent.TOUCH_END, _touchEnd);
	}

	private var _touch = false;

	private function _touchBegin(e:TouchEvent):Void {
		_touch = true;
	}

	private function _touchEnd(e:TouchEvent):Void {
		if (_touch) {
			_clickCall(null);
			_touch = false;
		}
	}

	/**
	 * 点击音效ID名，该点击音效优先级高于`ZButton.defaultSound`
	 */
	public var sound:String;

	/**
	 * 点击事件，通过简易的方法对它侦听点击事件：
	 * ```haxe
	 * btn.clickEvent = function(){
	 * 	ZLog.log("点击成功");
	 * }
	 * ```
	 */
	public var clickEvent(get, set):Void->Void;

	private var _clickEventCall:Void->Void;

	private var _time:Float = -1;

	private function _clickCall(e:MouseEvent):Void {
		// 防止连点器
		var n = Timer.stamp();
		if (n - _time <= 0.05) {
			_time = n;
			return;
		}
		_time = n;
		if (!this.mouseEnabled)
			return;
		if (sound != null || defaultSound != null) {
			var playsound = ZBuilder.getBaseSound(sound == null ? defaultSound : sound);
			if (SoundChannelManager.current.isEffectAvailable()) {
				@:privateAccess SoundChannelManager.current.playEffect(playsound, 1);
			}
		}
		#if auto_clicker
		zygame.utils.AutoClicker.clickByZButton(this);
		#else
		if (_clickEventCall != null)
			_clickEventCall();
		#end
	}

	private function get_clickEvent():Void->Void {
		return _clickEventCall;
	}

	private function set_clickEvent(call:Void->Void):Void->Void {
		_clickEventCall = call;
		return call;
	}

	/**
	 * 长按回调鼠标事件，一般长按0.5秒则为快速响应
	 */
	public var longClickEvent(default, set):Void->Void;

	private function set_longClickEvent(cb:Void->Void):Void->Void {
		this.longClickEvent = cb;
		return longClickEvent;
	}

	private override function set_width(value:Float):Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		img.width = value;

		var contentimg:ZImage = cast this.box.findComponent("content");
		if (contentimg != null) {
			contentimg.x = img.width / 2 - contentimg.width / 2;
		}
		return value;
	}

	private override function set_height(value:Float):Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		img.height = value;

		var contentimg:ZImage = cast this.box.findComponent("content");
		if (contentimg != null) {
			contentimg.y = img.height / 2 - contentimg.height / 2;
		}
		return value;
	}

	override private function get_width():Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		return img != null ? img.width : 0;
	}

	override private function get_height():Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		return img != null ? img.height : 0;
	}

	override public function updateComponents():Void {
		super.updateComponents();
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		if (img == null)
			return;
		var skin:ButtonSkin = cast skin;
		img.scaleX = 1;
		img.scaleY = 1;
		img.x = 0;
		img.y = 0;
		box.scaleX = 1;
		box.scaleY = 1;
		box.x = 0;
		box.y = 0;
		if (_text != null) {
			_text.width = this.width;
			_text.height = this.height;
		}
		// if(skin != null && toggleState == ToggleButton.DOWN && skin.downSkin == null)
		if (toggleState == ToggleButton.DOWN) {
			img.scaleX = 0.94;
			img.scaleY = 0.94;
			img.x = img.width * 0.03;
			img.y = img.height * 0.03;
			box.scaleX = 0.94;
			box.scaleY = 0.94;
			box.x = img.x;
			box.y = img.y;
		}
		if (skin != null && !skin.hasEventListener(Event.CHANGE))
			skin.addEventListener(Event.CHANGE, onChange);
	}

	private function onChange(e:Event):Void {
		updateComponents();
	}

	private function initText():Void {
		if (_text == null) {
			_text = new ZLabel();
			_text.width = this.width;
			_text.height = this.height;
			_text.hAlign = "center";
			_text.mouseEnabled = false;
			_text.autoTextSize = true;
			_text.setWordWrap(false);
			box.addChild(_text);
		}
	}

	/**
	 * 设置文本颜色，XML配置可通过`color`设置
	 * @param color 文本颜色
	 */
	public function setTextColor(color:UInt):Void {
		initText();
		_text.setFontColor(color);
	}

	/**
	 * 设置文本的描边，XML配置可通过`stroke`进行设置
	 * @param color 
	 */
	public function setTextStroke(color:UInt):Void {
		initText();
		_text.stroke(color);
	}

	/**
	 * 设置文本大小，XML配置可通过size设置
	 * @param size 文本大小
	 */
	public function setTextSize(size:Int):Void {
		initText();
		_text.setFontSize(size);
	}

	/**
	 * 设置文本的过渡色
	 */
	public var mixColor(get, set):MixColorData;

	private function set_mixColor(v:MixColorData):MixColorData {
		initText();
		_text.mixColor = v;
		return v;
	}

	private function get_mixColor():MixColorData {
		if (_text == null)
			return null;
		return _text.mixColor;
	}

	/**
	 * 获取文本内容
	 * @return String
	 */
	public function getText():String {
		if (_text == null)
			return "";
		return _text.dataProvider;
	}

	/**
	 * 设置文本内容
	 * @param text 
	 */
	public function setText(text:String):Void {
		initText();
		_text.dataProvider = text;
	}

	/**
	 * 设置文本的坐标位置偏移
	 * @param xz X轴偏移
	 * @param yz Y轴偏移
	 */
	public function setTextPos(xz:Float, yz:Float):Void {
		initText();
		_text.x = xz;
		_text.y = yz;
	}

	/**
	 * 设置九宫格格式
	 * @param rect 九宫格参数
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		if (img != null)
			img.setScale9Grid(rect);
	}

	override function initComponents() {
		super.initComponents();
	}

	function get_label():ZLabel {
		this.initText();
		return _text;
	}

	/**
	 * 获得按钮的原始宽度，即非缩放后的宽度
	 */
	public function getOriginWidth():Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		return img != null ? img.width / img.scaleX : 0;
	}

	/**
	 * 获得按钮的原始高度，即非缩放后的高度
	 */
	public function getOriginHeight():Float {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		return img != null ? img.height / img.scaleY : 0;
	}

	override function onMouseDown(e:MouseEvent) {
		super.onMouseDown(e);
		if (longClickEvent != null) {
			// 开始进行计数器
			var time = 0.;
			FrameEngine.create((f) -> {
				if (this.stage == null || toggleState == ToggleButton.UP) {
					f.stop();
					return;
				}
				time += Start.current.frameDt;
				if (time > 0.5) {
					longClickEvent();
				}
			});
		}
	}
}
