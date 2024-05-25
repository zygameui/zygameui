package zygame.utils;

class EmojTools {
	/**
	 * 兼容emoj表情的字符切割处理
	 * @param char 
	 * @return Array<String>
	 */
	public static function split(char:String,s:String):Array<String> {
		#if !cpp
		var emoj = "";
		var array = [];
		var char = char.split(s);
		var req = ~/[\ud04e-\ue50e]+/;
		for (c in char) {
			if (req.match(c)) {
				emoj += c;
				if (emoj.length == 2) {
					array.push(emoj);
					emoj = "";
				}
			} else {
				array.push(c);
			}
		}
		return array;
		#else
		return char.split(s);
		#end
	}
}
