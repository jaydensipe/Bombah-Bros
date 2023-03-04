extends Node

# Gameplay
signal throw_bomb
func signal_throw_bomb(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float) -> void:
	emit_signal("throw_bomb", instance_pos, throw_pos, throw_strength)
	
# VFX
signal instance_particles
func signal_instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	emit_signal("instance_particles", instance_pos, terrain_type)
	
signal screen_shake
func signal_screen_shake(new_shake, shake_time) -> void:
	emit_signal("screen_shake", new_shake, shake_time)
	
# UI
signal game_menu_back
func signal_game_menu_back(triggers_disconnect: bool = false) -> void:
	emit_signal("game_menu_back", triggers_disconnect)
	
# Music
signal main_menu_load_change
func signal_main_menu_load_change(closing) -> void:
	emit_signal("main_menu_load_change", closing)


