extends Control
class_name InitializeGame

# Instances
var default_text: String = "Waiting..."
var default_bot_name: String = "BombahBot 1.0"
@onready var player_information: PlayerInformation = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/PlayerInformation
@onready var host_information: PlayerInformation = $PanelContainer/InformationContainer/VBoxContainer/HBoxContainer/HostInformation
@onready var start_button: Button = $PanelContainer/ButtonContainer/HBoxContainer/StartButton
@onready var game_id_button: Button = $PanelContainer/GameIDContainer/HBoxContainer/CopyGameIDButton

	
func init_signal_connections() -> void:
	GlobalSignalManager.host_connected_ui.connect(_host_connected_ui)
	GlobalSignalManager.client_connected_ui.connect(_client_connected_ui)
	GlobalSignalManager.client_disconnected.connect(_player_disconnected)

func _exit_tree() -> void:
	queue_free()
	
func _ready() -> void:
	init_signal_connections()
	
	if (multiplayer.is_server()):
		if (GlobalGameInformation.SINGLEPLAYER_SESSION):
			player_information.set_username_text("BombahBot 1.0")
			game_id_button.hide()
			
		host_information.set_username_text(GlobalGameInformation.get_current_player().username, true)
		host_information.set_avatar_image(GlobalGameInformation.get_current_player().avatar_image)
	else:
		start_button.hide()
		game_id_button.hide()
		
@rpc("any_peer")
func load_ui():
	if (multiplayer.is_server()):
		if (GlobalGameInformation.SINGLEPLAYER_SESSION):
			player_information.set_username_text("BombahBot 1.0")
			game_id_button.hide()
			
		host_information.set_username_text(GlobalGameInformation.get_current_player().username, true)
		host_information.set_avatar_image(GlobalGameInformation.get_current_player().avatar_image)
	else:
		start_button.hide()
		game_id_button.hide()
	
func _on_back_button_pressed() -> void:
	GlobalSignalManager.signal_game_menu_back(true)
	GlobalGameInformation.get_current_game_information().reset_opponent()

func _on_copy_game_id_button_pressed() -> void:
	DisplayServer.clipboard_set(GlobalGameInformation.get_current_game_information().current_game_id)
	
func _host_connected_ui(peer_id: int, multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	# Initialize opponent	
	var user_info = await NakamaIntegration.get_player_info(multiplayer_bridge.get_user_presence_for_peer(peer_id).user_id)
	
	# TODO: Fix up
	load_ui.rpc_id(peer_id)
	
	# Get opponent name
	var opp_name: String = user_info.users[0].username
	player_information.set_username_text(opp_name)	
	
	# Get opponent avatar
	var opp_avatar: ImageTexture
	if (user_info.users[0].avatar_url == null):
		opp_avatar = ImageTexture.create_from_image(load("res://icon.svg").get_image())
	else:
		opp_avatar = await GlobalGameInformation.request_avatar(user_info.users[0].avatar_url)
		
	player_information.set_avatar_image(opp_avatar)
	
	initialize_game_information(opp_name, opp_avatar)
	
func _client_connected_ui(multiplayer_bridge: NakamaMultiplayerBridge) -> void:
	# Sets host information / opponent
	var user_info = await NakamaIntegration.get_player_info(multiplayer_bridge.get_user_presence_for_peer(1).user_id)
	var opp_avatar: ImageTexture = await GlobalGameInformation.request_avatar(user_info.users[0].avatar_url)
	var opp_name: String =  user_info.users[0].username

	host_information.set_avatar_image(opp_avatar)
	host_information.set_username_text(opp_name, true)
#
	initialize_game_information(opp_name, opp_avatar)
#
	# Sets non-host information for the player
	player_information.set_username_text(GlobalGameInformation.get_current_player().username)
	player_information.set_avatar_image(GlobalGameInformation.get_current_player().avatar_image)

func initialize_game_information(current_opponent_name: String, current_opponent_avatar_image: ImageTexture) -> void:
	GlobalGameInformation.get_current_game_information().get_current_opponent().username = current_opponent_name
	GlobalGameInformation.get_current_game_information().get_current_opponent().avatar_image = current_opponent_avatar_image

func _player_disconnected(_peer_id: int) -> void:
	GlobalGameInformation.get_current_game_information().reset_opponent()
	reset_player_info()
	
func reset_player_info() -> void:
	player_information.set_avatar_image(GlobalGameInformation.get_current_game_information().get_current_opponent().avatar_image)
	player_information.set_username_text(default_text)
	
func _on_start_button_pressed() -> void:
	GlobalSignalManager.signal_start_match()
