package zygame.macro;

import haxe.macro.Expr;

class JsonSet {
	macro static public function setData(data:Dynamic, ldtk:Dynamic):Expr {
		return macro {
			var data = Reflect.fields(${data});
			for (key in data) {
				Reflect.setProperty(${data}, key, Reflect.getProperty(${ldtk}, key));
			}
		};
	}
}
