package zygame.shader.engine;

@:forward
abstract Vec2(IVec.BaseVec) from IVec.BaseVec to IVec.BaseVec {
	public inline function new(x:Null<Dynamic> = null, y:Null<Dynamic> = null) {
		this = {
			x: x,
			y: y,
			xy: x,
			yx: y
		};
	}
}
