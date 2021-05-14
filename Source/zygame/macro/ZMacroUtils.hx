package zygame.macro;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Http;
import haxe.Json;
import zygame.utils.StringUtils;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
#if macro
import sys.FileSystem;
import sys.io.File;
#end

/**
 * 宏工具
 */
class ZMacroUtils {

	/**
	 * 编译时的时间
	 * @return String
	 */
	macro public static function buildDateTime():ExprOf<String> {
		return toExpr(Date.now().toString());
	}

	/**
	 * 创建编译时间，浮点型
	 * @return ExprOf<Float>
	 */
	macro public static function buildDateTimeFloat():ExprOf<Float> {
		return toExpr(Date.now().getTime());
	}

	/**
	 * 生成出运行时的路径
	 * @param path
	 * @return ExprOf<String>
	 */
	macro public static function buildPath(path:String):ExprOf<String> {
		return toExpr(resolvePath(path));
	}

	/**
	 * 更改某个路径下的所有文件的后缀
	 * @param path 
	 * @param nowext 
	 * @param changeext 
	 */
	macro public static function renameExt(path:String,nowext:String,changeext:String):Dynamic{
		var files = FileSystem.readDirectory(path);
		for (file in files) {
			if(!FileSystem.isDirectory(file)){
				if(StringTools.endsWith(file,nowext)){
					FileSystem.rename(path + "/" + file,path + "/" + StringTools.replace(file,nowext,changeext));
				}
			}
		}
		return macro "";
	}

	/**
	 * 生成出实时编译的HTTP内容
	 * @param url
	 * @param data
	 * @return ExprOf<String>
	 */
	macro public static function buildHttpContent(url:String, data:String):ExprOf<String> {
		return toExpr(getHttpContent(url, data));
	}

	/**
	 * 读取文件内容
	 * @param path
	 * @return ExprOf<String>
	 */
	macro public static function readFileContent(path:String):ExprOf<String> {
		return toExpr(readFile(path));
	}

	/**
	 * 读取文件二进制内容
	 * @param path
	 * @return ExprOf(Bytes)
	 */
	macro public static function readFileContentBase64(path:String):ExprOf<String> {
		var base64 = Base64.encode(readFileBytes(path));
		return toExpr(base64);
	}

	/**
	 * 获取定义值
	 * @return ExprOf<Map<String,String>>
	 */
	macro public static function getDefines():ExprOf<String> {
		var obj = {};
		var map = Context.getDefines();
		for (key => value in map) {
			Reflect.setProperty(obj, key, value);
		}
		return toExpr(Json.stringify(obj));
	}

	/**
	 * 将某个文件夹压缩成Zip资源包，并返回对应的加载路径。路径仅使用于Export，HTML5、Android、IOS平台
	 * （注意，目前仅支持HTML5平台，其他平台未经过测试）
	 * @param path
	 */
	macro public static function buildZipAssets(path:String, rootDir:String = null):ExprOf<String> {
		#if macro
		var curpath:String = path;
		#if html5
		path = "Export/html5/bin/" + path;
		#end
		if (rootDir == null)
			rootDir = "";
		else if (rootDir.lastIndexOf("/") == -1)
			rootDir += "/";
		path = Sys.getCwd() + path;
		if (FileSystem.exists(path)) {
			var p = Context.resolvePath(path);
			var curCwd = Sys.getCwd();
			Sys.setCwd(p);
			Sys.command("zip -q -r ../" + rootDir + StringUtils.getName(p) + ".zip .");
			Sys.setCwd(curCwd);
			deleteDir(p);
		}
		return toExpr(rootDir + curpath + ".zip");
		#end
	}

	/**
	 * 加载嵌入式纹理资源
     * @param assets 指向当前命名
	 * @param img 指向当前项目根目录的图片文件
	 * @param xml 指向当前项目根目录的XML文件
	 * @param isAtf 是否使用ATF解压缩
	 */
	macro static public function loadEmbedTextures(assets:Dynamic, img:String, xml:String, isAtf:Bool):Dynamic {
		var base64 = Base64.encode(readFileBytes(img));
		return macro $assets.loadBase64Textures($v{base64},$v{readFile(xml)},$v{img},$v{isAtf});
	}

	/**
	 * 加载嵌入式Spine纹理资源
     * @param assets 指向当前命名
	 * @param img 指向当前项目根目录的图片文件
	 * @param xml 指向当前项目根目录的XML文件
	 * @param isAtf 是否使用ATF解压缩
	 */
	 macro static public function loadSpineEmbedTextures(assets:Dynamic, texpath:Array<String>, json:String):Dynamic {
		var list:Array<{path:String,base64data:String}> = [];
		for (s in texpath) {
			list.push({
				path:s,
				base64data: Base64.encode(readFileBytes(s))
			});
		}
		return macro $assets.loadBase64SpineTextAlats($v{list},$v{readFile(json)},$v{json});
	}

	#if macro
	static function getHttpContent(url:String, data:String, post:Bool = true, contentType:String = "application/json;charset=UTF-8"):String {
		var http:Http = new Http(url);
        http.onStatus = function(code:Int):Void{
            if(code != 200)
                throw "URL getContent fail:" + code;   
        };
		http.setHeader("Content-Type", contentType);
		http.setPostData(data);
		http.request(post);
		return http.responseData;
	}

	static function deleteDir(dir:String):Void {
		var list = FileSystem.readDirectory(dir);
		for (file in list) {
			var filePath = dir + "/" + file;
			if (FileSystem.isDirectory(filePath))
				deleteDir(filePath);
			else
				FileSystem.deleteFile(filePath);
		}
		FileSystem.deleteDirectory(dir);
	}

	static function toExpr(v:Dynamic) {
		return Context.makeExpr(v, Context.currentPos());
	}

	static function resolvePath(path:String) {
		path = Sys.getCwd() + path;
		var p = Context.resolvePath(path);
		if (sys.FileSystem.exists(p)) {
			return p;
		} else
			throw "Path " + p + " is not exists!";
	}

	static function readFile(path:String) {
        #if ios
        path = "../../../../" + path;
        #end
		if (sys.FileSystem.exists(path)) {
			return sys.io.File.getContent(path);
		} else {
			trace ("警告：" + path + "文件不存在，当前目录：" + Sys.getCwd());
			return null;
		}
	}

	static function readFileBytes(path:String) {
        #if ios
        path = "../../../../" + path;
        #end
		if (sys.FileSystem.exists(path)) {
			return sys.io.File.getBytes(path);
		} else {
			trace ("警告：" + path + "文件不存在，当前目录：" + Sys.getCwd());
			return null;
		}
	}
	#end
}
