extends Node

# Gameplay
signal throw_bomb
const THROW_BOMB: String = "throw_bomb"
func signal_throw_bomb(instance_pos: Vector2, throw_pos: Vector2) -> void:
	emit_signal("throw_bomb", instance_pos, throw_pos)
	
# VFX
signal instance_particles
const INSTANCE_PARTICLES: String = "instance_particles"
func signal_instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	emit_signal("instance_particles", instance_pos, terrain_type)

