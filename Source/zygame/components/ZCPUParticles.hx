package zygame.components;

import zygame.particles.renderers.ParticleSystemRenderer;
import zygame.particles.renderers.DefaultParticleRenderer;
import zygame.particles.loaders.ZParticleLoader;
import zygame.particles.ParticleSystem;
import zygame.components.base.DataProviderComponent;

/**
 * CPU粒子效果组件
 */
class ZCPUParticles extends DataProviderComponent {
	private var _x:Float = 0;

	private var _y:Float = 0;

	/**
	 * 粒子系统
	 */
	public var particles:ParticleSystem;

	/**
	 * Tilemap渲染器
	 */
	private var render:ParticleSystemRenderer;

	public function new() {
		super();
		render = DefaultParticleRenderer.createInstance();
	}

	override function onInit() {
		this.addChild(cast render);
	}

	override function set_dataProvider(data:Dynamic):Dynamic {
		var array = cast(data, String).split(":");
		this.destroy();
		ZParticleLoader.load(ZBuilder.getBaseObject(array[1]), function(system) {
			particles = system;
			render.addParticleSystem(system);
			particles.emit(_x, _y);
			particles.active = true;
		}, ZBuilder.getBaseBitmapData(array[0]));
		return super.set_dataProvider(data);
	}

	/**
	 * 释放当前粒子
	 */
	override function destroy() {
		super.destroy();
		if (particles != null) {
			render.removeParticleSystem(particles);
			particles.stop();
			particles = null;
		}
	}

	override function onFrame() {
		super.onFrame();
		render.update();
	}

	override function onAddToStage() {
		super.onAddToStage();
		this.setFrameEvent(true);
	}

	override function onRemoveToStage() {
		super.onRemoveToStage();
		this.setFrameEvent(false);
	}

	override function set_x(value:Float):Float {
		_x = value;
		if (particles != null)
			particles.emit(_x, _y);
		return value;
	}

	override function set_y(value:Float):Float {
		_y = value;
		if (particles != null)
			particles.emit(_x, _y);
		return value;
	}

    override function get_width():Float{
        return 1;
    }

    override function get_height():Float{
        return 1;
    }
}
