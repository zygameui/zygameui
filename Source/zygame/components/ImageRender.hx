package zygame.components;

import openfl.display.Bitmap;
#if zimage_v2
import openfl.display.DisplayObject;
import haxe.Exception;
import openfl.display.Sprite;
import openfl.display.GraphicsShader;
import openfl.geom.Matrix;
import openfl.Vector;
import zygame.utils.load.Frame;
import openfl.display.BitmapData;
import openfl.geom.Point;

/**
 * 图片渲染器
 */
class ImageRender extends Sprite {
	private var __isS9Draw:Bool = false;

	private var __width:Null<Float> = null;

	private var __height:Null<Float> = null;

	private var __data:Dynamic;

	public var smoothing:Bool = true;

	#if zimage_v2_bitmap_draw
	private var __bitmapRender:Bitmap;
	#end

	/**
	 * 获得位图的实际大小
	 */
	public function getFrameSize():{width:Float, height:Float} {
		if (__data is Frame) {
			return {width: cast(__data, Frame).width, height: cast(__data, Frame).height};
		} else if (__data is BitmapData) {
			return {width: cast(__data, BitmapData).width, height: cast(__data, BitmapData).height};
		}
		return {width: 0, height: 0};
	}

	private function __beginBitmapFill(data:BitmapData):Void {
		if (this.shader != null && shader is GraphicsShader) {
			// TODO 这样的话，非GraphicsShader的着色器就没有办法使用了
			// var gShader = new CloneGraphicsShader(this.shader);
			// gShader.data = this.shader.data;
			// if (gShader.bitmap != null)
			// if (gShader.data.openfl_Texture != null)
			// 	gShader.data.openfl_Texture.input = data;
			var graphicsShader = cast(shader, GraphicsShader);
			graphicsShader.bitmap.input = data;
			graphicsShader.bitmap.filter = __isS9Draw ? NEAREST : (this.smoothing ? LINEAR : NEAREST);
			this.graphics.beginShaderFill(shader);
		} else {
			this.graphics.beginBitmapFill(data, null, true, __isS9Draw ? false : this.smoothing);
		}
	}

	public function draw(data:Dynamic, width:Null<Float>, height:Null<Float>):Void {
		this.graphics.clear();
		__isS9Draw = false;
		__width = width;
		__height = height;
		__data = data;
		#if zimage_v2_bitmap_draw
		__bitmapRender?.parent?.removeChild(__bitmapRender);
		#end
		if (data is BitmapData) {
			var bitmap:BitmapData = data;
			#if zimage_v2_bitmap_draw
			if (__bitmapRender == null) {
				__bitmapRender = new Bitmap();
			}
			this.addChild(__bitmapRender);
			__bitmapRender.bitmapData = bitmap;
			#else
			__beginBitmapFill(data);
			this.graphics.drawQuads(new Vector(4, false, [0., 0., bitmap.width, bitmap.height]));
			#end
			return;
		} else if (data is Frame) {
			this.scaleX = this.scaleY = 1;
			var frame:Frame = data;
			if (frame.scale9frames != null) {
				__isS9Draw = true;
				__beginBitmapFill(frame.parent.getRootBitmapData());
				// 九图渲染
				var quads:Vector<Float> = new Vector();
				var transform:Vector<Float> = new Vector();
				var m = new Matrix();
				var lefttop = frame.scale9frames[0];
				var righttop = frame.scale9frames[2];
				var leftbottom = frame.scale9frames[6];
				var rightbottom = frame.scale9frames[8];
				var center = frame.scale9frames[4];
				var wScale = (width - lefttop.width - righttop.width) / center.width;
				var hScale = (height - lefttop.height - leftbottom.height) / center.height;
				for (index => pFrame in frame.scale9frames) {
					switch index {
						case 0:
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左上
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx);
							transform.push(m.ty);
						case 1:
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 中上
							m.scale(wScale, 1);
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + lefttop.width);
							transform.push(m.ty);
						case 2:
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 右上
							m.identity();
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + (width - righttop.width));
							transform.push(m.ty);
						case 3:
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左中
							m.identity();
							m.scale(1, hScale);
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx);
							transform.push(m.ty + lefttop.height);
						case 4:
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 居中
							m.identity();
							m.scale(wScale, hScale);
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + lefttop.width);
							transform.push(m.ty + lefttop.height);
						case 5:
							// 右中
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左中
							m.identity();
							m.scale(1, hScale);
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + width - righttop.width);
							transform.push(m.ty + lefttop.height);
						case 6:
							// 下左
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左上
							m.identity();
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx);
							transform.push(m.ty + height - leftbottom.height);
						case 7:
							// 下中
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左上
							m.identity();
							m.scale(wScale, 1);
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + leftbottom.width);
							transform.push(m.ty + height - leftbottom.height);
						case 8:
							// 下左
							quads.push(pFrame.x);
							quads.push(pFrame.y);
							quads.push(pFrame.width);
							quads.push(pFrame.height);
							// 左上
							m.identity();
							transform.push(m.a);
							transform.push(m.b);
							transform.push(m.c);
							transform.push(m.d);
							transform.push(m.tx + width - rightbottom.width);
							transform.push(m.ty + height - leftbottom.height);
						default:
							break;
					}
				}
				this.graphics.drawQuads(quads, null, transform);
			} else {
				__beginBitmapFill(frame.parent.getRootBitmapData());
				var m = this.transform.matrix;
				this.graphics.drawQuads(new Vector(4, false, [frame.x, frame.y, frame.width, frame.height]), null,
					new Vector(6, false, [m.a, m.b, m.c, m.d, m.tx, m.ty]));
			}
		}
		this.graphics.endFill();
		if (!__isS9Draw) {
			if (width != null)
				super.width = width;
			if (height != null)
				super.height = height;
		}
	}

	override function set_width(value:Float):Float {
		if (__isS9Draw) {
			__width = value;
			draw(__data, __width, __height);
			return value;
		}
		return super.set_width(value);
	}

	override function set_height(value:Float):Float {
		if (__isS9Draw) {
			__height = value;
			draw(__data, __width, __height);
			return value;
		}
		return super.set_height(value);
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
#end
