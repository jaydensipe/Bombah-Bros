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
var join_game_menu = load("res://Assets/GUI/JoinGame/JoinGame.tscn")
var player = preload("res://Entities/Player/Player.tscn")
var map = load("res://Stages/MapGrass/MapGrass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
func _join_server() -> void:
	remove_ui_element(main_menu)
	
	join_game_menu = join_game_menu.instantiate()
	join_game_menu.join_pressed.connect(_join_match)
	
	load_ui_element(join_game_menu)
	
func _join_match(connection_string: String) -> void:	
	add_map()

	await multiplayer_bridge.join_match(connection_string)
	remove_ui_element(join_game_menu)
	multiplayer.multiplayer_peer = multiplayer_bridge.multiplayer_peer
	
func add_map() -> void:
	current_map.add_child(map.instantiate())
	
func add_player(peer_id: int) -> void:
	var ply = player.instantiate()
	ply.name = str(peer_id)
	
	players.add_child(ply)
	
func load_ui_element(ui: CanvasLayer) -> void:
	gui.add_child(ui)
	
func remove_ui_element(ui: CanvasLayer) -> void:
	gui.remove_child(ui)
	ui.queue_free()
