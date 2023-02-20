extends Node

# UI
signal join_game_menu_back
const JOIN_GAME_MENU_BACK: String = "join_game_menu_back"
func signal_join_game_menu_back() -> void:
	emit_signal(JOIN_GAME_MENU_BACK)
