package zygame.components.skin;

import openfl.utils.Dictionary;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 *  基础的皮肤
 */
class BaseSkin extends EventDispatcher {
	/**
	 *  字典，用于储存皮肤资源
	 */
	private var _dist:Dictionary<String, Dynamic>;

	public function new() {
		super();
		_dist = new Dictionary();
	}

	/**
	 *  设置皮肤
	 *  @param key - 键值
	 *  @param skin - 可使用图片路径、可使用位图对象
	 */
	public function setSkinValue(key:String, skin:Dynamic):Void {
		if (Std.is(skin, String))
			skin = ZBuilder.getBaseBitmapData(skin);
		_dist.set(key, skin);
		if (key == "up")
			this.defalutSkin = skin;
		this.dispatchEvent(new Event(Event.CHANGE, false, false));
	}

	public function getSkinValue(key:String):Dynamic {
		return _dist.get(key);
	}

	/**
	 *  默认皮肤，在指定的皮肤里获取不到时使用
	 */
	public var defalutSkin(get, set):Dynamic;

	private function set_defalutSkin(skin:Dynamic):Dynamic {
		setSkinValue("defalut", skin);
		return skin;
	}

	private function get_defalutSkin():Dynamic {
		return getSkinValue("defalut");
	}
}

/**
 *  按钮皮肤，按下皮肤，松开皮肤，移入皮肤，移出皮肤
 */
class ButtonSkin extends BaseSkin {
	public var upSkin(get, set):Dynamic;

	private function set_upSkin(skin:Dynamic):Dynamic {
		setSkinValue("up", skin);
		return skin;
	}

	private function get_upSkin():Dynamic {
		return getSkinValue("up");
	}

	public var overSkin(get, set):Dynamic;

	private function set_overSkin(skin:Dynamic):Dynamic {
		setSkinValue("over", skin);
		return skin;
	}

	private function get_overSkin():Dynamic {
		return getSkinValue("over");
	}

	public var outSkin(get, set):Dynamic;

	private function set_outSkin(skin:Dynamic):Dynamic {
		setSkinValue("out", skin);
		return skin;
	}

	private function get_outSkin():Dynamic {
		return getSkinValue("out");
	}

	public var downSkin(get, set):Dynamic;

	private function set_downSkin(skin:Dynamic):Dynamic {
		setSkinValue("down", skin);
		return skin;
	}

	private function get_downSkin():Dynamic {
		return getSkinValue("down");
	}
}
