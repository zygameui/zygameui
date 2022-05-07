package zygame.display.batch;

import zygame.components.ZBuilder.Builder;
import zygame.core.Start;
import zygame.core.Refresher;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.display.DisplayObjectShader;

/**
 * 显示对象
 */
class BDisplayObject extends Tile implements ITileDisplayObject implements Refresher implements zygame.mini.MiniExtend {
	/**
	 * 自定义数据，默认为null，可以作为扩展数据使用
	 */
	public var customData:Dynamic;

	/**
	 * 基础生成baseBuilder，该属性只有通过MiniEngine创建时生效。
	 */
	public var baseBuilder:Builder;

	public var mouseEnabled:Bool = true;

	public var name:String = null;

	public function new(id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0) {
		super(id, y, y, scaleX, scaleY, rotation, originX, originY);
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
	 * 获取父节点
	 * @return BDisplayObjectContainer
	 */
	@:keep
	public function getParent():BDisplayObjectContainer {
		return cast this.parent;
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

	public function scale(v:Float):Void {
		this.scaleX = v;
		this.scaleY = v;
	}
}
