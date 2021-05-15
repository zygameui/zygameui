package zygame.shader.engine;

import zygame.shader.engine.Vec3;

@:forward
enum abstract Vec4(IVec4) from IVec4 to IVec4 {
	public inline function new(r:Null<Dynamic> = null, g:Null<Dynamic> = null, b:Null<Dynamic> = null, a:Null<Dynamic> = null) {
		this = {
			r: r,
			g: g,
			b: b,
			a: a,
			rgb: null,
		};
	}

	@:op(A / B) static function div(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A / B) static function div2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A /= B) static function assignDiv(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A /= B) static function assignDiv2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A * B) static function multiply(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A * B) static function multiply2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A *= B) static function assignMultiply(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A *= B) static function assignMultiply2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A += B) static function assignAdd(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A += B) static function assignAdd2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A -= B) static function assignSub(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A -= B) static function assignSub2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A + B) static function add(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A + B) static function add2(a:Vec4, b:Float):Vec4 {
		return a;
	};

	@:op(A - B) static function sub(a:Vec4, b:Vec4):Vec4 {
		return a;
	};

	@:op(A - B) static function sub2(a:Vec4, b:Float):Vec4 {
		return a;
	};
}

typedef IVec4 = {
	r:Float,
	g:Float,
	b:Float,
	a:Float,
	rgb:Vec3
}
