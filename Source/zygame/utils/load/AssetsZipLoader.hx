package zygame.utils.load;

import openfl.utils.ByteArray;
#if extsound
import common.media.Sound;
#else
import openfl.media.Sound;
#end
import haxe.io.Bytes;
import zygame.utils.AssetsUtils;
import zygame.zip.ZipReader;
import haxe.zip.Entry;
import haxe.io.BytesInput;
import openfl.display.BitmapData;
#if lime
import lime._internal.format.Deflate;
import lime.graphics.Image;
#end
import zygame.utils.load.TextureLoader;
import zygame.utils.StringUtils;
import zygame.display.ZBitmapData;

/**
 * 资源包载入器
 */
class AssetsZipLoader {
	private var path:String = "";

	public function new(path:String) {
		this.path = path;
	}

	public static var count:Int = 0;

	public function load(call:Zip->Void, errerCall:String->Void):Void {
		AssetsUtils.loadBytes(this.path, false).onComplete(function(bytes:Bytes):Void {
			var zip:Zip = new Zip(bytes);
			zip.name = zygame.utils.StringUtils.getName(path);
			zip.process(function(f:Float):Void {
				if (f == 1) {
					call(zip);
					call = null;
				}
			});
		}).onError(function(data:Dynamic):Void {
			errerCall(data);
			call = null;
		});
	}
}

/**
 * 压缩包功能
 */
class Zip {
	public var name:String;

	private var zip:ZipReader;

	public var entrys:Map<String, Entry>;

	private var photosConfig:Dynamic;

	public function new(bytes:Bytes) {
		var input:BytesInput = new BytesInput(bytes);
		zip = new ZipReader(input);
		entrys = new Map();
	}

	/**
	 * 读取解压后的二进制
	 * @param entry 
	 * @return Bytes
	 */
	public function readBytes(entry:Entry):Bytes {
		var bytes:Bytes = decompress(entry);
		entry.compressed = false;
		return bytes;
	}

	/**
	 * 开始解析压缩包
	 * @param call 
	 */
	public function process(call:Float->Void):Void {
		var entry:Entry = zip.next();
		if (entry != null) {
			var id:String = StringUtils.getName(entry.fileName);
			var ext:String = StringUtils.getExtType(entry.fileName);
			entrys.set(id + "." + ext, entry);
			var pro:Float = zip.progress();
			call(pro);
			// 判断是否解析结束
			if (pro == 1)
				return;
		} else {
			call(1);
			return;
		}
		// zygame.utils.Lib.setTimeout(function():Void{
		process(call); // 同步执行
		// },10);
	}

	/**
	 * Zip统一解压实现
	 * @param entry 
	 * @return Bytes
	 */
	private function decompress(entry:Entry):Bytes {
		if (!entry.compressed)
			return entry.data;
		#if haxezip
		// 使用haxe自带的官方解压
		var inf = new haxe.zip.InflateImpl(new haxe.io.BytesInput(entry.data), false, false);
		var output = new haxe.io.BytesBuffer();
		var bufsize = 1024 * 1024;
		var buf = haxe.io.Bytes.alloc(bufsize);
		while (true) {
			var len = inf.readBytes(buf, 0, bufsize);
			output.addBytes(buf, 0, len);
			if (len < bufsize) {
				break;
			}
		}
		entry.data = output.getBytes();
		#elseif deflatex
		if (entry.compressed) {
			var inflater:deflatex.Inflater = new deflatex.Inflater();
			entry.data = inflater.decompress(entry.data);
		}
		#elseif lime
		entry.data = entry.compressed ? Deflate.decompress(entry.data) : entry.data;
		#else
		if (!entry.compressed) {
			throw "Current platform don't support."
		}
		#end
		entry.compressed = false;
		return entry.data;
	}

	public function loadSound(id:String, call:Sound->Void):Void {
		var entry:Entry = entrys.get(id + ".mp3");
		entry = entry == null ? entrys.get(id + ".ogg") : entry;
		if (entry == null) {
			call(null);
			return;
		}
		var bytes = decompress(entry);
		var soundLoader:BytesSoundLoader = new BytesSoundLoader(id, ByteArray.fromBytes(bytes));
		soundLoader.onComplete(function(sound) {
			call(sound);
		});
	}

	/**
	 * 获取位图数据
	 * @return BitmapData
	 */
	public function loadBitmapData(id:String, call:BitmapData->Void = null):Void {
		var entry:Entry = entrys.get(id + ".png");
		entry = entry == null ? entrys.get(id + ".jpg") : entry;
		if (entry == null) {
			call(null);
			return;
		}
		var bytes = decompress(entry);
		var bitmapData:ZBitmapData = new ZBitmapData(0, 0, true, 0);
		#if !flash
		@:privateAccess bitmapData.__loadFromBytes(bytes).onComplete(function(bitmapData:BitmapData):Void {
			if (call != null)
				call(bitmapData);
		});
		#end
	}

	/**
	 * 获取XML配置
	 * @param id 
	 * @return Xml
	 */
	public function getXml(id:String):Xml {
		var entry:Entry = entrys.get(id + ".xml");
		if (entry == null)
			return null;
		var bytes = decompress(entry);
		var xmlconent:String = bytes.toString();
		return Xml.parse(xmlconent);
	}

	/**
	 * 获取JSON
	 * @param id 
	 * @return Dynamic
	 */
	public function getJson(id:String):Dynamic {
		var entry:Entry = entrys.get(id + ".json");
		if (entry == null)
			return null;
		var bytes = decompress(entry);
		return haxe.Json.parse(bytes.toString());
	}

	/**
	 * 根据ID获取字符串
	 * @param id 
	 * @return String
	 */
	public function getString(id:String):String {
		var entry:Entry = entrys.get(id);
		if (entry == null)
			return null;
		var bytes = decompress(entry);
		return bytes.toString();
	}

	/**
	 * 检查文件是否存在
	 * @param id 
	 * @return Bool
	 */
	public function exist(id:String):Bool {
		return entrys.exists(id);
	}

	/**
	 * 卸载Zip
	 */
	public function unload():Void {
		zip = null;
		entrys = null;
	}

	/**
	 * 获取HScript脚本实现
	 * @param id 
	 */
	public function getHScript(id:String):String {
		var entry:Entry = entrys.get(id + ".hx");
		if (entry == null)
			return null;
		var bytes = decompress(entry);
		return bytes.toString();
	}
}
