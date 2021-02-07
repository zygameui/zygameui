package zygame.loader.parser;

import zygame.utils.load.Music;
import zygame.utils.AssetsUtils;

/**
 * 加载音频解析器
 */
 @:keep class MP3Parser extends ParserBase {
	/**
	 * 检查是否支持该解析器
	 * @param data {type:"Sound",path:载入路径} 其中type支持Sound、Music等参数选项，如果不传递，则默认使用Sound
	 * @return Bool
	 */
	public static function supportType(data:Dynamic):Bool {
		var file:String = Std.is(data, String) ? data : data.path;
		return file.indexOf(".mp3") != -1 || file.indexOf(".ogg") != -1;
	}

	/**
	 * 开始载入音频
	 */
	override function process() {
		if (Std.is(getData(), String)) {
			this.setData({
				type: "Sound",
				path: getData()
			});
		}
		var file:String = getData().path;
		#if (cpp || hl)
		file = StringTools.replace(file,".mp3",".ogg");
		#end
		AssetsUtils.loadSound(file).onComplete(function(sound) {
			var type = getData().type;
			if (type == null)
				type == "Sound";
			switch (type) {
				case "Sound":
					finalAssets(AssetsType.SOUND, sound,1);
					return;
				case "Music":
					finalAssets(AssetsType.MUSIC, new Music(sound),1);
					return;
			}
			sendError("MP3 file type " + type + " is error!");
		}).onError(function(data) {
			sendError("MP3 file " + file + "载入失败！");
		});
	}
}
