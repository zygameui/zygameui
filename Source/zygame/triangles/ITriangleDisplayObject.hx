package zygame.triangles;

import openfl.Vector;

interface ITriangleDisplayObject {
	public var vertices:Vector<Float>;

	public var x(get,set):Float;

	public var y(get,set):Float;

	public var width(get,set):Float;

	public var height(get,set):Float;

	public var alpha(get,set):Float;

	public var blendMode(get,set):Int;
}
