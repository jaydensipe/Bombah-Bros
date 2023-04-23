extends Node
class_name Game

# Configuration
var connected_peers: Array = []

# Instances
@onready var gui: GUI = $GUI
@onready var players: Node2D = $Players
@onready var current_map: Node2D = $"Current Map"
@onready var instancer: Node2D = $Instancer
var multiplayer_bridge: NakamaMultiplayerBridge
var map = load("res://Stages/MapGrass/MapGrass.tscn")
var player = load("res://Entities/Player/Player.tscn")

# Game Logic
@rpc("call_local")
func end_game() -> void:
	
	gui.load_ui_element(gui.initalize_game_menu)
	reset_game()
	
func _character_death(character: Character):
	end_game.rpc()
	
func _ready() -> void:
	init_signal_connections()
	initialize_multiplayer_bridge()
	
func init_signal_connections() -> void:
	gui.main_menu.host_pressed.connect(_host_server)
	gui.main_menu.play_with_bot_pressed.connect(_host_bot_match)
	gui.join_game_menu.join_pressed.connect(_join_match)
	gui.disconnect.connect(_disconnect)
	
# Server Setup
func initialize_multiplayer_bridge() -> void:
	gui.load_connecting_menu()
	multiplayer_bridge = await NakamaIntegration.initialize_nakama()
	multiplayer_bridge.match_join_error.connect(func(error): GlobalDebugMananger.display_error_dialog(error.message))
	gui.load_main_menu()
	
	GlobalGameInformation.avatar_image = await GlobalGameInformation.request_avatar(GlobalGameInformation.avatar_url)
	
func _host_server() -> void:
	GlobalGameInformation.SINGLEPLAYER_SESSION = false
	
	await multiplayer_bridge.create_match()
	
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	GlobalGameInformation.get_current_game_information().current_game_id = multiplayer_bridge.match_id
	
	if !multiplayer.peer_connected.is_connected(add_player):
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_connected.connect(gui.initalize_game_menu.host_connected_ui.bind(multiplayer_bridge))
		multiplayer.peer_disconnected.connect(_client_disconnect)
		gui.initalize_game_menu.start_match.connect(_start_match)
	
	add_player(multiplayer.get_unique_id())
	gui.load_ui_element(gui.initalize_game_menu)
	
func _host_bot_match() -> void:
	GlobalGameInformation.SINGLEPLAYER_SESSION = true
	
	var enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(9069)
	multiplayer.multiplayer_peer = enet_peer
	
	if not multiplayer.peer_connected.is_connected(add_player):
		multiplayer.peer_connected.connect(add_player)
		gui.initalize_game_menu.start_match.connect(_start_match)
		
	add_player(multiplayer.get_unique_id())
	gui.load_ui_element(gui.initalize_game_menu)
	
func _start_match() -> void:
	host_start_game.rpc()
	instance_and_set_player_spawn()
	
func _client_disconnect(peer_id: int) -> void:
	gui.initalize_game_menu.player_disconnected(peer_id)
	connected_peers.erase(peer_id)
	
@rpc("call_local")
func host_start_game() -> void:
	GlobalSignalManager.signal_main_menu_load_change(true)
	
	gui.remove_child($GUI/Decoration)
	gui.remove_ui_element(gui.current_ui_reference.get_ref())
	add_map()

func instance_and_set_player_spawn() -> void:
	if (!multiplayer.is_server()): return
	
	# Spawn a bot in Singleplayer mode
	if (GlobalGameInformation.SINGLEPLAYER_SESSION):
		var bot: Bot = load("res://Entities/AI/Bot.tscn").instantiate()
		players.add_child(bot)
		bot.set_spawn_position(get_random_spawn_location_from_current_map())
		bot.has_died.connect(_character_death)
	
	for peer_id in connected_peers:
		var ply: Player = player.instantiate()
		ply.name = str(peer_id)
		ply.has_died.connect(_character_death)

		players.add_child(ply)
		ply.set_spawn_position.rpc(get_random_spawn_location_from_current_map())
		
func get_random_spawn_location_from_current_map() -> Vector2:
	var spawns: Node2D = get_current_map().get_node("Spawns")
	var selected_spawn: Marker2D = spawns.get_children().pick_random()
	spawns.remove_child(selected_spawn)
	
	return selected_spawn.position
	
func add_map() -> void:
	current_map.add_child(map.instantiate())
	
func remove_map() -> void:
	current_map.call_deferred("remove_child", current_map.get_children()[0])
	
func get_current_map() -> Node2D:
	return current_map.get_child(0)
	
func add_player(peer_id: int) -> void:
	connected_peers.append(peer_id)
	
func remove_players() -> void:
	for player in players.get_children():
		players.remove_child(player)
		player.queue_free()
	
func reset_game() -> void:
	remove_map()
	remove_players()
	
# Client Setup
func _join_match(connection_string: String) -> void:
	GlobalGameInformation.SINGLEPLAYER_SESSION = false
	
	await multiplayer_bridge.join_match(connection_string)
	
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	if !multiplayer_bridge.match_joined.is_connected(gui.initalize_game_menu.client_connected_ui):
		multiplayer_bridge.match_joined.connect(gui.initalize_game_menu.client_connected_ui.bind(multiplayer_bridge))
		
	gui.load_ui_element(gui.initalize_game_menu)
	
func _disconnect() -> void:
	GlobalGameInformation.clear_current_game_information()
	
	connected_peers.clear()
	multiplayer_bridge.leave()
