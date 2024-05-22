package zygame.components.renders.opengl;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import zygame.utils.MaxRectsBinPack;
import openfl.display.Sprite;
import zygame.utils.load.Atlas;
import openfl.text.TextField;
import zygame.components.base.ZConfig;
import openfl.text.TextFormat;
import openfl.display.BitmapData;

/**
 * 文本渲染缓存纹理，一般在渲染位图为TextField
 */
class TextFieldContextBitmapData {
	/**
	 * 纹理
	 */
	public var bitmapData:BitmapData;

	/**
	 * 打包器
	 */
	public var rects:MaxRectsBinPack;

	/**
	 * 图集
	 */
	private var __atlas:TextFieldAtlas;

	private var __textFormat:TextFormat;

	/**
	 * 文本渲染器
	 */
	private var __textField:TextField;

	private var __offestX:Int = 0;

	private var __offestY:Int = 0;

	public function new(size:Int = 36, offestX:Int = 0, offestY:Int = 0) {
		this.__offestX = offestX;
		this.__offestY = offestY;
		bitmapData = new BitmapData(2048, 2048, true, 0x0);
		rects = new MaxRectsBinPack(2048, 2048, false);
		bitmapData.disposeImage();
		__textFormat = new TextFormat(ZConfig.fontName, size, 0xffffff);
		__textField = new TextField();
		__atlas = new TextFieldAtlas(bitmapData);
	}

	/**
	 * 渲染文本
	 * @param text 
	 */
	public function drawText(text:String):Void {
		// 过滤重复的文本
		var caches:Array<String> = [];
		var chars = text.split("");
		for (char in chars) {
			if (char == " ")
				continue;
			if (__atlas.getTileFrame(char.charCodeAt(0)) == null)
				if (!caches.contains(char)) {
					caches.push(char);
				}
		}
		if (caches.length == 0)
			return;
		text = caches.join(" ");
		__textField.text = text;
		__textField.width = 2048;
		__textField.wordWrap = false;
		__textField.setTextFormat(__textFormat);
		var pakRect = rects.insert(Std.int(__textField.textWidth + __offestX * 3), Std.int(__textField.textHeight + __offestY * 3),
			FreeRectangleChoiceHeuristic.BestShortSideFit);
		var m = new Matrix();
		m.translate(pakRect.x, pakRect.y);
		bitmapData.draw(__textField, m);
		for (i in 0...__textField.text.length) {
			var char = __textField.text.charAt(i);
			if (char == " ")
				continue;
			var rect = __textField.getCharBoundaries(i);
			rect.x += pakRect.x;
			rect.y += pakRect.y;
			rect.x -= __offestX;
			rect.width += __offestX * 2;
			rect.y -= __offestY;
			rect.height += __offestY * 2;
			this.__atlas.pushChar(char, rect, Std.int(rect.width - __offestX * 2));

			// 测试
			#if text_debug
			var spr = new Sprite();
			spr.graphics.beginFill(0xff0000, 0.5);
			spr.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			spr.graphics.endFill();
			bitmapData.draw(spr);
			#end
		}
	}

	/**
	 * 清空文字纹理渲染
	 */
	public function clear():Void {
		bitmapData.fillRect(bitmapData.rect, 0x0);
		__atlas = new TextFieldAtlas(bitmapData);
		rects = new MaxRectsBinPack(2048, 2048, false);
	}

	/**
	 * 获得纹理
	 * @return Atlas
	 */
	public function getAtlas():Atlas {
		return __atlas;
	}
}
