extends Node

# Gameplay
signal throw_bomb
const THROW_BOMB: String = "throw_bomb"
func signal_throw_bomb(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float) -> void:
	emit_signal(THROW_BOMB, instance_pos, throw_pos, throw_strength)
	
# VFX
signal instance_particles
const INSTANCE_PARTICLES: String = "instance_particles"
func signal_instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	emit_signal(INSTANCE_PARTICLES, instance_pos, terrain_type)
	
signal screen_shake
const SCREEN_SHAKE: String = "screen_shake"
func signal_screen_shake() -> void:
	emit_signal(SCREEN_SHAKE)
	
# UI
signal game_menu_back
const GAME_MENU_BACK: String = "game_menu_back"
func signal_game_menu_back() -> void:
	emit_signal(GAME_MENU_BACK)


