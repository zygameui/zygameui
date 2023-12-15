package zygame.components.base;

import zygame.components.base.ItemRender;
import zygame.components.ZLabel;

class DefalutItemRender extends ItemRender {
	private var _text:ZLabel;

	public function new() {
		super();
		this.height = 100;
	}

	override public function initComponents():Void {
		super.initComponents();
		_text = new ZLabel();
		this.addChild(_text);
		_text.dataProvider = "test";
		_text.width = 100;
		_text.height = 100;
		_text.setFontColor(0x0);
		_text.setFontSize(32);
	}

	override private function set_data(value:Dynamic):Dynamic {
		super.data = value;
		if (value != null)
			_text.dataProvider = value;
		return _data;
	}
}
