package zygame.display.batch;

import openfl.events.MouseEvent;
import openfl.events.Event;
import zygame.utils.load.Atlas;
import openfl.display.Stage;
import zygame.display.TouchDisplayObjectContainer;
import zygame.display.batch.ImageBatchs;
import zygame.utils.load.TextureLoader;
import openfl.events.TouchEvent;
import openfl.display.DisplayObject;
import openfl.display.Tile;
import zygame.events.TileTouchEvent;
import zygame.display.batch.BTouchSprite;

/**
 * 实现可点击的批渲染容器，装在这里的ImageBatchs容器可支持点击被透穿
 */
@:keep
class TouchImageBatchsContainer extends TouchDisplayObjectContainer {
	public var tileAlphaEnabled(never, set):Bool;
	public var tileBlendModeEnabled(never, set):Bool;
	public var tileColorTransformEnabled(never, set):Bool;

	/**
	 * 当前点击命中的瓦片，可以在MouseEvent事件中获取到
	 */
	public var currentTouchTile:Tile;

	/**
	 * 设置为性能模式
	 */
	public var performanceMode(never, set):Bool;

	public function new(batchSprites:Atlas, pwidth:Int = -1, pheight:Int = -1) {
		super();
		if (pwidth == -1)
			pwidth = zygame.core.Start.stageWidth;
		if (pheight == -1)
			pheight = zygame.core.Start.stageHeight;
		var _imageBatchs:ImageBatchs = new ImageBatchs(batchSprites, pwidth, pheight);
		super.addChildAt(_imageBatchs, 0);
		this.mouseChildren = false;
		setTouchEvent(true);
	}

	#if flash
	@:setter(width)
	public function set_width(value:Float):Float {
		var num:Int = this.numChildren;
		for (i in 0...num) {
			this.getChildAt(i).width = value;
		}
		return value;
	}

	@:getter(height)
	public function set_height(value:Float):Float {
		var num:Int = this.numChildren;
		for (i in 0...num) {
			this.getChildAt(i).height = value;
		}
		return value;
	}
	#else
	override private function set_width(value:Float):Float {
		var num:Int = this.numChildren;
		for (i in 0...num) {
			this.getChildAt(i).width = value;
		}
		return value;
	}

	override private function set_height(value:Float):Float {
		var num:Int = this.numChildren;
		for (i in 0...num) {
			this.getChildAt(i).height = value;
		}
		return value;
	}
	#end

	/**
	 * 获取一个批量渲染的容器
	 * @return ImageBatchs
	 */
	public function getBatchs(id:Int = 0):ImageBatchs {
		return cast getChildAt(id);
	}

	/**
	 * 添加方法弃用
	 * @param display
	 * @return DisplayObject
	 */
	override public function addChild(display:DisplayObject):DisplayObject {
		throw "无法直接使用addChild添加，需要使用getBatchs().addChild方式添加";
		return null;
	}

	/**
	 * 添加方法弃用
	 * @param display
	 * @param index
	 * @return DisplayObject
	 */
	override public function addChildAt(display:DisplayObject, index:Int):DisplayObject {
		throw "无法直接使用addChild添加，需要使用getBatchs().addChild方式添加";
		return null;
	}

	/**
	 * 添加新的渲染层级
	 * @param batch
	 */
	public function addBatchs(batch:ImageBatchs):Void {
		super.addChildAt(batch, this.numChildren);
	}

	/**
	 * 鼠标/手指按下
	 * @param e
	 */
	override public function onTouchBegin(e:TouchEvent):Void {
		dispatchTileEvent(e);
	}

	/**
	 * 鼠标/手指按下
	 * @param e
	 */
	override public function onTouchMove(e:TouchEvent):Void {
		if (this.hasEventListener(TileTouchEvent.TOUCH_MOVE_TILE))
			dispatchTileEvent(e);
	}

	/**
	 * 鼠标/手指按下
	 * @param e
	 */
	override public function onTouchEnd(e:TouchEvent):Void {
		if (Std.isOfType(e.target, TouchImageBatchsContainer) && e.target == this || Std.isOfType(e.currentTarget, Stage))
			dispatchTileEvent(e);
	}

	/**
	 * 根据鼠标位置获取Tile
	 * @param posx
	 * @param posy
	 * @return Tile
	 */
	public function getTilePosAt(posx:Float, posy:Float):Tile {
		currentTouchTile = null;
		var tile:Tile = null;
		var id:Int = this.numChildren - 1;
		while (id >= 0) {
			var batch:ImageBatchs = getBatchs(id);
			tile = batch.getBSprite().getTileAtPos(posx - batch.x, posy - batch.y);
			if (tile != null) {
				currentTouchTile = tile;
				break;
			}
			id--;
		}
		return tile;
	}

	/**
	 * 统一发布Tile触摸事件
	 * @param e
	 */
	private function dispatchTileEvent(e:TouchEvent):Void {
		if (!this.mouseEnabled)
			return;
		var tile:Tile = getTilePosAt(this.mouseX, this.mouseY);
		if (tile != null) {
			if (Std.isOfType(tile, BTouchSprite)) {
				if (!Std.isOfType(e.currentTarget, Stage)) {
					var touchTile:BTouchSprite = cast tile;
					switch (e.type + "Tile") {
						case TileTouchEvent.TOUCH_BEGIN_TILE:
							touchTile.onTouchBegin(e);
						case TileTouchEvent.TOUCH_END_TILE:
							touchTile.onTouchEnd(e);
						case TileTouchEvent.TOUCH_MOVE_TILE:
							touchTile.onTouchMove(e);
					}
				}
				// 按钮应直接上发
				if (Std.isOfType(e.target, TouchImageBatchsContainer) && e.target == this) {
					this.dispatchEvent(new TileTouchEvent(e.type + "Tile", tile));
				}
			} else if (Std.isOfType(e.target, TouchImageBatchsContainer) && e.target == this) {
				this.dispatchEvent(new TileTouchEvent(e.type + "Tile", tile));
			}
		} else {}
		// 全局发布内容
		if (Std.isOfType(e.currentTarget, Stage)) {
			var num:Int = this.numChildren - 1;
			while (num >= 0) {
				this.getBatchs(num).getBSprite().dispatchTouchEvent(e);
				num--;
			}
		}
	}

	override function dispatchEvent(event:Event):Bool {
		return super.dispatchEvent(event);
	}

	function set_tileAlphaEnabled(value:Bool):Bool {
		for (i in 0...this.numChildren) {
			var batch = this.getBatchs(i);
			if (batch != null)
				batch.tileAlphaEnabled = value;
		}
		return value;
	}

	function set_tileBlendModeEnabled(value:Bool):Bool {
		for (i in 0...this.numChildren) {
			var batch = this.getBatchs(i);
			if (batch != null)
				batch.tileBlendModeEnabled = value;
		}
		return value;
	}

	function set_tileColorTransformEnabled(value:Bool):Bool {
		for (i in 0...this.numChildren) {
			var batch = this.getBatchs(i);
			if (batch != null)
				batch.tileColorTransformEnabled = value;
		}
		return value;
	}

	function set_performanceMode(value:Bool):Bool {
		this.tileAlphaEnabled = !value;
		this.tileBlendModeEnabled = !value;
		this.tileColorTransformEnabled = !value;
		return value;
	}
}
