package ogg;

import sys.io.File;
import js.node.ChildProcess;
import sys.FileSystem;

class Mp3ToOgg {
	private static var thridCounts:Int = 0;

	private static var maxThridCounts:Int = 30;

	private static var okCounts:Int = 0;

	private static var cache:Array<String> = [];

	static function main() {
		toOgg(Sys.args()[0]);
		while (true) {
			if (thridCounts == 0) {
				break;
			}
		}
	}

	public static function toOgg(dir:String):Void {
		// trace("开始处理：", dir);
		var files = FileSystem.readDirectory(dir);
		for (index => value in files) {
			var path = dir + "/" + value;
			if (FileSystem.isDirectory(path)) {
				toOgg(path);
			} else if (value.indexOf(".mp3") != -1) {
				ffmpeg(path);
			}
		}
	}

	public static function ffmpeg(path:String):Void {
		if (thridCounts >= maxThridCounts) {
			cache.push(path);
			// trace("列入缓存：", path);
			return;
		}
		var saveTo = StringTools.replace(path, ".mp3", ".ogg");
		if (FileSystem.exists(saveTo)) {
			return;
		}
		thridCounts++;
		trace(Sys.programPath(), Sys.getCwd());
		var command = "./tools/run/ffmpeg " + " -y -i \"" + path + "\" -c:a libvorbis -q:a 2 \"" + saveTo + "\"";
		ChildProcess.exec(command, function(e, i, o) {
			okCounts++;
			if (e != null) {
				thridCounts--;
				throw e;
			}
			trace("已完成" + path + "(" + okCounts + ")");
			thridCounts--;
			var path = cache.shift();
			if (path != null) {
				// trace("开始缓存任务：", path);
				ffmpeg(path);
			}
		});
	}
}
