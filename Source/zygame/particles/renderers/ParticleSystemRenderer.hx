package zygame.particles.renderers;

import zygame.particles.ParticleSystem;

interface ParticleSystemRenderer {
    public function addParticleSystem(ps : ParticleSystem) : ParticleSystemRenderer;
    public function removeParticleSystem(ps : ParticleSystem) : ParticleSystemRenderer;
    public function update() : Void;
}
