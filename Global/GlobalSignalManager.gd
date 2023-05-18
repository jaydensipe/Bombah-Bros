extends Node

# Gameplay
signal throw_bomb
func signal_throw_bomb(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float, bot_throwing: bool = false) -> void:
	emit_signal("throw_bomb", instance_pos, throw_pos, throw_strength, bot_throwing)
	
signal start_match
func signal_start_match():
	emit_signal("start_match")
	
signal client_disconnected
func signal_client_disconnected(peer_id: int):
	emit_signal("client_disconnected", peer_id)
	
# VFX
signal instance_particles
func signal_instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	emit_signal("instance_particles", instance_pos, terrain_type)
	
signal screen_shake
func signal_screen_shake(new_shake: float, shake_time: float) -> void:
	emit_signal("screen_shake", new_shake, shake_time)
	
# UI
signal game_menu_back
func signal_game_menu_back(triggers_disconnect: bool = false) -> void:
	emit_signal("game_menu_back", triggers_disconnect)
	
signal host_pressed
func signal_host_game_pressed() -> void:
	emit_signal("host_pressed")
	
signal join_game_pressed
func signal_join_game_pressed(connection_string: String) -> void:
	emit_signal("join_game_pressed", connection_string)

signal join_pressed
func signal_join_pressed() -> void:
	emit_signal("join_pressed")
	
signal settings_pressed
func signal_settings_pressed() -> void:
	emit_signal("settings_pressed")

signal play_with_bot_pressed
func signal_play_with_bot_pressed_pressed() -> void:
	emit_signal("play_with_bot_pressed")
	
signal host_connected_ui
func signal_host_connected_ui(peer_id: int, multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	emit_signal("host_connected_ui", peer_id, multiplayer_bridge)
	
signal client_connected_ui
func signal_client_connected_ui(multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	emit_signal("client_connected_ui", multiplayer_bridge)
	
# Music
signal main_menu_load_change
func signal_main_menu_load_change(closing) -> void:
	emit_signal("main_menu_load_change", closing)


