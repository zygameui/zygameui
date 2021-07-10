package zygame.components;

import zygame.components.ZGPUParticles;

/**
 * GPU粒子实验性功能，需要测试，当稳定时，就全面启动GPU渲染
 */
#if gpu_particles
typedef ZParticles = ZGPUParticles;
#else
typedef ZParticles = ZCPUParticles;
#end