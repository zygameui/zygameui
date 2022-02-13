package zygame.components;

import zygame.components.ZGPUParticles;

/**
 * 通用的粒子系统渲染器，当开启`gpu_particles`定义时，则会使用`ZGPUParticles`渲染，否则会使用`ZCPUParticles`渲染；默认允许XML中使用。
 * ```xml
 * <ZParticles src="lizi_json:lizi_png"/>
 * ```
 */
#if gpu_particles
class ZParticles extends ZGPUParticles {}
#else
class ZParticles extends ZCPUParticles {}
#end
