package zygame.utils.load;

import zygame.components.ZBuilder;
import zygame.loader.parser.ASTCBitmapDataParser;
import openfl.display.BitmapData;
import zygame.utils.AssetsUtils.BitmapDataLoader;

class ASTCBitmapDataLoader extends BitmapDataLoader {
	override function onComplete(call:BitmapData->Void):BitmapDataLoader {
		_onCompleteCall = call;
		var astcParser = new ASTCBitmapDataParser(this.path);
		astcParser.out = (a, b, c, d) -> {
			if (_onCompleteCall != null)
				_onCompleteCall(c);
			_onCompleteCall = null;
		}
		astcParser.error = (msg) -> {
			if (loadTimes < AssetsUtils.failTryLoadTimes) {
				// 重试
				ZLog.warring("重载：" + path + "," + loadTimes);
				loadTimes++;
				Lib.setTimeout(onComplete, 3000, [call]);
			} else if (callError != null)
				callError("无法加载" + path);
		}
		astcParser.process();
		return this;
	}
}
