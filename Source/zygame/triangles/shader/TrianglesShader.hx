package zygame.triangles.shader;

import glsl.OpenFLGraphicsShader;
import VectorMath;

/**
 * 三角形着色器
 */
class TrianglesShader extends OpenFLGraphicsShader {

    @:uniform public var time:Float;

    public function new() {
        super();
        this.u_time.value = [0];
        this.setFrameEvent(true);
    }

    override function fragment() {
        super.fragment();
        this.gl_FragColor = vec4(sin(time),0,1,1);
    }

    override function onFrame() {
        super.onFrame();
        this.u_time.value[0] += 1/60;
    }
}
