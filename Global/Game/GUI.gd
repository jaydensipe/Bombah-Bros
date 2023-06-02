extends CanvasLayer
class_name GUI

# Configuration
@onready var game_ui_holder: Control = $GameUI
var previous_ui_references: Array[PackedScene] = []
var current_ui_scene_reference: PackedScene
var current_ui_reference: Control

# Instances
var main_menu = preload("res://Assets/GUI/MainMenu/MainMenu.tscn")
var loading_menu = load("res://Assets/GUI/Loading/Loading.tscn")
var join_game_menu = load("res://Assets/GUI/JoinGame/JoinGame.tscn")
var initialize_game_menu = load("res://Assets/GUI/InitializeGame/InitializeGame.tscn")
var settings = load("res://Assets/GUI/Settings/Settings.tscn")
var game_ui = preload("res://Assets/GUI/GameUI/GameUI.tscn")

# Signals
signal disconnect

func _ready() -> void:
	init_signal_connections()
	
func init_signal_connections() -> void:
	GlobalSignalManager.game_menu_back.connect(ui_go_back)
	GlobalSignalManager.join_pressed.connect(_join_server)
	GlobalSignalManager.settings_pressed.connect(_settings)

func load_connecting_menu() -> void:
	load_ui_element(loading_menu)
	
func load_main_menu() -> void:
	GlobalSignalManager.signal_main_menu_load_change(false)
	
	load_ui_element(main_menu)
	
func _settings() -> void:
	load_ui_element(settings)
	
func _join_server() -> void:
	load_ui_element(join_game_menu)
	
func init_game_ui() -> void:
	game_ui_holder.add_child(game_ui.instantiate())
	
func remove_game_ui() -> void:
	for i in game_ui_holder.get_children():
		i.queue_free()
	
func load_ui_element(ui: PackedScene, go_back: bool = false) -> void:
	if current_ui_reference:
		remove_ui_element(current_ui_reference, current_ui_scene_reference, go_back)
		
	current_ui_scene_reference = ui
	current_ui_reference = ui.instantiate()
	
	self.add_child(current_ui_reference)
	
func remove_ui_element(ui: Control, ui_scene: PackedScene, go_back: bool = false) -> void:
	if !go_back:
		previous_ui_references.append(ui_scene)

	ui.queue_free()
	
func ui_go_back(triggers_disconnect: bool = false) -> void:
	if (triggers_disconnect):
		emit_signal("disconnect")
		
	var temp = previous_ui_references.pop_back()
	load_ui_element(temp, true)
