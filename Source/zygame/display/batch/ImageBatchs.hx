package zygame.display.batch;

import openfl.display.Tilemap;
import zygame.utils.load.Atlas;
import openfl.display.Tile;
import zygame.display.batch.BSprite;
import openfl.display.DisplayObject;
import zygame.display.batch.TouchImageBatchsContainer;

/**
 * Image的批处理渲染，如同Bitmap一样，无法递增点击事件
 * 注意ImageBatchs在没有TouchImageBatchs容器的情况下，是属于点击无法透穿的。
 */
class ImageBatchs extends Tilemap {
	private var _batchSprites:Atlas;

	private var _batch:BSprite;

	/**
	 * 点击触摸测试，默认为true，如果设置为false，则不再做触摸测试，并允许穿透。
	 */
	public var hitTestEnbled:Bool = true;

	/**
	 * 获取精灵图
	 * @return Atlas
	 */
	public function getAtlas():Atlas {
		return _batchSprites;
	}

	/**
	 * 使用精灵表进行批处理实现
	 * @param batchSprites 
	 * @return 
	 */
	public function new(batchSprites:Atlas, pwidth:Int = -1, pheight:Int = -1, smoothing:Bool = #if !smoothing false #else true #end) {
		if (pwidth == -1)
			pwidth = zygame.core.Start.stageWidth;
		if (pheight == -1)
			pheight = zygame.core.Start.stageHeight;
		super(pwidth, pheight, batchSprites == null ? null : batchSprites.getTileset(), smoothing);
		_batchSprites = batchSprites;
		_batch = new BSprite();
		// this.cacheAsBitmap = true;
		// 会有性能提升
		// this.tileAlphaEnabled = false;
		// this.tileBlendModeEnabled = false;
		// this.tileColorTransformEnabled = false;
		super.addTileAt(_batch, 0);
	}

	/**
	 * 添加对象到最上层
	 * @param display 
	 */
	public function addChild(display:Tile):Void {
		_batch.addChild(display);
	}

	override public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void {
		_batch.removeTiles(beginIndex, endIndex);
	}

	/**
	 * 添加对象到最上层
	 * @param display 
	 */
	public function addChildAt(display:Tile, index:Int):Void {
		_batch.addChildAt(display, index);
	}

	/**
	 * 禁用该方法
	 * @param tile 
	 * @return Tile
	 */
	override public function addTile(tile:Tile):Tile {
		throw "请使用addChild或者addChildAt方法";
		return null;
	}

	/**
	 * 禁用该方法
	 * @param tile 
	 * @return Tile
	 */
	override public function addTileAt(tile:Tile, index:Int):Tile {
		throw "请使用addChild或者addChildAt方法";
		return null;
	}

	/**
	 * 获取渲染容器
	 * @return BSprite
	 */
	public function getBSprite():BSprite {
		return _batch;
	}

	#if !flash
	/**
	 * 重写触摸事件，用于实现在TouchImageBatchsContainer状态中，允许穿透点击
	 * @param x 
	 * @param y 
	 * @param shapeFlag 
	 * @param stack 
	 * @param interactiveOnly 
	 * @param hitObject 
	 * @return Bool
	 */
	override private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		if (!hitTestEnbled)
			return false;
		if (!Std.isOfType(this.parent, TouchImageBatchsContainer))
			return super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject);
		var touchContainer:TouchImageBatchsContainer = cast this.parent;
		var tile = touchContainer.getTilePosAt(touchContainer.mouseX, touchContainer.mouseY);
		if (tile != null)
			return true;
		return false;
	}
	#end
}
