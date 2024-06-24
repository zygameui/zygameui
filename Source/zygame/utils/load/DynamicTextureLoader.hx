package zygame.utils.load;

import openfl.geom.Rectangle;
import spine.openfl.SkeletonSprite;
import openfl.display.Sprite;
import zygame.utils.load.TextureLoader.TextureAtlas;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import zygame.utils.MaxRectsBinPack;

/**
 * 需要支持BitmapData.draw才能正常加载，请留意平台是否支持相关API
 */
class DynamicTextureLoader {
	public var textureAtlas:DynamicTextureAtlas;

	private var files:Array<String> = [];

	private var _call:DynamicTextureAtlas->Void;

	private var _errorCall:String->Void;

	private var _allLoadCount:Int = 0;

	private var _curLoadCount:Int = 0;

	private var _canError:Bool = false;

	public function new(name:String) {
		textureAtlas = new DynamicTextureAtlas();
		textureAtlas.textureAtlasName = name;
	}

	public function loadFile(pngPath:String):Void {
		if (files.indexOf(pngPath) != -1)
			return;
		_allLoadCount++;
		files.push(pngPath);
	}

	/**
	 *  开始载入
	 * @param func -
	 */
	public function load(func:DynamicTextureAtlas->Void, errorCall:String->Void, canError:Bool = false):Void {
		_call = func;
		_canError = canError;
		_errorCall = errorCall;
		next();
	}

	private function next():Void {
		if (_curLoadCount == _allLoadCount) {
			_call(textureAtlas);
			textureAtlas = null;
			this.updateProgress(_curLoadCount / _allLoadCount);
			return;
		}
		if (files.length == 0)
			return;
		var path = files.shift();
		AssetsUtils.loadBitmapData(path).onComplete((bitmapData) -> {
			textureAtlas.putImg(StringUtils.getName(path), bitmapData);
			_curLoadCount++;
			next();
		}).onError(function(msg) {
			if (_canError) {
				_curLoadCount++;
				next();
			} else if (_errorCall != null) {
				_errorCall(msg);
			}
		});
	}

	/**
	 * 更新进度
	 */
	dynamic public function updateProgress(f:Float):Void {}
}

/**
 * 动态纹理图集，允许在该图集自动追加Sprite、BitmapData等对象。
 * 注意事项：当如果纹理图集已经被使用的情况下，请不要再追加纹理对象，否则会发生异常，无法正常渲染。
 */
class DynamicTextureAtlas extends TextureAtlas {
	// 8192 4096 2048 1024
	/**
	 * 推荐使用4096，在GL渲染里，可以稳定支持4096
	 */
	// public var size:Int = 4096;

	/**
	 * 纹理集名称 
	 */
	public var textureAtlasName:String;

	/**
	 * 图集打包器
	 */
	private var pack:MaxRectsBinPack;

	/**
	 * 缩放比例
	 */
	public var scale:Float = 1;

	public function new(width:Int = 2048, height:Int = 2048) {
		var glBitmapData = new BitmapData(width, height, true, 0x0);
		// 启动GL渲染位图
		glBitmapData.disposeImage();
		super(glBitmapData, null);
		pack = new MaxRectsBinPack(width, height, false);
		_tileset = new Tileset(_rootBitmapData);
	}

	/**
	 * 将精灵追加到精灵表
	 * @param name 
	 * @param spr 
	 */
	public function putSprite(name:String, spr:Sprite):Void {
		var bounds = spr.getBounds(null);
		var ma:Matrix = new Matrix();
		ma.scale(scale, scale);
		var rect = pack.insert(Math.round(bounds.width * scale), Math.round(bounds.height * scale), FreeRectangleChoiceHeuristic.BestShortSideFit);
		if (rect == null)
			return;
		rect = rect.clone();
		ma.tx = rect.x - bounds.x * scale;
		ma.ty = rect.y - bounds.y * scale;
		_rootBitmapData.draw(spr, ma);
		// 生成可用的Frame
		var frame = pushFrame(name, rect);
		frame.frameWidth = bounds.width * scale;
		frame.frameHeight = bounds.height * scale;
		frame.frameX = bounds.x * scale;
		frame.frameY = bounds.y * scale;
	}

	/**
	 * 将位图追加到精灵表
	 * @param name
	 * @param bitmapData
	 */
	public function putImg(name:String, bitmapData:BitmapData):Void {
		var ma:Matrix = new Matrix();
		var rect = pack.insert(bitmapData.width, bitmapData.height, FreeRectangleChoiceHeuristic.BestShortSideFit);
		if (rect == null)
			return;
		rect = rect.clone();
		ma.tx = rect.x;
		ma.ty = rect.y;
		_rootBitmapData.draw(bitmapData, ma);
		ZGC.disposeBitmapData(bitmapData);
		pushFrame(name, rect);
	}

	/**
	 * 统一补帧逻辑
	 * @param name 
	 * @param rect 
	 * @return Frame
	 */
	private function pushFrame(name:String, rect:Rectangle):Frame {
		// 追加名字
		_names.push(name);
		// 生成可用的Frame
		var frame = new Frame();
		frame.x = rect.x;
		frame.y = rect.y;
		frame.width = rect.width;
		frame.height = rect.height;
		frame.parent = this;
		frame.id = _names.length - 1;
		_tileRects.set(name, frame);
		_tileset.addRect(rect);
		return frame;
	}
}
