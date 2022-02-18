package zygame.display.batch;

import zygame.media.SoundChannelManager;
import zygame.shader.Slice9Shader;
import zygame.shader.GeryShader;
import openfl.display.Shader;
import zygame.components.ZButton;
import zygame.components.ZBuilder;
import zygame.display.batch.BTouchSprite;
import zygame.display.batch.BSprite;
import zygame.display.batch.BImage;
import zygame.components.base.ToggleButton;
import zygame.utils.load.TextureLoader;
import zygame.components.skin.ButtonFrameSkin;
import openfl.events.TouchEvent;
import zygame.events.TileTouchEvent;
import zygame.display.batch.TouchImageBatchsContainer;
import openfl.events.Event;
import zygame.utils.load.Frame;
import zygame.display.batch.BScale9Image;
import openfl.display.Tile;

class BScale9Button extends BButton {
	public function new():Void {
		super(new BScale9Image());
	}

	override private function set_width(value:Float):Float {
		cast(getDisplay(), BScale9Image).width = value;
		this.updateComponents();
		return value;
	}

	override private function set_height(value:Float):Float {
		cast(getDisplay(), BScale9Image).height = value;
		this.updateComponents();
		return value;
	}

	override private function set_shader(s:Shader):Shader {
		super.set_shader(s);
		if (getDisplay() != null && cast(getDisplay().shader, Slice9Shader) != null) {
			cast(getDisplay().shader, Slice9Shader).u_size.value[3] = Std.isOfType(s, GeryShader) ? 1 : 0;
		}
		return s;
	}
}

/**
 * 可用于按钮批渲染
 */
class BButton extends BToggleButton {
	/**
	 * 锚点X轴
	 */
	public var anchorX:Float = 0;

	/**
	 * 锚点Y轴
	 */
	public var anchorY:Float = 0;

	/**
	 * 快捷创建批渲染九宫格按钮
	 * @param up 
	 * @param down 
	 * @param over 
	 * @param out 
	 * @return BButton
	 */
	public static function createScale9Button(sprites:TextureAtlas, width:Float, height:Float, up:Frame, down:Frame = null, over:Frame = null,
			out:Frame = null):BScale9Button {
		var button:BScale9Button = new BScale9Button();
		button.skin = createButtonFrameSkin(sprites, up, down, over, out);
		button.updateComponents();
		button.width = width;
		button.height = height;
		return button;
	}

	/**
	 * 快捷创建批渲染按钮
	 * @param up 
	 * @param down 
	 * @param over 
	 * @param out 
	 * @return BButton
	 */
	public static function createButton(sprites:TextureAtlas, up:Frame, down:Frame = null, over:Frame = null, out:Frame = null):BButton {
		var button:BButton = new BButton();
		button.skin = createButtonFrameSkin(sprites, up, down, over, out);
		button.updateComponents();
		return button;
	}

	/**
	 * 创建批渲染使用的按钮皮肤
	 * @param sprites 精灵表
	 * @param up 松开
	 * @param down 按下
	 * @param over 移入
	 * @param out 移出
	 * @return ButtonFrameSkin
	 */
	public static function createButtonFrameSkin(sprites:TextureAtlas, up:Frame, down:Frame = null, over:Frame = null, out:Frame = null):ButtonFrameSkin {
		var skin:ButtonFrameSkin = new ButtonFrameSkin(sprites);
		skin.upSkin = up;
		skin.downSkin = down;
		skin.overSkin = over;
		skin.outSkin = out;
		return skin;
	}

	public function new(tile:Tile = null) {
		super(tile != null ? tile : new BImage());
	}

	override public function updateComponents():Void {
		super.updateComponents();

		box.scaleX = 1;
		box.scaleY = 1;
		box.x = -anchorX;
		box.y = -anchorY;

		if (skin != null && toggleState == ToggleButton.DOWN && skin.downSkin == null) {
			box.scaleX = 0.94;
			box.scaleY = 0.94;
			if (Std.isOfType(getDisplay(), BImage)) {
				box.x = -anchorX + cast(getDisplay(), BImage).curWidth * 0.03;
				box.y = -anchorY + cast(getDisplay(), BImage).curHeight * 0.03;
			} else {
				box.x = -anchorX + cast(getDisplay(), BScale9Image).width * 0.03;
				box.y = -anchorY + cast(getDisplay(), BScale9Image).height * 0.03;
			}
		} else if (toggleState == ToggleButton.DOWN) {
			box.scaleX = 0.94;
			box.scaleY = 0.94;
			box.x = -anchorX + this.box.width * 0.03;
			box.y = -anchorY + this.box.height * 0.03;
		}

		if (skin != null && !skin.hasEventListener(Event.CHANGE))
			skin.addEventListener(Event.CHANGE, onChange);
	}

	private function onChange(e:Event):Void {
		updateComponents();
	}
}

class BToggleButton extends BTouchSprite {
	public var box:BSprite;

	private var img:Tile;

	private var content:BImage;

	private var _currentTouchID:Int = -1;

	/**
	 * 按钮皮肤实现
	 */
	public var skin:ButtonFrameSkin;

	/**
	 * 音效配置
	 */
	public var sound:String;

	/**
	 * 禁止产生音效
	 */
	public var disableSound:Bool = false;

	/**
	 * 点击事件触发
	 */
	public var clickEvent:Void->Void;

	private var _toggleState:String;

	public var toggleState(get, never):String;

	private function get_toggleState():String {
		return _toggleState;
	}

	public function getDisplay():Tile {
		return img;
	}

	public function new(display:Tile) {
		super();
		img = display;
		box = new BSprite();
		this.addChild(box);
		box.addChild(img);
		this.mouseChildren = false;
	}

	override public function onInit():Void {
		this.updateComponents();
	}

	public function updateComponents():Void {
		if (skin != null) {
			var skinData:Dynamic = null;
			switch (_toggleState) {
				case ToggleButton.UP:
					skinData = skin.upSkin;
				case ToggleButton.OVER:
					skinData = skin.overSkin;
				case ToggleButton.OUT:
					skinData = skin.outSkin;
				case ToggleButton.DOWN:
					skinData = skin.downSkin;
			}
			if (skinData == null)
				skinData = skin.defalutSkin;
			if (Std.isOfType(img, BImage))
				cast(img, BImage).setFrame(skin.getFrameSkin(skinData));
			else if (Std.isOfType(img, BScale9Image))
				cast(img, BScale9Image).setFrame(skin.getFrameSkin(skinData));
		}

		if (content != null) {
			content.x = this.getDisplayWidth() / 2 - content.curWidth / 2;
			content.y = this.getDisplayHeight() / 2 - content.curHeight / 2;
		}
	}

	// override private function get_width():Float
	// {
	//    return getDisplayWidth();
	// }
	// override private function get_height():Float
	// {
	//     return getDisplayHeight();
	// }

	/**
	 *  发送选择状态
	 * @param state - 通过ToggleButton的静态常量状态处理
	 */
	public function sendToggleState(state:String):Void {
		_toggleState = state;
		this.updateComponents();
	}

	override public function onTouchBegin(touch:TouchEvent):Void {
		if (_currentTouchID != -1)
			return;
		_currentTouchID = touch.touchPointID;
		sendToggleState(ToggleButton.DOWN);
	}

	override public function onTouchEnd(touch:TouchEvent):Void {
		if (touch.touchPointID == _currentTouchID && touch != null) {
			sendToggleState(ToggleButton.UP);
			if (Std.isOfType(touch.target, TouchImageBatchsContainer)) {
				var batchs:TouchImageBatchsContainer = cast touch.target;
				if (batchs.getTilePosAt(batchs.mouseX, batchs.mouseY) == this) {
					// batchs.dispatchEvent(new TileTouchEvent(touch.type+"Tile",this));
					if (!disableSound) {
						if (sound != null || ZButton.defaultSound != null) {
							if (SoundChannelManager.current.isEffectAvailable()) {
								var playsound = ZBuilder.getBaseSound(sound == null ? ZButton.defaultSound : sound);
								if (playsound != null) {
									playsound.play(0, 1);
								}
							}
						}
					}
					if (clickEvent != null)
						clickEvent();
				}
			}
			_currentTouchID = -1;
		}
	}

	/**
	 * 设置上下文内容
	 */
	public function setContent(frame:Frame):Void {
		var img:BImage = new BImage(frame);
		img.name = "CONTENT";
		box.removeTiles(1);
		box.addChild(img);
		content = img;
		this.updateComponents();
	}

	private function getDisplayWidth():Float {
		if (getDisplay() != null) {
			if (Std.isOfType(getDisplay(), BImage)) {
				return cast(getDisplay(), BImage).curWidth;
			} else {
				return cast(getDisplay(), BScale9Image).curWidth;
			}
		}
		return 0;
	}

	private function getDisplayHeight():Float {
		if (getDisplay() != null) {
			if (Std.isOfType(getDisplay(), BImage)) {
				return cast(getDisplay(), BImage).curHeight;
			} else {
				return cast(getDisplay(), BScale9Image).curHeight;
			}
		}
		return 0;
	}
}
