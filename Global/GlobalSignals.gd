extends Node

# Gameplay
signal throw_bomb
const THROW_BOMB: String = "throw_bomb"
func signal_throw_bomb(instance_pos: Vector2, throw_pos: Vector2) -> void:
	emit_signal("throw_bomb", instance_pos, throw_pos)
