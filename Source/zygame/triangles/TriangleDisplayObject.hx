package zygame.triangles;

import openfl.Vector;

/**
 * 显示对象基类
 */
class TriangleDisplayObject implements ITriangleDisplayObject {
	public var vertices:Vector<Float>;

	public var x(get, set):Float;

	private var _x:Float = 0;

	private function set_x(value:Float):Float {
		_x = value;
		changed = true;

		return _x;
	}

	private function get_x():Float {
		return _x;
	}

	public var y(get, set):Float;

	private var _y:Float = 0;

	private function set_y(value:Float):Float {
		_y = value;
		changed = true;
		return _y;
	}

	private function get_y():Float {
		return _y;
	}

	public var width(get, set):Float;

	private var _width:Float = 0;

	private function set_width(value:Float):Float {
		_width = value;
		changed = true;
		return _width;
	}

	private function get_width():Float {
		return _width;
	}

	public var height(get, set):Float;

	private var _height:Float = 0;

	private function set_height(value:Float):Float {
		_height = value;
		changed = true;
		return _height;
	}

	private function get_height():Float {
		return _height;
	}

	public var alpha(get, set):Float;

	private var _alpha:Float = 1;

	private function set_alpha(value:Float):Float {
		_alpha = value;
		changed = true;
		return _alpha;
	}

	private function get_alpha():Float {
		return _alpha;
	}

	public var blendMode(get, set):Int;

	private var _blendMode:Int = 0;

	private function set_blendMode(value:Int):Int {
		_blendMode = value;
		changed = true;
		return _blendMode;
	}

	private function get_blendMode():Int {
		return _blendMode;
	}

	/**
	 * 当数据发生变更时，需要设置为true，才会触发onRenderReady事件
	 */
	public var changed:Bool;

	public function new() {
		vertices = new Vector(0, false);
	}

	public function onRenderReady():Void {
		changed = false;
	};
}
