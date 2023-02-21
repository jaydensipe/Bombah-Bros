extends Node

# UI
signal game_menu_back
const GAME_MENU_BACK: String = "game_menu_back"
func signal_game_menu_back() -> void:
	emit_signal(GAME_MENU_BACK)
