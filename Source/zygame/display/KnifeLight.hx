package zygame.display;

#if zygame
import zygame.display.TouchDisplayObjectContainer;
import zygame.display.DisplayObjectContainer;
import zygame.core.Start;
import zygame.utils.FrameEngine;
#end
import openfl.display.DisplayObject;
import openfl.Vector;
import openfl.events.TouchEvent;
import haxe.Timer;
import openfl.display.BitmapData;

/**
 * 刀光效果
 */
class KnifeLight extends #if !zygame openfl.display.Sprite #else TouchDisplayObjectContainer #end {
	private var bitmap:BitmapData;

	/**
	 * 刀光的粗细
	 */
	public var size:Float = 20;

	/**
	 * 持续时间
	 */
	public var duration:Float = 0.15;

	/**
	 * 刀光封装
	 * @param bitmapData 渲染位图
	 * @param size 刀光尺寸
	 * @param duration 持续时长
	 */
	public function new(bitmapData:BitmapData, size:Float = 20, duration:Float = 0.15) {
		super();
		this.size = size;
		this.duration = duration;
		bitmap = bitmapData;

		tracks = [];
		touched = [];

		this.setFrameEvent(true);
	}

	private var tracks:Array<List<VolatilePoint>>;
	private var touched:Array<Null<Bool>>;

	override function onRemoveToStage() {
		super.onRemoveToStage();
		this.setFrameEvent(false);
	}

	override public function onFrame() {
		var gfx = this.graphics;
		gfx.clear();
		var now = Timer.stamp();
		var vertices:Vector<Float> = new Vector<Float>(0, false);
		var indices:Vector<Int> = new Vector<Int>(0, false);
		var uvtData:Vector<Float> = new Vector<Float>(0, false);
		var numpt = 0;
		for (track in tracks) {
			if (track == null)
				continue;
			var head:VolatilePoint = track.first();

			while ((head = track.first()) != null && now - head.birth > duration)
				track.pop();
			if (track.length < 4)
				continue;
			var prev:VolatilePoint = null, tail:VolatilePoint = track.last();
			var px1 = head.x,
				py1 = head.y,
				px2:Null<Float> = null,
				py2:Null<Float> = null;
			for (p in track) {
				if (prev != null) {
					var angle = Math.atan2(p.y - prev.y, p.x - prev.x) + Math.PI / 2;
					var len = (1 - (now - p.birth) / duration) * size;
					var x1 = p.x + len * Math.cos(angle),
						y1 = p.y + len * Math.sin(angle);
					var x2 = p.x + len * Math.cos(angle + Math.PI),
						y2 = p.y + len * Math.sin(angle + Math.PI);

					if (p == tail) {
						vertices.push(p.x);
						vertices.push(p.y);
						vertices.push(px1);
						vertices.push(py1);
						vertices.push(px2);
						vertices.push(py2);
						indices.push(numpt);
						indices.push(numpt + 1);
						indices.push(numpt + 2);
						uvtData.push(1);
						uvtData.push(0.5);
						uvtData.push(0.75);
						uvtData.push(0);
						uvtData.push(0.75);
						uvtData.push(1);
						numpt += 3;
					} else if (px2 != null) { // normal
						vertices.push(x1);
						vertices.push(y1);
						vertices.push(x2);
						vertices.push(y2);
						vertices.push(px1);
						vertices.push(py1);
						vertices.push(px2);
						vertices.push(py2);
						indices.push(numpt);
						indices.push(numpt + 2);
						indices.push(numpt + 3);
						indices.push(numpt);
						indices.push(numpt + 1);
						indices.push(numpt + 3);
						uvtData.push(0.75);
						uvtData.push(0);
						uvtData.push(0.75);
						uvtData.push(1);
						uvtData.push(0.25);
						uvtData.push(0);
						uvtData.push(0.25);
						uvtData.push(1);
						numpt += 4;
					} else { // prev is head
						vertices.push(x1);
						vertices.push(y1);
						vertices.push(x2);
						vertices.push(y2);
						vertices.push(px1);
						vertices.push(py1);
						indices.push(numpt);
						indices.push(numpt + 1);
						indices.push(numpt + 2);
						uvtData.push(0.25);
						uvtData.push(0);
						uvtData.push(0.25);
						uvtData.push(1);
						uvtData.push(0);
						uvtData.push(0.5);
						numpt += 3;
					}
					px1 = x1;
					py1 = y1;
					px2 = x2;
					py2 = y2;
				}
				prev = p;
			}
		}
		gfx.beginBitmapFill(bitmap, null, true, true);
		gfx.drawTriangles(vertices, indices, uvtData);
		gfx.endFill();
	}

	/**
	 * 触摸效果
	 * @param touchId 
	 * @param mouseX 
	 * @param mouseY 
	 */
	public function onTouch(touchId:Int, mouseX:Float, mouseY:Float) {
		// var touchId = e.touchPointID;
		// if (touched[touchId] == null) {
		// 	touched[touchId] = false;
		// }
		// if (e.type == TouchEvent.TOUCH_BEGIN) {
		// 	touched[touchId] = true;
		// 	return; // 手指接触屏幕会同时触发TOUCH_BEGIN和TOUCH_MOVE事件，因此这里返回即可
		// } else if (e.type == TouchEvent.TOUCH_END) {
		// 	touched[touchId] = false;
		// }
		// if (!touched[touchId])
		// return;
		var track:List<VolatilePoint>;
		if ((track = tracks[touchId]) == null) {
			track = tracks[touchId] = new List<VolatilePoint>();
		}
		var last = track.last(), dx:Float, dy:Float;
		if (last != null && (dx = mouseX - last.x) * dx + (dy = mouseY - last.y) * dy < 1)
			return; // 防止两点距离过于接近，可能导致计算误差
		track.add(new VolatilePoint(mouseX, mouseY)); // add to end
	}

	#if !flash
	/**
	 * 重构触摸事件，无法触发触摸的问题
	 * @param x
	 * @param y
	 * @param shapeFlag
	 * @param stack
	 * @param interactiveOnly
	 * @param hitObject
	 * @return Bool
	 */
	override private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		// var bool:Bool = super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject);
		// if (bool == true) {
		// return true;
		// }
		if (this.mouseEnabled == false || this.visible == false)
			return false;
		if (this.getBounds(stage).contains(x, y)) {
			if (stack != null)
				stack.push(this);
			return true;
		}
		return false;
	}
	#end
}

/**
 * 触摸点
 */
class VolatilePoint {
	public var x:Float;
	public var y:Float;
	public var birth:Float;

	public function new(inX:Float, inY:Float) {
		x = inX;
		y = inY;
		birth = Timer.stamp(); // 出生时刻以秒为单位，因为是浮点数，所以精度足够
	}
}
