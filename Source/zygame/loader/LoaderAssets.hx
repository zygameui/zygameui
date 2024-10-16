package zygame.loader;

import zygame.loader.parser.JSONTextureAtlas;
import zygame.utils.StringUtils;
import zygame.loader.parser.SparticleParser;
import zygame.loader.parser.BitmapDataParser;
import zygame.loader.parser.JSONParser;
import zygame.loader.parser.XMLParser;
import zygame.loader.parser.CDBParser;
import zygame.loader.parser.TextParser;
import zygame.loader.parser.MP3Parser;
import zygame.loader.parser.ParserBase;
import zygame.loader.parser.BytesParser;
#if ldtk
import zygame.loader.parser.LDTKParser;
import zygame.loader.parser.AESParser;
#end

/**
 * ZAssets核心载入器，可简易使用扩展
 */
class LoaderAssets {
	/**
	 * 单独载入文件路径支持的格式载入解析器，可通过继承ParserBase来扩展自定义载入方式。supportType直接返回true的解析器请勿加入到此列表。
	 */
	public static var fileparser:Array<Class<ParserBase>> = [
		SparticleParser,
		BytesParser,
		#if true
		zygame.loader.parser.ASTCBitmapDataParser,
		#end
		MP3Parser,
		TextParser,
		#if castle
		CDBParser,
		#end
		XMLParser,
		JSONParser,
		BitmapDataParser
		#if (ldtk), LDTKParser, AESParser #end
	];

	public static function createParserBase(data:Dynamic, extPasrer:Map<String, String>):ParserBase {
		for (base in LoaderAssets.fileparser) {
			var cheakpath:String = data;
			var ext:String = StringUtils.getExtType(cheakpath);
			if (extPasrer.exists(ext)) {
				ext = extPasrer.get(ext);
				cheakpath = cheakpath.substr(0, cheakpath.lastIndexOf(".")) + "." + ext;
			}
			var bool = Reflect.callMethod(base, Reflect.field(base, "supportType"), [cheakpath]);
			if (bool) {
				return Type.createInstance(base, [data]);
			}
		}
		return null;
	}
}
