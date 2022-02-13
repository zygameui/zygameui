package zygame.components;

import openfl.particle.GPUParticleSprite;
import zygame.components.base.DataProviderComponent;

/**
 * GPU粒子效果组件，该粒子系统使用`openfl-gpu-particles`库实现，一般可以直接使用`ZParticles`类构造。
 * 当设置`gpu_particles`定义时，则会使用`ZGPUParticles`进行构造，否则就会使用`ZCPUParticles`构造。
 */
class ZGPUParticles extends DataProviderComponent {
	/**
	 * GPU粒子系统
	 */
	public var gpuSystem:GPUParticleSprite;

	/**
	 * 构造一个GPU计算的粒子系统
	 */
	public function new() {
		super();
	}

	override function set_dataProvider(data:Dynamic):Dynamic {
		var array = cast(data, String).split(":");
		this.destroy();
		gpuSystem = GPUParticleSprite.fromJson(ZBuilder.getBaseObject(array[1]), ZBuilder.getBaseBitmapData(array[0]));
		this.addChild(gpuSystem);
		gpuSystem.start();
		return super.set_dataProvider(data);
	}

	override function onInit() {}

	/**
	 * 释放当前粒子
	 */
	override function destroy() {
		super.destroy();
		if (gpuSystem != null) {
			gpuSystem.stop();
		}
	}

	override function onAddToStage() {
		super.onAddToStage();
	}

	override function onRemoveToStage() {
		super.onRemoveToStage();
	}

	override function get_width():Float {
		return 1;
	}

	override function get_height():Float {
		return 1;
	}
}
