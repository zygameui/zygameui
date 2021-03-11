package zygame.utils;

class XMLUtils {

	/**
	 * 对XML进行格式化
	 * @param xmlContent 
	 * @return String
	 */
	@:noCompletion public static function fromat(xmlContent:String):String {
		var PADDING = '  ';
		var req = ~/(>)(<)(\/*)/g;
		xmlContent = req.replace(xmlContent, '$1\r\n$2$3');
		var xmllist = xmlContent.split("\r\n");
		var pad = 0;
		for (index => node in xmllist) {
			var indent = 0;
			var nodeMatch = ~/.+<\/\w[^>]*>$/;
			var nodeMatch2 = ~/^<\/\w/;
			var nodeMatch3 = ~/^<\w[^>]*[^\/]>.*$/;
			if (nodeMatch.match(node)) {
				indent = 0;
			} else if (nodeMatch2.match(node) && pad > 0) {
				pad -= 1;
			} else if (nodeMatch3.match(node)) {
				indent = 1;
			} else {
				indent = 0;
			}
			pad += indent;
			var len = pad - indent;
			var padstr = "";
			for (i in 0...len) {
				padstr += PADDING;
			}
			node = padstr + node;
		}
		return xmllist.join("\r\n");
	}
}
