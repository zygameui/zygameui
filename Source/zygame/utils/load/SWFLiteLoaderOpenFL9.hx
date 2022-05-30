package zygame.utils.load;

#if (openfl_swf && swf)

import lime.utils.AssetLibrary;
import swf.exporters.animate.AnimateLibrary;
import lime.utils.AssetBundle;
import openfl.Assets;
import swf.exporters.swflite.SWFLiteLibrary;


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
	public function load(call:AssetLibrary->Void, errorCall:String->Void) {
		// 加载二进制文件
		AssetBundle.loadFromFile(_path).onComplete(function(bundle){
			var a:AnimateLibrary = cast lime.utils.AssetLibrary.fromBundle(bundle);
			a.load().onComplete(function(a){
				call(a);
			});
		});
		// Assets.loadLibrary(_path).onComplete(function(swf){
		// 	call(cast swf);
		// });
	}

}

#end