extends CanvasLayer

# Instances
@onready var player_information = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/PlayerInformation

# Signals
signal start_match

func _on_back_button_pressed() -> void:
	GlobalUiManager.signal_game_menu_back()

func _on_copy_game_id_button_pressed() -> void:
	DisplayServer.clipboard_set(GlobalGameInformation.current_game_id)
	
func client_connected_ui(peer_id: int, multiplayer_bridge: NakamaMultiplayerBridge):
	player_information.set_username_text(multiplayer_bridge.get_user_presence_for_peer(peer_id).username)
	

func _on_start_button_pressed() -> void:
	emit_signal("start_match")
