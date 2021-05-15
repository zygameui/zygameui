package zygame.shader.engine;

@:forward
enum abstract Vec3(IVec3) from IVec3 to IVec3 {
	public inline function new(r:Null<Dynamic> = null, g:Null<Dynamic> = null, b:Null<Dynamic> = null, a:Null<Dynamic> = null) {
		this = {
			r: r,
			g: g,
			b: b
		};
	}

	@:op(A / B) static function div(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A / B) static function div2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A /= B) static function assignDiv(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A /= B) static function assignDiv2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A * B) static function multiply(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A * B) static function multiply2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A *= B) static function assignMultiply(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A *= B) static function assignMultiply2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A += B) static function assignAdd(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A += B) static function assignAdd2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A -= B) static function assignSub(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A -= B) static function assignSub2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A + B) static function add(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A + B) static function add2(a:Vec3, b:Float):Vec3 {
		return a;
	};

	@:op(A - B) static function sub(a:Vec3, b:Vec3):Vec3 {
		return a;
	};

	@:op(A - B) static function sub2(a:Vec3, b:Float):Vec3 {
		return a;
	};
}

typedef IVec3 = {
	r:Float,
	g:Float,
	b:Float
}
