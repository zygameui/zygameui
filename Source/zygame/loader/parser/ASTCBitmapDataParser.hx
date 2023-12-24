package zygame.loader.parser;

import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import zygame.core.Start;
import openfl.display3D.Context3D;
import lime.graphics.opengl.GL;
import lime.utils.UInt8Array;
import zygame.utils.AssetsUtils;

/**
 * 支持ASTC压缩纹理加载，目前该格式，在IOS上支持使用
 */
class ASTCBitmapDataParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".astc");
	}

	override function process() {
		AssetsUtils.loadBytes(getData()).onComplete(function(data) {
			// this.finalAssets(BITMAP, data, 1);
			trace("astc bytes loaded");
			// Read uint8Array data of file
			var width:Int = bytes.getUInt16(0x7);
			var height:Int = bytes.getUInt16(0xA);
			var uint8Array:UInt8Array = UInt8Array.fromBytes(bytes, 16);
			// Read uint8Array data of file
			// Pass 16 byte metadata

			#if (lime_opengl || lime_opengles)
			// var ext:Dynamic = GL.getExtension("GL_COMPRESSED_RGBA​_ASTC_6x6​_KHR");
			#else
			var ext:Dynamic = GL.getExtension("WEBGL_compressed_texture_astc");
			trace("ext=", ext);
			// Read Extension
			trace(ext.getSupportedProfiles());
			// TODO: Check gpu ldr support from getSupportedProfiles
			trace(ext.COMPRESSED_RGBA_ASTC_6x6_KHR);
			#end
			// TODO: Check gpu COMPRESSED_RGBA_ASTC_6x6_KHR support
			var context3D:Context3D = Start.current.stage.context3D;
			var rectangleTexture:RectangleTexture = @:privateAccess new RectangleTexture(context3D, width, height, null, false);
			GL.bindTexture(GL.TEXTURE_2D, @:privateAccess rectangleTexture.__textureID);
			#if (lime_opengl || lime_opengles)
			GL.compressedTexImage2D(GL.TEXTURE_2D, 0, 0x93B4, @:privateAccess rectangleTexture.__width, @:privateAccess rectangleTexture.__height, 0,
				uint8Array.byteLength, uint8Array);
			#elseif lime_webgl
			GL.compressedTexImage2DWEBGL(GL.TEXTURE_2D, 0, ext.COMPRESSED_RGBA_ASTC_6x6_KHR, @:privateAccess rectangleTexture.__width,
				@:privateAccess rectangleTexture.__height, 0,
				uint8Array);
			#end
			GL.bindTexture(GL.TEXTURE_2D, null);
			var bitmapData:BitmapData = BitmapData.fromTexture(rectangleTexture);
			this.finalAssets(BITMAP, bitmapData, 1);
		}).onError(function(err) {
			if (AssetsUtils.cleanCacheId(getData())) {
				// 可重试
				process();
			} else {
				this.sendError("无法加载：" + getData());
			}
		});
	}
}
