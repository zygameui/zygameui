package zygame.shader.engine;

@:forward
enum abstract Vec3(IVec.BaseVec) from IVec.BaseVec to IVec.BaseVec {
	public inline function new(r:Null<Dynamic> = null, g:Null<Dynamic> = null, b:Null<Dynamic> = null, a:Null<Dynamic> = null) {
		this = {
			r: r,
			g: g,
			b: b
		};
	}

}

typedef IVec3 = Dynamic;
