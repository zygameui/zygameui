package zygame.utils;

import haxe.crypto.Md5;
import openfl.display.BitmapData;

/**
 * 缓存Assets
 */
class CacheAssets extends ZAssets {
	private var _loading:Map<String, Array<BitmapData->Void>> = [];

	/**
	 * 加载缓存图片资源
	 * @param url 
	 * @param cb 
	 */
	public function loadBitmapData(url:String, cb:BitmapData->Void):Void {
		if (_loading.exists(url)) {
			// 已经在加载中，直接列入回调
			_loading.get(url).push(cb);
			return;
		}
		var imageName = Md5.encode(url);
		if (this.getBitmapData(imageName) != null) {
			cb(this.getBitmapData(imageName));
		} else {
			// 需要加载
			_loading.set(url, [cb]);
			AssetsUtils.loadBitmapData(url).onComplete(function(bitmapData) {
				for (index => value in _loading.get(url)) {
					value(bitmapData);
				}
				this.setBitmapData(imageName, bitmapData);
				_loading.remove(url);
			}).onError(function(data) {
				_loading.remove(url);
			});
		}
	}
}
