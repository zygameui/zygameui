package zygame.display.batch;

import openfl.display.GraphicsShader;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.display.Tile;
import openfl.display.TileContainer;
import openfl.display.Shape;

/**
 * 可将ImageBatchs，通过`drawQuads`进行渲染出来，请注意，不支持透明度
 */
class QuadsBatchs extends Shape {
	private var _tileset:Tileset;

	private var _quads:Vector<Float>;

	private var _transform:Vector<Float>;

	private var _uvs:Vector<Float>;

	/**
	 * 通过`ImageBatchs`渲染成`drawQuads`
	 * @param batch 
	 */
	public function drawImageBatch(batch:ImageBatchs):Void {
		_tileset = batch.getAtlas().getTileset();
		_quads = new Vector(0, false);
		_transform = new Vector(0, false);
		this.graphics.clear();
		if (this.shader != null) {
			cast(shader, GraphicsShader).bitmap.input = _tileset.bitmapData;
			this.graphics.beginShaderFill(shader);
		} else {
			this.graphics.beginBitmapFill(_tileset.bitmapData);
		}
		for (i in 0...batch.numTiles) {
			var tile = batch.getTileAt(i);
			renderTileContainer(tile, 0, 0);
		}
		this.render();
	}

	public function render():Void {
		this.graphics.clear();
		if (this.shader != null) {
			cast(shader, GraphicsShader).bitmap.input = _tileset.bitmapData;
			this.graphics.beginShaderFill(shader);
		} else {
			this.graphics.beginBitmapFill(_tileset.bitmapData);
		}
		this.graphics.drawQuads(_quads, null, _transform);
	}

	/**
	 * 渲染瓦片容器
	 * @param tileContainer 
	 */
	public function renderTileContainer(tile:Tile, tx:Float, ty:Float):Void {
		if (tile.width == 0 || tile.height == 0 || tile.alpha == 0 || !tile.visible)
			return;
		if (tile is TileContainer) {
			var container:TileContainer = cast tile;
			for (i in 0...container.numTiles) {
				var nextTile = container.getTileAt(i);
				renderTileContainer(nextTile, tx + tile.x, ty + tile.y);
			}
		} else {
			var rect = _tileset.getRect(tile.id);
			_quads.push(rect.x);
			_quads.push(rect.y);
			_quads.push(rect.width);
			_quads.push(rect.height);
			_transform.push(tile.matrix.a);
			_transform.push(tile.matrix.b);
			_transform.push(tile.matrix.c);
			_transform.push(tile.matrix.d);
			_transform.push(tile.matrix.tx + tx);
			_transform.push(tile.matrix.ty + ty);
		}
	}
}
