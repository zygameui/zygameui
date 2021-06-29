package zygame.components;

import zygame.core.Start;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.BitmapData;

/**
 * 当ZScene调用了lock后，会产生一个ZLockScene替换掉当前的场景
 */
class ZLockScene extends ZScene {
	private var _lockBitmapData:BitmapData;
	private var _lockBitmap:Bitmap;
	private var _scene:ZScene;

	override function onInit() {
		super.onInit();
	}

	public function lockBitmapScene(display:DisplayObject):Void {
		if (_lockBitmap == null) {
			_lockBitmap = new Bitmap();
			_lockBitmapData = new BitmapData(Std.int(Start.current.getStageWidth()), Std.int(Start.current.getStageHeight()));
			@:privateAccess _lockBitmapData.readable = false;
			_lockBitmapData.draw(display);
			_lockBitmap.bitmapData = _lockBitmapData;
			this.addChild(_lockBitmap);
			for (i in 0...this.numChildren) {
				var d = this.getChildAt(i);
				if (d != _lockBitmap) {
					d.visible = false;
				}
			}
		}
	}

	override function onSceneRelease() {
		super.onSceneRelease();
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		if (_lockBitmapData != null) {
			_lockBitmapData.dispose();
			_lockBitmapData = null;
			_lockBitmap = null;
		}
		_scene = null;
	}

	override function lock(display:DisplayObject) {}

	override function unlock() {}
}
