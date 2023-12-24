package zygame.loader.parser;

import openfl.utils.ByteArray;
import haxe.io.Bytes;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import zygame.core.Start;
import openfl.display3D.Context3D;
import lime.graphics.opengl.GL;
import lime.utils.UInt8Array;
import zygame.utils.AssetsUtils;

/**
 * 支持ASTC压缩纹理加载
 * ```haxe
 * var assets = new ZAssets();
 * assets.loadFile("./texture.astc");
 * ```
 */
@:access(openfl.display3D.textures.RectangleTexture)
class ASTCBitmapDataParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return StringTools.endsWith(data, ".astc");
	}

	/**
	 * 检查是否使用了Zlib压缩
	 * @param bytes 
	 * @return Bool
	 */
	private function isZlibFile(bytes:Bytes):Bool {
		var v1 = bytes.get(0);
		var v2 = bytes.get(1);
		if (v1 == 120) {
			switch (v2) {
				case 218:
					return true;
			}
		}
		return false;
	}

	override function process() {
		AssetsUtils.loadBytes(getData()).onComplete(function(bytes) {
			// 检测是否为zlib压缩
			if (isZlibFile(bytes)) {
				var byteArray = ByteArray.fromBytes(bytes);
				byteArray.uncompress();
			}
			// 读取ASTC纹理的格式 4x4 6x6等信息
			var blockX:Int = bytes.get(0x4);
			var blockY:Int = bytes.get(0x5);
			var isSRGBA = false;
			var astcFormat = ASTCFormat.getFormat(blockX, blockY, 1, isSRGBA);
			var format = isSRGBA ? 'COMPRESSED_SRGB8_ALPHA8_ASTC_${blockX}x${blockY}_KHR' : 'COMPRESSED_RGBA_ASTC_${blockX}x${blockY}_KHR';
			// 纹理的尺寸
			var width:Int = bytes.getUInt16(0x7);
			var height:Int = bytes.getUInt16(0xA);
			// 图片压缩纹理内容，头信息永远为16位，因此只需要偏移16位后的二进制
			var bodyBytes = bytes.sub(16, bytes.length - 16);
			var uint8Array:UInt8Array = UInt8Array.fromBytes(bodyBytes);
			// WEBGL 检查是否支持压缩配置
			var ext:Dynamic = GL.getExtension(#if (lime_opengl || lime_opengles) "KHR_texture_compression_astc_ldr" #else "WEBGL_compressed_texture_astc" #end);
			if (ext == null) {
				this.sendError("Don't support ASTC extension.");
				return;
			}
			// 这里要检查是否支持ASTC纹理配置等支持
			var value = Reflect.getProperty(ext, format);
			if (value == null) {
				this.sendError('Don\'t support ASTC$format extension.');
				return;
			}
			// trace("extensions:", GL.getSupportedExtensions());
			var context3D:Context3D = Start.current.stage.context3D;
			var rectangleTexture:RectangleTexture = new RectangleTexture(context3D, width, height, null, false);
			GL.bindTexture(GL.TEXTURE_2D, rectangleTexture.__textureID);
			rectangleTexture.__format = astcFormat;
			#if (lime_opengl || lime_opengles)
			GL.compressedTexImage2D(GL.TEXTURE_2D, 0, rectangleTexture.__format, rectangleTexture.__width, rectangleTexture.__height, 0,
				uint8Array.byteLength, uint8Array);
			#elseif lime_webgl
			GL.compressedTexImage2DWEBGL(GL.TEXTURE_2D, 0, rectangleTexture.__format, rectangleTexture.__width, rectangleTexture.__height, 0, uint8Array);
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

/**
 * ASTC纹理支持的所有枚举
 */
enum abstract ASTCFormat(UInt) to UInt from UInt {
	var COMPRESSED_RGBA_ASTC_4x4_KHR = 0x93B0;
	var COMPRESSED_RGBA_ASTC_5x4_KHR = 0x93B1;
	var COMPRESSED_RGBA_ASTC_5x5_KHR = 0x93B2;
	var COMPRESSED_RGBA_ASTC_6x5_KHR = 0x93B3;
	var COMPRESSED_RGBA_ASTC_6x6_KHR = 0x93B4;
	var COMPRESSED_RGBA_ASTC_8x5_KHR = 0x93B5;
	var COMPRESSED_RGBA_ASTC_8x6_KHR = 0x93B6;
	var COMPRESSED_RGBA_ASTC_8x8_KHR = 0x93B7;
	var COMPRESSED_RGBA_ASTC_10x5_KHR = 0x93B8;
	var COMPRESSED_RGBA_ASTC_10x6_KHR = 0x93B9;
	var COMPRESSED_RGBA_ASTC_10x8_KHR = 0x93BA;
	var COMPRESSED_RGBA_ASTC_10x10_KHR = 0x93BB;
	var COMPRESSED_RGBA_ASTC_12x10_KHR = 0x93BC;
	var COMPRESSED_RGBA_ASTC_12x12_KHR = 0x93BD;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR = 0x93D0;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR = 0x93D1;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR = 0x93D2;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR = 0x93D3;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR = 0x93D4;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR = 0x93D5;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR = 0x93D6;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR = 0x93D7;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR = 0x93D8;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR = 0x93D9;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR = 0x93DA;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR = 0x93DB;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR = 0x93DC;
	var COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR = 0x93DD;

	/**
	 * 获得ASTC压缩格式
	 * @param x 
	 * @param y 
	 * @param z 
	 * @return ASTCFormat
	 */
	public static function getFormat(x:Int, y:Int, z:Int = 1, isAlpha8:Bool = false):ASTCFormat {
		if (isAlpha8) {
			if (x == 4 && y == 4)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR;
			else if (x == 5 && y == 4)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR;
			else if (x == 5 && y == 5)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR;
			else if (x == 6 && y == 5)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR;
			else if (x == 6 && y == 6)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR;
			else if (x == 8 && y == 5)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR;
			else if (x == 8 && y == 6)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR;
			else if (x == 8 && y == 8)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR;
			else if (x == 10 && y == 5)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR;
			else if (x == 10 && y == 6)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR;
			else if (x == 10 && y == 8)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR;
			else if (x == 10 && y == 10)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR;
			else if (x == 12 && y == 10)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR;
			else if (x == 12 && y == 12)
				return COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR;
		} else {
			if (x == 4 && y == 4)
				return COMPRESSED_RGBA_ASTC_4x4_KHR;
			else if (x == 5 && y == 4)
				return COMPRESSED_RGBA_ASTC_5x4_KHR;
			else if (x == 5 && y == 5)
				return COMPRESSED_RGBA_ASTC_5x5_KHR;
			else if (x == 6 && y == 5)
				return COMPRESSED_RGBA_ASTC_6x5_KHR;
			else if (x == 6 && y == 6)
				return COMPRESSED_RGBA_ASTC_6x6_KHR;
			else if (x == 8 && y == 5)
				return COMPRESSED_RGBA_ASTC_8x5_KHR;
			else if (x == 8 && y == 6)
				return COMPRESSED_RGBA_ASTC_8x6_KHR;
			else if (x == 8 && y == 8)
				return COMPRESSED_RGBA_ASTC_8x8_KHR;
			else if (x == 10 && y == 5)
				return COMPRESSED_RGBA_ASTC_10x5_KHR;
			else if (x == 10 && y == 6)
				return COMPRESSED_RGBA_ASTC_10x6_KHR;
			else if (x == 10 && y == 8)
				return COMPRESSED_RGBA_ASTC_10x8_KHR;
			else if (x == 10 && y == 10)
				return COMPRESSED_RGBA_ASTC_10x10_KHR;
			else if (x == 12 && y == 10)
				return COMPRESSED_RGBA_ASTC_12x10_KHR;
			else if (x == 12 && y == 12)
				return COMPRESSED_RGBA_ASTC_12x12_KHR;
		}
		return 0;
	}
}
