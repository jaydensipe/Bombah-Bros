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

func _ready() -> void:
	init_signal_connections()
	initialize_multiplayer_bridge()
	
func init_signal_connections() -> void:
	gui.connect("host_server", _host_server)
	gui.connect("join_match", _join_match)	
	
# Server Setup
func initialize_multiplayer_bridge() -> void:
	gui.load_connecting_menu()
	multiplayer_bridge = await NakamaIntegration.initialize_nakama()
	gui.load_main_menu()
	
func _host_server() -> void:
	await multiplayer_bridge.create_match()
	
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	GlobalGameInformation.current_game_id = multiplayer_bridge.match_id
	
	if not multiplayer.peer_connected.is_connected(add_player):
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_connected.connect(gui.initalize_game_menu.host_connected_ui.bind(multiplayer_bridge))
		gui.initalize_game_menu.start_match.connect(_start_match)
	
	add_player(multiplayer.get_unique_id())
	gui.load_ui_element(gui.initalize_game_menu)
	
func _start_match() -> void:
	host_start_game.rpc()
	
@rpc("call_local")
func host_start_game() -> void:
	gui.remove_ui_element(gui.current_ui_reference.get_ref())
	add_map()
	instance_and_set_player_spawn(get_random_spawn_location_from_current_map())	

func instance_and_set_player_spawn(spawn_location):
	for peer_id in connected_peers:
		var ply: Player = player.instantiate()
		ply.name = str(peer_id)

		ply.set_spawn_position(spawn_location)
		players.add_child(ply)
	
func get_random_spawn_location_from_current_map() -> Vector2:
	var spawns: Node2D = get_current_map().get_node("Spawns")
	var selected_spawn: Marker2D = spawns.get_children().pick_random()
	spawns.remove_child(selected_spawn)
	
	return selected_spawn.position
	
func add_map() -> void:
	current_map.add_child(map.instantiate())
	
func get_current_map() -> Node2D:
	return current_map.get_child(0)
	
func add_player(peer_id: int) -> void:
	connected_peers.append(peer_id)
	
# Client Setup
func _join_match(connection_string: String) -> void:	
	await multiplayer_bridge.join_match(connection_string)
	
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	multiplayer_bridge.match_joined.connect(gui.initalize_game_menu.client_connected_ui.bind(multiplayer_bridge))
	
	gui.load_ui_element(gui.initalize_game_menu)	
