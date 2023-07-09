package zygame.triangles;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import zygame.triangles.shader.TrianglesShader;
import openfl.display.Shape;
import openfl.Vector;

/**
 * 三角形对象，可以同时绘制支持最多16张不同的纹理，请注意如果超过16张会发生异常，该精灵主要用于高性能渲染画面使用。
 * 在使用Triangles将仅支持BlendMode.ADD模式
 */
class Triangles extends Shape {
	private var _shader:zygame.triangles.shader.TrianglesShader;

	private var _array:Vector<Float> = new Vector<Float>(0, false);

	private var _ids:Vector<Int> = new Vector<Int>(0, false);

	private var _changed:Bool = true;

	public function new() {
		super();
		_shader = new TrianglesShader();
	}

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
		if (_changed) {
			var id:Int = 0;
			_ids.splice(0, _ids.length);
			_array.splice(0, _array.length);
			for (index => value in _triangles) {
				if (value.changed)
					value.onRenderReady();
				_array = _array.concat(value.vertices);
				_ids = _ids.concat(new Vector<Int>(6, false, [id, id + 1, id + 2, id + 2, id + 3, id]));
				// Quad:0, 1, 2, 2, 3, 0
				id += 4;
			}
			_changed = false;
		}
		this.graphics.clear();
		this.graphics.beginShaderFill(_shader);
		this.graphics.drawTriangles(_array, _ids);
		this.graphics.endFill();
	}

	override private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		return false;
	}
}
