package zygame.shader.engine;

@:forward
abstract Vec2(IVec2) from IVec2 to IVec2 {
	public inline function new(x:Null<Dynamic> = null, y:Null<Dynamic> = null) {
		this = {
			x: x,
			y: y,
			xy: x,
			yx: y
		};
	}

	@:op(A / B) static function div(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A / B) static function div2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A /= B) static function assignDiv(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A /= B) static function assignDiv2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A * B) static function multiply(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A * B) static function multiply2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A *= B) static function assignMultiply(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A *= B) static function assignMultiply2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A += B) static function assignAdd(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A += B) static function assignAdd2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A -= B) static function assignSub(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A -= B) static function assignSub2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A + B) static function add(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A + B) static function add2(a:Vec2, b:Float):Vec2 {
		return a;
	};

	@:op(A - B) static function sub(a:Vec2, b:Vec2):Vec2 {
		return a;
	};

	@:op(A - B) static function sub2(a:Vec2, b:Float):Vec2 {
		return a;
	};
}



typedef IVec2 = {
	x:Float,
	y:Float,
	xy:Float,
	yx:Float
}
