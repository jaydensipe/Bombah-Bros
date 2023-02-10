extends Node

# Instances
@onready var gui: Node2D = $GUI
@onready var players: Node2D = $Players
@onready var current_map: Node2D = $"Current Map"
var main_menu = load("res://Assets/GUI/MainMenu/MainMenu.tscn").instantiate()
var player = preload("res://Entities/Player/Player.tscn")
var map = preload("res://Stages/MapGrass/MapGrass.tscn")

# Server Settings
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	
func load_main_menu():
	main_menu.host_pressed.connect(_host_server)
	main_menu.join_pressed.connect(_join_server)
	
	load_ui_element(main_menu)
	
func _host_server():
	remove_ui_element(main_menu)

	add_map()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())
	
func _join_server():
	remove_ui_element(main_menu)

	add_map()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func add_map():
	current_map.add_child(map.instantiate())
	
func add_player(peer_id):
	var ply = player.instantiate()
	ply.name = str(peer_id)
	
	players.add_child(ply)
	
func load_ui_element(ui: CanvasLayer):
	gui.add_child(ui)
	
func remove_ui_element(ui: CanvasLayer):
	gui.remove_child(ui)
	ui.queue_free()
