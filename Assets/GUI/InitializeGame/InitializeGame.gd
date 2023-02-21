extends CanvasLayer

func _on_back_button_pressed() -> void:
	GlobalUiManager.signal_game_menu_back()


func _on_copy_game_id_button_pressed() -> void:
	DisplayServer.clipboard_set(GlobalGameInformation.current_game_id)
