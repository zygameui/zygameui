package zygame.triangles;

import openfl.Vector;

/**
 * 矩形三角形，由6个顶点组成
 */
class TriangleQuad extends TriangleMesh {
	public function new() {
		// 0,1,2,3,4,5,6,7
		// X,Y,W,Y,W,H,X,H
		super();
		this.vertices = new Vector(8, false, [0., 0., 0., 0., 0., 0., 0., 0.]);
	}

	override function onRenderReady() {
		super.onRenderReady();
		this.vertices[0] = this.x;
		this.vertices[1] = this.y;
		this.vertices[2] = this.x + this.width;
		this.vertices[3] = this.y;
		this.vertices[4] = this.x + this.width;
		this.vertices[5] = this.y + this.height;
		this.vertices[6] = this.x;
		this.vertices[7] = this.y + this.height;
	}
}
