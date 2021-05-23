package zygame.triangles;

/**
 * 三角形渲染的容器
 */
class TriangleSprite extends TriangleDisplayObject {
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
}
