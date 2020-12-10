package zygame.loader.parser;

import zygame.utils.load.FntLoader.FntData;
import zygame.utils.AssetsUtils;
import openfl.display.BitmapData;

/**
 * 纹理载入
 * {
 * imgpath:图片路径
 * fntpath:纹理解析路径
 * path:路径识别
 * }
 */
 @:keep class FntParser extends ParserBase {
    public static function supportType(data:Dynamic):Bool {
		return true;
    }

    private var _bitmapData:BitmapData;

    override function process() {
        if(_bitmapData == null){
            //开始载入纹理
            var path:String = getData().imgpath;
            AssetsUtils.loadBitmapData(path).onComplete(function(data){
                _bitmapData = data;
                this.finalAssets(PROGRESS,null,0.5);
                this.contiune();
            }).onError(function(err){
                sendError("无法载入" + path);
            });
        }
        else{
            //开始载入纹理
            var path:String = getData().fntpath;
            AssetsUtils.loadText(path).onComplete(function(text){
                this.finalAssets(FNT,new FntData(_bitmapData,Xml.parse(text),path),1);
                _bitmapData = null;
            }).onError(function(err){
                sendError("无法载入" + path);
            });
        }
    }
}