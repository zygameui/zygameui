package zygame.triangles;

import openfl.display.Shape;
import openfl.Vector;

/**
 * 三角形对象，可以同时绘制支持最多16张不同的纹理，请注意如果超过16张会发生异常，该精灵主要用于高性能渲染画面使用。
 * 在使用Triangles将仅支持BlendMode.ADD模式
 */
class Triangles extends Shape {
	/**
	 * 所有三角形
	 */
	private var _triangles:Array<ITriangleDisplayObject> = [];

	/**
	 * 添加一个三角形显示对象
	 * @param display 三角形显示对象
	 */
	public function addChild(display:ITriangleDisplayObject):Void {
		_triangles.push(display);
	}

	/**
	 * 添加一个三角形显示对象，同时指定索引位置
	 * @param display 
	 * @param index 
	 */
	public function addChildAt(display:ITriangleDisplayObject, index:Int):Void {
		_triangles.insert(index, display);
	}

	/**
	 * 开始渲染三角形
	 */
	public function render():Void {
		var array:Vector<Float> = new Vector<Float>();
		for (index => value in _triangles) {
			array = array.concat(value.vertices);
		}
		this.graphics.beginFill(0xff0000);
	}
}
