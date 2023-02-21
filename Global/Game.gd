extends Node
class_name Game

# Instances
@onready var gui: Node2D = $GUI
@onready var players: Node2D = $Players
@onready var current_map: Node2D = $"Current Map"
@onready var instancer: Node2D = $Instancer
var multiplayer_bridge: NakamaMultiplayerBridge
var main_menu = preload("res://Assets/GUI/MainMenu/MainMenu.tscn")
var loading_menu = load("res://Assets/GUI/Loading/Loading.tscn").instantiate()
var join_game_menu = load("res://Assets/GUI/JoinGame/JoinGame.tscn").instantiate()
var initalize_game_menu = load("res://Assets/GUI/InitializeGame/InitializeGame.tscn").instantiate()
var player = load("res://Entities/Player/Player.tscn")
var map = load("res://Stages/MapGrass/MapGrass.tscn")
var current_ui_reference: WeakRef
var previous_ui_element_reference: WeakRef

func _ready():
	GlobalUiManager.connect(GlobalUiManager.GAME_MENU_BACK, ui_go_back)
	join_game_menu.join_pressed.connect(_join_match)
	
	initialize_main_menu()
	
func initialize_main_menu() -> void:
	load_connecting_menu()
	multiplayer_bridge = await NakamaIntegration.initialize_nakama()
	load_main_menu()
	
func load_connecting_menu() -> void:
	load_ui_element(loading_menu)
	
func load_main_menu() -> void:
	remove_ui_element(loading_menu)
	
	main_menu = main_menu.instantiate()
	main_menu.host_pressed.connect(_host_server)
	main_menu.join_pressed.connect(_join_server)
	
	load_ui_element(main_menu)
	
func _host_server() -> void:
	remove_ui_element(main_menu)
	add_map()

	await multiplayer_bridge.create_match()
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	if not multiplayer.peer_connected.is_connected(add_player):
		multiplayer.peer_connected.connect(add_player)
	
	GlobalGameInformation.current_game_id = multiplayer_bridge.match_id

	add_player(multiplayer.get_unique_id())
#	load_ui_element(initalize_game_menu)
	
func _join_server() -> void:
	remove_ui_element(main_menu)
	
	load_ui_element(join_game_menu)
	
func _join_match(connection_string: String) -> void:	
	add_map()

	await multiplayer_bridge.join_match(connection_string)
	remove_ui_element(join_game_menu)
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	
func add_map() -> void:
	current_map.add_child(map.instantiate())
	
func get_current_map() -> Node2D:
	return current_map.get_child(0)
	
func add_player(peer_id: int) -> void:
#	pass
	instance_and_set_player_spawn.rpc(peer_id, get_random_spawn_location_from_current_map())

@rpc("call_local")
func instance_and_set_player_spawn(peer_id, spawn_location):
	var ply: Player = player.instantiate()
	ply.name = str(peer_id)
	
	ply.set_spawn_position(spawn_location)
	players.add_child(ply)
	
func get_random_spawn_location_from_current_map() -> Vector2:
	var spawns: Node2D = self.get_current_map().get_node("Spawns")
	var selected_spawn: Marker2D = spawns.get_children().pick_random()
	spawns.remove_child(selected_spawn)
	
	return selected_spawn.position
	
func load_ui_element(ui: CanvasLayer) -> void:
	current_ui_reference = weakref(ui)
	gui.add_child(ui)
	
func remove_ui_element(ui: CanvasLayer) -> void:
	previous_ui_element_reference = weakref(ui)
	gui.remove_child(ui)
	
func ui_go_back():
	if (multiplayer_bridge._match_id != ""):
		multiplayer_bridge.leave()
		
	var temp = previous_ui_element_reference.get_ref()
	remove_ui_element(current_ui_reference.get_ref())
	load_ui_element(temp)
