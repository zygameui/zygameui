package zygame.triangles;

import openfl.Vector;

interface ITriangleDisplayObject {
	public var vertices:Vector<Float>;

	public var x(get, set):Float;

	public var y(get, set):Float;

	public var width(get, set):Float;

	public var height(get, set):Float;

	public var alpha(get, set):Float;

	public var blendMode(get, set):Int;

	/**
	 * 渲染前计算
	 */
	public function onRenderReady():Void;

	/**
	 * 当数据发生变更时，需要设置为true，才会触发onRenderReady事件
	 */
	public var changed:Bool;
}
