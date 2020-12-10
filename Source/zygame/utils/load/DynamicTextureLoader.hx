package zygame.utils.load;

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
	 *  @param func -
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
            this.updateProgress(_curLoadCount/_allLoadCount);
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
 * 微信小游戏无法正常使用
 * 该接口未完全实现，暂不能正常使用。
 */
class DynamicTextureAtlas extends TextureAtlas {
	public var textureAtlasName:String;

	private var pack:MaxRectsBinPack;

	public function new() {
		super(new BitmapData(2048, 2048, true, 0x0), null);
		pack = new MaxRectsBinPack(2048, 2048, false);
		_tileset = new Tileset(_rootBitmapData);
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
	}
}
