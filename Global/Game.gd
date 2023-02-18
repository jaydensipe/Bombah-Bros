extends Node
class_name Game

# Instances
@onready var gui: Node2D = $GUI
@onready var players: Node2D = $Players
@onready var current_map: Node2D = $"Current Map"
@onready var instancer: Node2D = $Instancer
var multiplayer_bridge: NakamaMultiplayerBridge
var main_menu = load("res://Assets/GUI/MainMenu/MainMenu.tscn").instantiate()
var player = preload("res://Entities/Player/Player.tscn")
var map = preload("res://Stages/MapGrass/MapGrass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	multiplayer_bridge = await NakamaIntegration.initialize_nakama()
	
func load_main_menu() -> void:
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
	add_map()
	
	var string = main_menu.address_entry.text
	await multiplayer_bridge.join_match(string)
	
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
