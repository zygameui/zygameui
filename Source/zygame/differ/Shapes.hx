package zygame.differ;

import differ.data.RayCollision;
import differ.shapes.Ray;
import differ.Collision;
import differ.shapes.Shape;
import differ.data.ShapeCollision;

/**
 * 创建一个图形碰撞的管理器，可管理多个不规则碰撞图形
 */
class Shapes {
	/**
	 * 所有图形列表
	 */
	public var list:Array<Shape> = [];

	/**
	 * 分类的图形列表
	 */
	public var typeList:Map<String, Array<Shape>> = [];

	/**
	 * 类型绑定
	 */
	public var typeMaps:Map<Shape, String> = [];

	/**
	 * 碰撞结果
	 */
	public var shapeResults:Map<Shape, Results<ShapeCollision>> = [];

	/**
	 * 创建一个图形空间，用于管理所有图形的碰撞管理
	 */
	public function new() {}

	/**
	 * 添加互动图形
	 * @param shape 图形
	 * @param type 碰撞分类，同类只与同类碰撞
	 */
	public function add(shape:Shape, type:String = null):Void {
		if (list.indexOf(shape) != -1) {
			remove(shape);
		}
		list.push(shape);
		if (type != null) {
			var list2 = typeList.get(type);
			if (list2 == null) {
				list2 = [];
				typeList.set(type, list2);
			}
			list2.push(shape);
			typeMaps.set(shape, type);
		}
	}

	/**
	 * 删除互动图形
	 * @param shape 图形
	 */
	public function remove(shape:Shape):Void {
		var type = typeMaps.get(shape);
		if (type != null)
			typeList.get(type).remove(shape);
		list.remove(shape);
	}

	/**
	 * 测试图形碰撞
	 * @param shape 图形
	 * @param into 用于接收碰撞结果
	 * @param type 与什么类型进行碰撞
	 * @param into 碰撞图形结果预设对象，使用该角色，可以减少垃圾回收
	 * @return Bool
	 */
	public function test(shape:Shape, type:String = null, into:Results<ShapeCollision> = null):Results<ShapeCollision> {
		var list:Array<Shape> = type != null ? typeList.get(type) : list;
		return testList(shape, list, into);
	}

	/**
	 * 测试指定列表
	 * @param shape 
	 * @param into 
	 * @return Results<ShapeCollision>
	 */
	public function testList(shape:Shape, list:Array<Shape>, into:Results<ShapeCollision> = null):Results<ShapeCollision> {
		if (list == null)
			return null;
		for (shapeB in list) {
			if (shape == shapeB)
				continue;
			var ret = Collision.shapeWithShape(shape, shapeB);
			if (ret != null) {
				if (into == null) {
					into = new Results<ShapeCollision>(0);
				}
				into.push(ret);
			}
		}
		return into;
	}

	/**
	 * 使用射线测试指定列表
	 * @param shape 
	 * @param into 
	 * @return Results<ShapeCollision>
	 */
	public function testListByRay(shape:Ray, list:Array<Shape>, into:Results<RayCollision> = null):Results<RayCollision> {
		if (list == null)
			return null;
		for (shapeB in list) {
			var ret = Collision.rayWithShape(shape, shapeB);
			if (ret != null) {
				if (into == null) {
					into = new Results<RayCollision>(0);
				}
				into.push(ret);
			}
		}
		return into;
	}

	/**
	 * 测试射线碰撞
	 * @param shape 图形
	 * @param into 用于接收碰撞结果
	 * @param type 与什么类型进行碰撞
	 * @param into 碰撞图形结果预设对象，使用该角色，可以减少垃圾回收
	 * @return Bool
	 */
	public function testRay(shape:Ray, type:String = null, into:Results<RayCollision> = null):Results<RayCollision> {
		var list:Array<Shape> = type != null ? typeList.get(type) : list;
		if (list == null)
			return null;
		for (shapeB in list) {
			var ret = Collision.rayWithShape(shape, shapeB);
			if (ret != null) {
				if (into == null) {
					into = new Results<RayCollision>(0);
				}
				into.push(ret);
			}
		}
		return into;
	}
}
