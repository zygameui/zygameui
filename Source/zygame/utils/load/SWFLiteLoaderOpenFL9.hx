package zygame.utils.load;

import openfl.Assets;
import swf.exporters.swflite.SWFLiteLibrary;

#if (openfl_swf)

/**
 * SWFLite加载器，用于加载zip压缩格式的SWF资源
 */
class SWFLiteLoaderOpenFL9 {
	
	private var _path:String;

	private var _rootPath:String;

	private var _isZip:Bool = true;

	/**
	 * 从OpenFL9开始，永远使用zip加载
	 * @param path 
	 * @param rootPath 
	 * @param isZip 
	 */
	public function new(path:String, rootPath:String = null, isZip:Bool = true):Void {
		_isZip = true;
		_path = path;
		_rootPath = rootPath;
	}


	/**
	 * 加载，并返回AssetLibrary实例
	 * @param call
	 */
	public function load(call:SWFLiteLibrary->Void, errorCall:String->Void) {
		// 加载二进制文件
		trace("开始加载：",_path);
		Assets.loadLibrary(_path).onComplete(function(swf){
			call(cast swf);
		});
	}

}

#end