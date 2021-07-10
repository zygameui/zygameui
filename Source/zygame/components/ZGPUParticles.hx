package zygame.components;

import openfl.particle.GPUParticleSprite;
import zygame.components.base.DataProviderComponent;

/**
 * GPU粒子效果组件
 */
class ZGPUParticles extends DataProviderComponent {
	/**
	 * GPU粒子系统
	 */
	private var _gpuSystem:GPUParticleSprite;

	public function new() {
		super();
	}

	override function set_dataProvider(data:Dynamic):Dynamic {
		var array = cast(data, String).split(":");
		this.destroy();
		_gpuSystem = GPUParticleSprite.fromJson(ZBuilder.getBaseObject(array[1]), ZBuilder.getBaseBitmapData(array[0]));
		this.addChild(_gpuSystem);
		_gpuSystem.start();
		return super.set_dataProvider(data);
	}

	/**
	 * 释放当前粒子
	 */
	override function destroy() {
		super.destroy();
		if (_gpuSystem != null) {
			_gpuSystem.stop();
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
