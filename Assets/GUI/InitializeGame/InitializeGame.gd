extends Control
class_name InitializeGame

# Instances
var default_text: String = "Waiting..."
@onready var player_information: PlayerInformation = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/PlayerInformation
@onready var host_information: PlayerInformation = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/HostInformation
@onready var start_button: Button = $PanelContainer/ButtonContainer/HBoxContainer/StartButton
@onready var game_id_button: Button = $PanelContainer/GameIDContainer/HBoxContainer/CopyGameIDButton

# Signals
signal start_match

func _enter_tree() -> void:
	request_ready()
	
func _exit_tree() -> void:
	game_id_button.show()
	start_button.show()
	player_information.set_username_text(default_text)

func _ready() -> void:
	if (not GlobalGameInformation.SINGLEPLAYER_SESSION):
		start_button.disabled = true
	
	if (multiplayer.is_server()):
		host_information.set_username_text(GlobalGameInformation.username, true)
	else:
		start_button.hide()
		game_id_button.hide()
		
	if (GlobalGameInformation.SINGLEPLAYER_SESSION):
		player_information.set_username_text("BombahBot 1.0")
		game_id_button.hide()
	
	
func _on_back_button_pressed() -> void:
	start_button.disabled = false
	
	GlobalSignalManager.signal_game_menu_back(true)

func _on_copy_game_id_button_pressed() -> void:
	DisplayServer.clipboard_set(GlobalGameInformation.get_current_game_information().current_game_id)
	
func host_connected_ui(peer_id: int, multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	start_button.disabled = false
	
	player_information.set_username_text(multiplayer_bridge.get_user_presence_for_peer(peer_id).username)
	var user_info = await NakamaIntegration.get_player_info(multiplayer_bridge.get_user_presence_for_peer(peer_id).user_id)
	player_information.set_avatar_image(await GlobalGameInformation.request_avatar(user_info.users[0].avatar_url))
	
func client_connected_ui(multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	host_information.set_username_text(multiplayer_bridge.get_user_presence_for_peer(1).username, true)
	player_information.set_username_text(GlobalGameInformation.username)
	player_information.set_avatar_image(GlobalGameInformation.avatar_image)
	
func player_disconnected(_peer_id: int) -> void:
	start_button.disabled = true
		
	player_information.set_username_text(default_text)
	
func _on_start_button_pressed() -> void:
	emit_signal("start_match")
