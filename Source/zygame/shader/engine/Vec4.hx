package zygame.shader.engine;

import zygame.shader.engine.Vec3;

@:forward
enum abstract Vec4(IVec.BaseVec) from IVec.BaseVec to IVec.BaseVec {
	public inline function new(r:Null<Dynamic> = null, g:Null<Dynamic> = null, b:Null<Dynamic> = null, a:Null<Dynamic> = null) {
		this = {
			r: r,
			g: g,
			b: b,
			a: a,
			rgb: null,
		};
	}

	

}