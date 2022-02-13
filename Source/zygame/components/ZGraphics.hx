package zygame.components;

import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import haxe.Json;
import haxe.crypto.Base64;
import zygame.utils.load.TextureLoader.TextureAtlas;
import openfl.geom.Point;
import openfl.Vector;
import openfl.display.Sprite;
import zygame.display.DisplayObjectContainer;
import zygame.utils.load.Frame;
import openfl.utils.ByteArray;

/**
 * 通用绘制类，可在小游戏平台中支持使用，仅支持基础的线条，矩形绘制
 */
class ZGraphics extends DisplayObjectContainer {
	private var draw:Sprite;
	private var vertices:Vector<Float> = new Vector();
	private var indices:Vector<Int> = new Vector();
	private var uv:Vector<Float> = new Vector();
	private var ids:Array<String> = [];

	private var eraseVertices:Vector<Float> = new Vector();
	private var eraseIds:Array<String> = [];
	private var eraseUv:Vector<Float> = new Vector();
	private var eraseIndexs:Array<Int> = [];

	private var indicesID:Int = 0;
	private var maxIndicesID:Int = 0;
	private var lineStyle:Int;
	private var moveToPos:Point;
	private var isLineTo:Bool = false;
	// 绘制命令，用于优化撤销命令
	private var commend:Array<String> = [];

	/**
	 * 笔触大小
	 */
	public var lineSize:Int = 1;

	private var textureAtlas:TextureAtlas;
	private var curFrame:Frame;
	private var frameName:String;

	/**
	 * 最大可绘制区域宽度，0为不限制，默认为0
	 */
	public var maxDrawWidth:Int = 0;

	/**
	 * 最大可绘制区域高度，0为不限制，默认为0
	 */
	public var maxDrawHeight:Int = 0;

	/**
	 * 构造一个自定义绘制对象
	 */
	public function new() {
		super();
		draw = this;
	}

	/**
	 * 清空所有绘制指令
	 */
	public function clear():Void {
		draw.graphics.clear();
		indicesID = 0;
		maxIndicesID = 0;
		vertices.splice(0, vertices.length);
		indices.splice(0, indices.length);
		ids.splice(0, ids.length);
		uv.splice(0, uv.length);
		eraseVertices.splice(0, eraseVertices.length);
		eraseUv.splice(0, eraseUv.length);
		eraseIds.splice(0, eraseIds.length);
		eraseIndexs.splice(0, eraseIndexs.length);
		commend.splice(0, commend.length);
	}

	/**
	 * 撤销上一次绘制内容或擦除内容
	 */
	public function withdraw() {
		while (true) {
			if (getLastCommend() == "moveTo")
				commend.pop();
			else
				break;
		}
		if (getLastCommend() == "erase") {
			for (i in 0...commend.length) {
				var c = commend.pop();
				if (c != "erase")
					break;
				// 撤销橡皮檫操作
				var index:Int = eraseIndexs.pop();
				pushStringVector(eraseIds.splice(eraseVertices.length - 1, 1), ids, index);
				pushVector(eraseVertices.splice(eraseVertices.length - 1 * 8, 1 * 8), vertices, index);
				pushVector(eraseUv.splice(eraseUv.length - 1 * 8, 1 * 8), uv, index);
			}
		} else if (getLastCommend() != "lineTo") {
			commend.pop();
			uv.splice(vertices.length - 8, 8);
			ids.splice(Std.int((vertices.length - 8) / 8), 1);
			vertices.splice(vertices.length - 8, 8);
		} else {
			for (i in 0...commend.length) {
				var c = commend.pop();
				if (c != "lineTo")
					break;
				ids.splice(Std.int((vertices.length - 8) / 8), 1);
				vertices.splice(vertices.length - 8, 8);
				uv.splice(uv.length - 8, 8);
			}
		}
		fillEnd();
	}

	/**
	 * 画布是否已经绘制
	 */
	public function isNull():Bool {
		return vertices.length != 0;
	}

	/**
	 * 准备填充的精灵表单信息
	 * @param texture 精灵表对象
	 */
	public function beginTextureAtlas(texture:TextureAtlas):Void {
		draw.graphics.clear();
		this.textureAtlas = texture;
	}

	/**
	 * 准备渲染的帧
	 * @param name
	 */
	public function beginFrameByName(name:String):Void {
		frameName = name;
		curFrame = textureAtlas.getBitmapDataFrame(name);
	}

	/**
	 * 绘制三角形
	 * @param x1 第一个点X
	 * @param y1 第一个点Y
	 * @param x2 第二个点X
	 * @param y2 第二个点Y
	 * @param x3 第三个点X
	 * @param y3 第三个点Y
	 */
	public function drawTriangles(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Void {
		this.pushFrameUVs();
		this.pushPoint(x1, y1);
		this.pushPoint(x2, y2);
		this.pushPoint(x3, y3);
		this.pushPoint(x3, y3);
		pushRectIndices();
	}

	/**
	 * 绘制矩形
	 * @param x 坐标X
	 * @param y 坐标Y
	 * @param width 宽度
	 * @param height 高度
	 */
	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void {
		this.pushFrameUVs();
		this.pushPoint(x, y);
		this.pushPoint(x + width, y);
		this.pushPoint(x, y + height);
		this.pushPoint(x + width, y + height);
		pushRectIndices();
		commend.push("drawRect");
	}

	/**
	 * 判断此处是否有绘制过的内容
	 * @param x 检测X轴
	 * @param y 检测Y轴
	 * @param size 检测比例
	 */
	public function checkIn(x:Float, y:Float, size:Int = 5):Bool {
		var i:Int = 0;
		while (true) {
			var isErase:Bool = cheakIn(i, x, y, size);
			// 判断是否可以擦除
			if (isErase) {
				return true;
			}
			i += 8;
			if (i >= vertices.length)
				break;
		}
		return false;
	}

	/**
	 * 擦除指定区域的绘制内容，该擦除功能会自动呈现，不需要调用fillEnd接口
	 * @param x 擦除X轴
	 * @param y 擦除Y轴
	 * @param size 擦除检测区域
	 */
	public function erase(x:Float, y:Float, size:Int = 5):Void {
		var i:Int = 0;
		while (true) {
			var isErase:Bool = cheakIn(i, x, y, size);
			// 判断是否可以擦除
			if (isErase) {
				eraseIndexs.push(i);
				pushVector(vertices.splice(i, 8), eraseVertices);
				pushVector(uv.splice(i, 8), eraseUv);
				pushStringVector(ids.splice(Std.int(i / 8), 1), eraseIds);
				commend.push("erase");
			}
			i += 8;
			if (i >= vertices.length)
				break;
		}
		fillEnd();
	}

	private function pushVector(v1:Vector<Float>, v2:Vector<Float>, index:Int = -1):Void {
		for (i in 0...v1.length) {
			index == -1 ? v2.push(v1[i]) : v2.insertAt(index + i, v1[i]);
		}
	}

	private function pushStringVector(v1:Array<String>, v2:Array<String>, index:Int = -1):Void {
		for (i in 0...v1.length) {
			index == -1 ? v2.push(v1[i]) : v2.insert(index + i, v1[i]);
		}
	}

	private function cheakIn(index:Int, x:Float, y:Float, size:Float):Bool {
		var pointA:Point = new Point();
		pointA.x = vertices[index];
		pointA.y = vertices[index + 1];
		var pointB:Point = new Point();
		pointB.x = vertices[index + 6];
		pointB.y = vertices[index + 7];
		if (pointToLineDistance(pointA, pointB, new Point(x, y)) < size)
			return true;
		return false;
	}

	/**
	 * 计算点与线之间的距离
	 * @param p1 线坐标A
	 * @param p2 线坐标B
	 * @param p3 检测点
	 * @return Float
	 */
	private function pointToLineDistance(p1:Point, p2:Point, p3:Point):Float {
		var xDelta:Float = p2.x - p1.x;
		var yDelta:Float = p2.y - p1.y;
		if ((xDelta == 0) && (yDelta == 0)) {
			p2.x += 1;
			p2.y += 1;
			xDelta = 1;
			yDelta = 1;
		}
		var u:Float = ((p3.x - p1.x) * xDelta + (p3.y - p1.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
		var closestPoint:Point;
		if (u < 0) {
			closestPoint = p1;
		} else if (u > 1) {
			closestPoint = p2;
		} else {
			closestPoint = new Point(p1.x + u * xDelta, p1.y + u * yDelta);
		}
		return Point.distance(closestPoint, p3);
	}

	// /**
	//  * 绘制多边形
	//  * @param points
	//  */
	// public function drawPolygon(points:Array<Float>):Void
	// {
	//     if(points.length < 6)
	// 		throw "这不是一个有效的三角形！";
	// 	var uvindex:Int = 0;
	// 	var uvs:Array<Float> = curFrame.getUv();
	// 	var index:Int = 0;
	//     while (index < points.length) {
	// 		this.pushUV(uvs[uvindex],uvs[uvindex] + 1);
	// 		this.pushPoint(points[index],points[index + 1]);
	// 		index += 2;
	// 		uvindex += 2;
	// 		if(uvindex >= 8)
	// 			uvindex = 0;
	// 		this.pushIndices();
	//     }
	// }

	/**
	 * 移动初始绘制点
	 * @param x x轴
	 * @param y y轴
	 */
	public function moveTo(x:Float, y:Float):Void {
		isLineTo = false;
		if (moveToPos == null)
			moveToPos = new Point(x, y);
		else {
			moveToPos.x = x;
			moveToPos.y = y;
		}
		commend.push("moveTo");
	}

	/**
	 * 线绘制到某个位置
	 * @param x x轴
	 * @param y y轴
	 */
	public function lineTo(x:Float, y:Float):Void {
		drawLine(moveToPos.x, moveToPos.y, x, y, 0, 0);
		if (isLineTo) {
			// 修正连续画线时的拼接
			vertices[vertices.length - 10] = vertices[vertices.length - 4];
			vertices[vertices.length - 9] = vertices[vertices.length - 3];
			vertices[vertices.length - 14] = vertices[vertices.length - 8];
			vertices[vertices.length - 13] = vertices[vertices.length - 7];
		}
		moveToPos.x = x;
		moveToPos.y = y;
		isLineTo = true;
		commend.push("lineTo");
	}

	/**
	 * 绘制线，请注意不与上个线连接，这是个单独的线条
	 * @param startX 开始x轴
	 * @param startY 开始y轴
	 * @param endX 结束x轴
	 * @param endY 结束y轴
	 * @param offectX 偏移x轴
	 * @param offectY 偏移y轴
	 */
	public function drawLine(startX:Float, startY:Float, endX:Float, endY:Float, offectX:Float = 0, offectY:Float = 0):Void {
		var pointA:Point = new Point();
		pointA.x = startX;
		pointA.y = startY;
		var pointB:Point = new Point();
		pointB.x = endX;
		pointB.y = endY;
		// 计算出距离
		var d:Float = Point.distance(pointA, pointB);
		// 计算出坐标弧度
		var a:Float = Math.atan2((pointB.y - pointA.y), (pointB.x - pointA.x));
		var cos:Float = Math.cos(a);
		var sin:Float = Math.sin(a);
		// 计算偏移的线粗
		startX += sin * lineSize;
		startY -= cos * lineSize;
		this.pushFrameUVs(offectX, offectY);
		this.pushPoint(startX, startY);
		this.pushPoint(startX + d * cos, startY + d * sin);
		startX -= sin * lineSize * 2;
		startY += cos * lineSize * 2;
		this.pushPoint(startX, startY);
		this.pushPoint(startX + d * cos, startY + d * sin);
		pushRectIndices();
		if (getLastCommend() != "moveTo" && getLastCommend() != "lineTo")
			commend.push("drawLine");
	}

	private function getLastCommend():String {
		if (commend.length > 0)
			return commend[commend.length - 1];
		return null;
	}

	/**
	 * 绘制结束一次，需要调用该方法之后，才能正常渲染显示
	 */
	public function fillEnd():Void {
		draw.graphics.clear();
		draw.graphics.beginBitmapFill(textureAtlas.getRootBitmapData(), null, true, true);
		draw.graphics.drawTriangles(vertices, indices, uv);
		draw.graphics.endFill();
	}

	private function pushFrameUVs(pxf:Float = 0, pyf:Float = 0):Void {
		if (curFrame == null) {
			this.pushUV(0, 0);
			this.pushUV(0, 0);
			this.pushUV(0, 0);
			this.pushUV(0, 0);
			ids.push(null);
		} else {
			// 修正UV
			var uvs:Array<Float> = curFrame.getUv();
			var px:Float = pxf == 0 ? 0 : (uvs[6] - uvs[0]) * pxf;
			var py:Float = pyf == 0 ? 0 : (uvs[7] - uvs[1]) * pyf;
			this.pushUV(uvs[0] + px, uvs[1] + py);
			this.pushUV(uvs[2] - px, uvs[3] + py);
			this.pushUV(uvs[4] + px, uvs[5] - py);
			this.pushUV(uvs[6] - px, uvs[7] - py);
			ids.push(frameName);
		}
	}

	private function pushUV(x:Float, y:Float):Void {
		uv.push(x);
		uv.push(y);
	}

	private function pushPoint(x:Float, y:Float):Void {
		if (maxDrawWidth != 0) {
			if (x < 0)
				x = 0;
			else if (x > maxDrawWidth)
				x = maxDrawWidth;
		}
		if (maxDrawHeight != 0) {
			if (y < 0)
				y = 0;
			else if (y > maxDrawHeight)
				y = maxDrawHeight;
		}
		vertices.push(Std.int(x));
		vertices.push(Std.int(y));
	}

	/**
	 * 追加一个矩形顶点
	 */
	public function pushRectIndices():Void {
		this.pushIndices();
		this.pushIndices();
		this.endIndices();
	}

	private function pushIndices():Void {
		indices.push(indicesID);
		indices.push(indicesID + 1);
		indices.push(indicesID + 2);
		indicesID++;
		if (maxIndicesID < indicesID + 2)
			maxIndicesID = indicesID + 2;
	}

	private function endIndices():Void {
		indicesID = maxIndicesID;
	}

	/**
	 * 将所有的绘画指令转换为Ojbect
	 * @return Dynamic
	 */
	private function toObject():Dynamic {
		return {
			vertices: vertices,
			ids: ids
		};
	}

	/**
	 * 导出为Base64格式，会经过BytesArray压缩，后续需要还原画面时，可以使用`formBase64`方法进行恢复：
	 * ```haxe
	 * ZGraphics.formBase64(atlas,base64data);
	 * ```
	 * @return String
	 */
	public function toBase64():String {
		var data:String = Json.stringify(toObject());
		var b:ByteArray = new ByteArray();
		b.writeUTFBytes(data);
		b.compress();
		var base64 = Base64.encode(b, true);
		b.clear();
		return base64;
	}

	/**
	 * 转换Base64格式为绘图
	 * @param atlas 渲染纹理
	 * @param base64 base64绘制数据
	 * @return ZGraphics
	 */
	public static function formBase64(atlas:TextureAtlas, base64:String):ZGraphics {
		var bytes = ByteArray.fromBytes(Base64.decode(base64));
		bytes.uncompress();
		var data:String = bytes.readUTFBytes(bytes.length);
		var obj:Dynamic = Json.parse(data);
		var g = new ZGraphics();
		g.beginTextureAtlas(atlas);
		// 追加坐标 C++异常
		var vertices:Array<Float> = obj.vertices;
		for (f in vertices) {
			g.vertices.push(f);
		}
		// 追加顶点
		var len:Int = Std.int(vertices.length / 8);
		for (i in 0...len) {
			g.pushRectIndices();
		}
		// 追加UVs
		var ids:Array<String> = obj.ids;
		for (idname in ids) {
			g.beginFrameByName(idname);
			g.pushFrameUVs();
		}
		// 最终绘制
		g.fillEnd();
		return g;
	}

	/**
	 * 获取自身已绘制的区域大小
	 * @return Rectangle
	 */
	public function getLocalBounds():Rectangle {
		var rect = new Rectangle();
		var maxX:Float = this.vertices[0];
		var minX:Float = this.vertices[0];
		var maxY:Float = this.vertices[1];
		var minY:Float = this.vertices[1];
		@:privateAccess for (i in 0...this.vertices.length) {
			var v = this.vertices[i];
			if (i / 2 == Std.int(i / 2)) {
				if (v > maxX)
					maxX = v;
				else if (v < minX)
					minX = v;
			} else {
				if (v > maxY)
					maxY = v;
				else if (v < minY)
					minY = v;
			}
		}
		rect.x = minX;
		rect.y = minY;
		rect.width = maxX - minX;
		rect.height = maxY - minY;
		return rect;
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
		return false;
	}
	#end
}
