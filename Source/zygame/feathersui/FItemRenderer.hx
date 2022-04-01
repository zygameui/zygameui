package zygame.feathersui;

import feathers.controls.IToggle;
import feathers.core.IUIControl;
import feathers.controls.dataRenderers.IDataRenderer;
import zygame.components.ZBox;

class FItemRenderer extends ZBox implements IUIControl implements IDataRenderer implements IToggle {
	/**
		The data to render.

		@since 1.0.0
	**/
	@:flash.property
	public var data(get, set):Dynamic;

	private var _value:Dynamic;

	public function set_data(value:Dynamic):Dynamic {
		_value = value;
		return _value;
	}

	public function get_data():Dynamic {
		return _value;
	}

	public var enabled(get, set):Bool;

	public function get_enabled():Bool {
		return true;
	}

	public function set_enabled(value:Bool):Bool {
		return true;
	}

	public function get_toolTip():String {
		return null;
	}

	public function set_toolTip(value:String):String {
		return value;
	}

	public var toolTip(get, set):String;

	public function initializeNow() {}

	private var _selected:Bool = false;

	public function get_selected():Bool {
		return _selected;
	}

	public var selected(get, set):Bool;

	public function set_selected(value:Bool):Bool {
		_selected = value;
		return _selected;
	}
}
