package zygame.utils;

class ColorUtils {
	public static function toShaderColor(color:UInt):Color {
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		return {
			r: r / 255,
			g: g / 255,
			b: b / 255
		};
	}
}

typedef Color = {
	r:Float,
	g:Float,
	b:Float
}
