extends Control
class_name InitializeGame

# Instances
@onready var player_information = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/PlayerInformation
@onready var host_information = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/HostInformation
@onready var start_button = $PanelContainer/ButtonContainer/HBoxContainer/StartButton
@onready var game_id_button = $PanelContainer/GameIDContainer/HBoxContainer/CopyGameIDButton

# Signals
signal start_match

func _enter_tree() -> void:
	request_ready()

func _ready() -> void:
	if (multiplayer.is_server()):
		host_information.set_username_text(GlobalGameInformation.username, true)
	else:
		start_button.disabled = true
		start_button.hide()
		game_id_button.disabled = true
		game_id_button.hide()
	
	
func _on_back_button_pressed() -> void:
	GlobalSignalManager.signal_game_menu_back(true)

func _on_copy_game_id_button_pressed() -> void:
	DisplayServer.clipboard_set(GlobalGameInformation.current_game_id)
	
func host_connected_ui(peer_id: int, multiplayer_bridge: NakamaMultiplayerBridge):
	player_information.set_username_text(multiplayer_bridge.get_user_presence_for_peer(peer_id).username)
	
func client_connected_ui(multiplayer_bridge: NakamaMultiplayerBridge):
	host_information.set_username_text(multiplayer_bridge.get_user_presence_for_peer(1).username, true)
	player_information.set_username_text(GlobalGameInformation.username)
	
func _on_start_button_pressed() -> void:
	emit_signal("start_match")
