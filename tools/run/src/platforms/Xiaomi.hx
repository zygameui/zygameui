package platforms;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import python.FileUtils;

class Xiaomi extends BuildSuper {
	public function new(args:Array<String>, dir:String) {
		super(args, dir);
		FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin/sign", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/main.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/manifest.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/package.json", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/zygameui-dom.js", dir);
		FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/pkgicon.png", dir);
	}

	override function buildAfter() {
		super.buildAfter();
		Sys.setCwd(dir);
		// 将amd移除
		var jsPath = Path.join([dir, Build.mainFileName + ".js"]);
		var content = File.getContent(jsPath);
		// 兼容小米的amd不支持的问题
		content = StringTools.replace(content, 'if(typeof define == "function" && define.amd) {', "");
		content = StringTools.replace(content, "define([], function() { return $hx_exports.lime; });", "");
		content = StringTools.replace(content, 'define.__amd = define.amd;', "");
		content = StringTools.replace(content, 'define.amd = null;\n}', "");
		// content = StringTools.replace(content, '})(typeof exports != "undefined" ? exports : typeof define == "function" && define.amd ? {} : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);', "");
		content = StringTools.replace(content, 'if(typeof define == "function" && define.__amd) {', "");
		content = StringTools.replace(content, 'define.amd = define.__amd;', "");
		content = StringTools.replace(content, 'delete define.__amd;\n}', "");

		// Final模式下
		content = StringTools.replace(content, '"function"==typeof define&&define.__amd&&(define.amd=define.__amd,delete define.__amd);', "");
		content = StringTools.replace(content, '"function"==typeof define&&define.amd&&(define([],function(){return va.lime}),define.__amd=define.amd,define.amd=null)', "");

		File.saveContent(jsPath, content);
		if (!FileSystem.exists("node_moules"))
			Sys.command(" npm install;");
		// FileUtils.copyFile(Sys.getCwd() + "Export/html5/bin/webpack-conf.js", dir + "/node_modules/quickgame-cli/lib/webpack-conf.js");
		Sys.command("npm run release;");
	}
}
