package zygame.display.batch;

import zygame.components.ZBuilder.Builder;
import openfl.display.Tile;
import zygame.core.Start;
import zygame.core.Refresher;
import openfl.display.TileContainer;
import zygame.display.batch.ITileDisplayObject;

class BDisplayObjectContainer extends TileContainer implements ITileDisplayObject implements Refresher implements zygame.mini.MiniExtend {
	/**
	 * 自定义绑定数据
	 */
	public var customData:Dynamic;

	/**
	 * 基础生成baseBuilder，该属性只有通过MiniEngine创建时生效。
	 */
	public var baseBuilder:Builder;

	public var mouseEnabled:Bool = true;

	public var name:String = null;

	public function new():Void {
		super();
	}

	public function onInit():Void {
		if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onInit");
			if (call != null)
				call();
		}
	}

	public function onFrame() {
		if (this.baseBuilder != null) {
			var call = this.baseBuilder.getFunction("onFrame");
			if (call != null)
				call();
		}
	}

	public function setFrameEvent(isFrame:Bool):Void {
		if (isFrame)
			Start.current.addToUpdate(this);
		else
			Start.current.removeToUpdate(this);
	}

	/**
	 * 获取实际宽度（原图尺寸，旋转不计算）
	 */
	public var curWidth(get, never):Float;

	private function get_curWidth():Float {
		return this.width;
	}

	/**
	 * 获取实际高度（原图尺寸，旋转不计算）
	 */
	public var curHeight(get, never):Float;

	private function get_curHeight():Float {
		return this.height;
	}

	public function toString():String {
		return Type.getClassName(Type.getClass(this));
	}

	/**
	 * 添加对象到最上层
	 * @param display
	 */
	public function addChild(display:Tile):Void {
		super.addTile(display);
		if (Std.is(display, BDisplayObjectContainer)) {
			cast(display, BDisplayObjectContainer).onInit();
		} else if (Std.is(display, BDisplayObject)) {
			cast(display, BDisplayObject).onInit();
		}
	}

	/**
	 * 添加对象到最上层
	 * @param display
	 */
	public function addChildAt(display:Tile, index:Int):Void {
		super.addTileAt(display, index);
		if (Std.is(display, BSprite))
			cast(display, BSprite).onInit();
	}

	public function removeChild(display:Tile):Void {
		super.removeTile(display);
	}

	/**
	 *  经过了缩放计算的舞台宽度
	 *  @return Float
	 */
	public function getStageWidth():Float {
		return zygame.core.Start.stageWidth;
	}

	/**
	 *  经过了缩放计算的舞台高度
	 *  @return Float
	 */
	public function getStageHeight():Float {
		return zygame.core.Start.stageHeight;
	}

	/**
	 * 获取父节点
	 * @return BDisplayObjectContainer
	 */
	public function getParent():BDisplayObjectContainer {
		return cast this.parent;
	}
}
