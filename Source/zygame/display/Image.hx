package zygame.display;

import zygame.shader.engine.ZShader;
import openfl.filters.ShaderFilter;
import zygame.shader.ColorShader;
import openfl.display.Shader;
import zygame.display.DisplayObjectContainer;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import zygame.utils.FPSUtil;
import openfl.geom.Rectangle;
import openfl.display.Tilemap;
import zygame.utils.load.Frame;
import zygame.display.batch.BImage;
import openfl.display.DisplayObject;
import openfl.display.Tile;
import zygame.display.ZBitmapData;
import zygame.utils.load.TextureLoader;
import zygame.display.batch.BScale9Image;

class Image extends DisplayObjectContainer {
	/**
	 * MapliveScene创建时可用
	 */
	public var assetsId:String = null;

	/**
	 * 是否直接使用位图渲染
	 */
	public var isBitmapDataDraw:Bool = false;

	/**
	 * 位图渲染器
	 */
	private var _bitmap:Bitmap;

	private var _tilemap:Tilemap;
	private var _curFrame:Frame;
	private var _curImg:BImage;
	private var _scale9:BScale9Image;
	private var _scale9Img:Array<Tile>;

	private var _setWidth:Bool = false;
	private var _width:Float = 0;

	private var _setHeight:Bool = false;
	private var _height:Float = 0;

	private var _scale9Grid:Rectangle;

	public var bitmapData(get, set):Dynamic;

	/**
	 * 设置图片是否平滑
	 */
	public var smoothing(get, set):Bool;

	private var _smoothing:Bool = #if !smoothing false #else true #end;

	private function set_smoothing(bool:Bool):Bool {
		_smoothing = bool;
		var diplsy = getDisplay();
		if (diplsy != null) {
			if (Std.isOfType(diplsy, Tilemap))
				cast(diplsy, Tilemap).smoothing = bool;
			else if (Std.isOfType(diplsy, Bitmap))
				cast(diplsy, Bitmap).smoothing = bool;
		}
		return bool;
	}

	private function get_smoothing():Bool {
		return _smoothing;
	}

	private function set_bitmapData(bitmapData:Dynamic):Dynamic {
		var isFrameRect:Bool = false;
		if (bitmapData == null) {
			if (_tilemap != null)
				_tilemap.visible = false;
			if (_bitmap != null)
				_bitmap.visible = false;
		} else if (Std.isOfType(bitmapData, BitmapData)) {
			isBitmapDataDraw = true;
			if (_tilemap != null)
				_tilemap.visible = false;
			// 位图渲染处理
			if (_bitmap == null) {
				_bitmap = new Bitmap(bitmapData, null, true);
				this.addChild(_bitmap);
			} else {
				_bitmap.visible = true;
				_bitmap.bitmapData = bitmapData;
			}
			#if (mac || !smoothing)
			_bitmap.smoothing = false;
			#else
			_bitmap.smoothing = true;
			#end
		} else if (Std.isOfType(bitmapData, Frame)) {
			_curFrame = bitmapData;
			isBitmapDataDraw = false;
			if (_bitmap != null)
				_bitmap.visible = false;
			var frame:Frame = cast bitmapData;
			// 精灵表单渲染
			if (_tilemap == null) {
				_tilemap = new Tilemap(0, 0, frame.parent.getTileset(), #if !smoothing false #else true #end);
				this.addChild(_tilemap);
				_curImg = new BImage();
				_tilemap.addTile(_curImg);
			} else {
				_tilemap.tileset = frame.parent.getTileset();
				_tilemap.visible = true;
			}
			_curImg.setFrame(frame);
			isFrameRect = frame.frameWidth != 0 || frame.frameHeight != 0;
			if (isFrameRect) {
				this._tilemap.width = frame.width + Math.abs(frame.frameX);
				this._tilemap.height = frame.height + Math.abs(frame.frameY);
				if (this._tilemap.width < frame.frameWidth)
					this._tilemap.width = frame.frameWidth;
				if (this._tilemap.height < frame.frameHeight)
					this._tilemap.height = frame.frameHeight;
			} else {
				this._tilemap.width = frame.width;
				this._tilemap.height = frame.height;
			}

			if (_curFrame.scale9rect != null)
				_scale9Grid = _curFrame.scale9rect;
			if (_scale9Grid != null) {
				updateScale9();
			}
		}
		if (_setWidth)
			this.width = this._width;
		if (_setHeight)
			this.height = this._height;
		alignPivot(vAlign, hAlign);
		if (isFrameRect && !isBitmapDataDraw) {
			if (_curFrame.frameX < 0) {
				this._curImg.originX = 0;
				this._tilemap.x += _curFrame.frameX;
			}
			if (_curFrame.frameY < 0) {
				this._curImg.originY = 0;
				this._tilemap.y += _curFrame.frameY;
			}
		}
		updateShader();
		return bitmapData;
	}

	/**
	 * 更新刷新9宫格
	 */
	private function updateScale9():Void {
		if (_tilemap == null)
			return;
		if (_scale9 != null)
			_scale9.visible = false;
		if (_curImg.curFrame.scale9frames != null) {
			// 默认支持九宫格
			if (_scale9 == null) {
				_scale9 = new BScale9Image(_curFrame);
				this._tilemap.addTile(_scale9);
			}
			if (_scale9.curFrame != _curFrame)
				_scale9.setFrame(_curFrame);
			_scale9.width = _width;
			_scale9.height = _height;
			_curImg.visible = false;
			_scale9.visible = true;
			return;
		}
		if (_scale9Grid == null) {
			this._tilemap.scale9Grid = _scale9Grid;
			this._tilemap.tileset = _curFrame.parent.getTileset();
			_curImg.visible = true;
			return;
		}
		if (_scale9Grid != this._tilemap.scale9Grid) {
			this._tilemap.scale9Grid = _scale9Grid;
			// 更新tileset配置
			this._tilemap.tileset = _curFrame.getScale9GirdTileset(_scale9Grid);
		}
		_curImg.visible = false;
		if (_scale9Img == null) {
			// 初始化9宫格图实现
			_scale9Img = [];
			for (i in 0...9) {
				_scale9Img.push(new Tile(i));
				// if(i < 2)
				_tilemap.addTile(_scale9Img[i]);
			}
		}

		for (i in 0...9) {
			var tile:Tile = _scale9Img[i];
			var left:Float = _scale9Grid.x;
			var right:Float = _curFrame.width - _scale9Grid.x - _scale9Grid.width;
			var bottom:Float = _curFrame.height - _scale9Grid.y - _scale9Grid.height;
			var top:Float = _scale9Grid.y;
			var cwidth:Float = _width - left - right;
			var cheight:Float = _height - top - bottom;
			var pscaleX:Float = cwidth / _tilemap.tileset.getRect(i).width;
			var pscaleY:Float = cheight / _tilemap.tileset.getRect(i).height;

			switch (i) {
				case 0:
				// 左上
				case 1:
					// 中上
					tile.x = left;
					tile.scaleX = pscaleX;
				case 2:
					// 右上
					tile.x = _width - right;
				case 3:
					// 左中
					tile.y = top;
					tile.scaleY = pscaleY;
				case 4:
					// 居中
					tile.x = left;
					tile.y = top;
					tile.scaleX = pscaleX;
					tile.scaleY = pscaleY;
				case 5:
					// 右中
					tile.x = _width - right;
					tile.y = top;
					tile.scaleY = pscaleY;
				case 6:
					// 下左
					tile.y = _height - bottom;
				case 7:
					// 中下
					tile.x = left;
					tile.y = _height - bottom;
					tile.scaleX = pscaleX;
				case 8:
					// 右下
					tile.x = _width - right;
					tile.y = _height - bottom;
			}
		}
	}

	private function get_bitmapData():Dynamic {
		if (_bitmap == null && _tilemap == null)
			return null;
		if (isBitmapDataDraw)
			return _bitmap.bitmapData;
		return _curFrame;
	}

	/**
	 * 创建一个图片
	 * @param bitmapData 支持Frame、BitmapData渲染
	 */
	public function new(bitmapData:Dynamic = null) {
		super();
		this.bitmapData = bitmapData;
		this.mouseChildren = false;
		if (Std.isOfType(bitmapData, BitmapData)) {
			this.width = cast(bitmapData, BitmapData).width;
			this.height = cast(bitmapData, BitmapData).height;
		} else if (Std.isOfType(bitmapData, Frame)) {
			var frame:Frame = cast(bitmapData, Frame);
			this.width = frame.frameWidth > frame.width ? frame.frameWidth : frame.width;
			this.height = frame.frameHeight > frame.height ? frame.frameHeight : frame.height;
		}
	}

	override public function onInit():Void {}

	public var pivotX(get, set):Float;

	private function get_pivotX():Float {
		if (isBitmapDataDraw)
			return -_bitmap.x;
		else
			return -_tilemap.x;
	}

	private function set_pivotX(f:Float):Float {
		if (isBitmapDataDraw)
			_bitmap.x = -f;
		else
			_tilemap.x = -f;
		return get_pivotX();
	}

	public var pivotY(get, set):Float;

	private function get_pivotY():Float {
		if (isBitmapDataDraw)
			return -_bitmap.y;
		else
			return -_tilemap.y;
	}

	private function set_pivotY(f:Float):Float {
		if (isBitmapDataDraw)
			_bitmap.y = -f;
		else
			_tilemap.y = -f;
		return get_pivotY();
	}

	override public function alignPivot(v:String = null, h:String = null):Void {
		super.alignPivot(v, h);
		if (_bitmap == null && _tilemap == null)
			return;
		zygame.utils.Align.alignDisplay(isBitmapDataDraw ? _bitmap : _tilemap, v, h);
	}

	private var _animation:Array<Dynamic>;
	private var _fps:FPSUtil;
	private var _loop:Bool = false;
	private var _call:Void->Void;
	private var _index:Int = 0;
	private var _isPlay:Bool = false;

	/**
	 * 播放动画
	 * @param array 播放循序
	 * @param fps 帧率
	 * @param loop 是否循环
	 * @param call 结束时是否回调
	 */
	public function playImages(array:Array<Dynamic>, fps:Int, loop:Bool, call:Void->Void = null):Void {
		_animation = array;
		_fps = new FPSUtil(fps);
		_loop = loop;
		_call = call;
		_index = 0;
		bitmapData = array[0];
		setFrameEvent(true);
		_isPlay = true;
	}

	override public function onRemoveToStage():Void {
		super.onRemoveToStage();
		setFrameEvent(false);
	}

	override public function onAddToStage():Void {
		super.onRemoveToStage();
		if (_isPlay)
			setFrameEvent(_isPlay);
	}

	/**
	 * 实现动画逻辑
	 */
	override public function onFrame():Void {
		if (_fps != null && _fps.update()) {
			_index++;
			if (_index >= _animation.length) {
				_index = 0;
				if (_call != null)
					_call();
				if (_loop == false) {
					setFrameEvent(false);
					_isPlay = false;
					return;
				}
			}
			bitmapData = _animation[_index];
		}
	}

	#if flash @:setter(height)
	public #else override private #end function set_height(height:Float):Float {
		this._setHeight = true;
		this._height = height;
		if (_bitmap == null && _tilemap == null)
			return 0;
		if (isBitmapDataDraw && _bitmap != null)
			_bitmap.height = height;
		else if (_tilemap != null) {
			_tilemap.height = height;
			_curImg.height = height;
		}
		updateScale9();
		return height;
	}

	#if flash @:setter(width)
	public #else override private #end function set_width(width:Float):Float {
		this._setWidth = true;
		this._width = width;
		if (_bitmap == null && _tilemap == null)
			return 0;
		if (isBitmapDataDraw && _bitmap != null)
			_bitmap.width = width;
		else if (_tilemap != null) {
			_tilemap.width = width;
			_curImg.width = width;
		}
		updateScale9();
		return width;
	}

	#if flash @:getter(width)
	public #else override private #end function get_width():Float {
		if (_setWidth)
			return Math.abs(_width * scaleX);
		return super.width;
	}

	#if flash @:getter(height)
	public #else override private #end function get_height():Float {
		if (_setHeight)
			return Math.abs(_height * scaleY);
		return super.height;
	}

	/**
	 * 获取显示对象
	 * @return Bitmap
	 */
	public function getDisplay():DisplayObject {
		if (_bitmap == null && _tilemap == null)
			return null;
		return isBitmapDataDraw ? _bitmap : _tilemap;
	}

	/**
	 * 设置九宫格格式
	 * @param rect
	 */
	public function setScale9Grid(rect:Rectangle):Void {
		_scale9Grid = rect;
		if (isBitmapDataDraw && _bitmap != null) {
			// 自动将对象转换
			var textureAtlas:TextureAtlas = TextureAtlas.createTextureAtlasByOne(_bitmap.bitmapData);
			bitmapData = textureAtlas.getBitmapDataFrame("img");
		}
		if (_bitmap != null)
			_bitmap.scale9Grid = rect;
		if (_tilemap != null) {
			updateScale9();
		}
	}

	/**
	 * 清理绘制的瓦片
	 */
	public function clearDrawTiles():Void {
		if (_tilemap != null) {
			_tilemap.removeTiles();
			_tilemap.addTile(_curImg);
		}
	}

	/**
	 * 指定位置绘制tile
	 * @param frame
	 * @param x
	 * @param y
	 * @param width
	 * @param height
	 */
	public function drawTile(frame:Frame, x:Float, y:Float, width:Float, height:Float):Void {
		if (_tilemap != null) {
			var img:BImage = new BImage(frame);
			_tilemap.addTile(img);
			img.x = x;
			img.y = y;
			img.width = width;
			img.height = height;
		}
	}

	/**
	 * 优化着色器设置
	 * @param value
	 * @return Shader
	 */
	override function set_shader(value:Shader):Shader {
		var display = getDisplay();
		if (display != null)
			display.shader = value;
		updateShader();
		return value;
	}

	override function get_shader():Shader {
		var display = getDisplay();
		if (display == null)
			return null;
		return display.shader;
	}

	private function updateShader():Void {
		var display = getDisplay();
		if (display == null)
			return;
		if (Std.isOfType(display.shader, ZShader)) {
			cast(display.shader, ZShader).updateFrame(_curFrame);
		}
	}
}
