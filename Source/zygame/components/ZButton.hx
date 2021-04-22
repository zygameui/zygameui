package zygame.components;

import openfl.events.MouseEvent;
import zygame.components.base.ToggleButton;
import zygame.components.skin.BaseSkin;
import zygame.components.ZLabel;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 *  实现单张图片时，会有点击缩放效果
 */
class ZButton extends ToggleButton {
	/**
	 * 默认音频
	 */
	public static var defaultSound:String;

	private var _text:ZLabel;

	/**
	 * 创建模态按钮（zygame框架中的按钮样式）
	 * @param txt
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
	 * @param up
	 * @param down
	 * @param over
	 * @param out
	 * @return ZButton
	 */
	public static function createButton(up:Dynamic, down:Dynamic = null, over:Dynamic = null, out:Dynamic = null):ZButton {
		var button:ZButton = new ZButton();
		button.skin = createSkin(up, down, over, out);
		return button;
	}

	/**
	 * 快捷创建皮肤
	 * @param up
	 * @param down
	 * @param over
	 * @param out
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

	public function new() {
		super();
		this.addEventListener("click", _clickCall);
	}

	/**
	 * 点击音效ID名
	 */
	public var sound:String;

	public var clickEvent(never, set):Void->Void;

	private var _clickEventCall:Void->Void;

	private function _clickCall(e:MouseEvent):Void {
		if (sound != null || defaultSound != null) {
			var playsound = ZBuilder.getBaseSound(sound == null ? defaultSound : sound);
			if (playsound != null) {
				playsound.play(0, 1);
			}
		}
		if (_clickEventCall != null)
			_clickEventCall();
	}

	private function set_clickEvent(call:Void->Void):Void->Void {
		_clickEventCall = call;
		return call;
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
			box.addChild(_text);
			trace(_text.width, _text.height);
		}
	}

	public function setTextColor(color:UInt):Void {
		initText();
		_text.setFontColor(color);
	}

	public function setTextSize(size:Int):Void {
		initText();
		_text.setFontSize(size);
	}

	public function getText():String {
		if (_text == null)
			return "";
		return _text.dataProvider;
	}

	public function setText(text:String):Void {
		initText();
		trace("set", text);
		_text.dataProvider = text;
	}

	public function setTextPos(xz:Float, yz:Float):Void {
		_text.x = xz;
		_text.y = yz;
	}

	/**
	 * 设置九宫格格式
	 * @param rect
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		if (img != null)
			img.setScale9Grid(rect);
	}

	override function initComponents() {
		super.initComponents();
	}
}
