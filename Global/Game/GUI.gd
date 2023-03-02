extends Control
class_name GUI

# Configuration
var current_ui_reference: WeakRef
var previous_ui_element_reference: WeakRef

# Instances
var main_menu = preload("res://Assets/GUI/MainMenu/MainMenu.tscn")
var loading_menu: Loading = load("res://Assets/GUI/Loading/Loading.tscn").instantiate()
var join_game_menu: JoinGame = load("res://Assets/GUI/JoinGame/JoinGame.tscn").instantiate()
var initalize_game_menu: InitializeGame = load("res://Assets/GUI/InitializeGame/InitializeGame.tscn").instantiate()
var settings: Settings = load("res://Assets/GUI/Settings/Settings.tscn").instantiate()

# Signals
signal join_match
signal host_server

func _ready() -> void:
	init_signal_connections()
	
func init_signal_connections() -> void:
	GlobalSignalManager.game_menu_back.connect(ui_go_back)
	join_game_menu.join_pressed.connect(_join_match)

func load_connecting_menu() -> void:
	load_ui_element(loading_menu)	
	
func load_main_menu() -> void:
	main_menu = main_menu.instantiate()
	main_menu.host_pressed.connect(_host_server)
	main_menu.join_pressed.connect(_join_server)
	main_menu.settings_pressed.connect(_settings)
	
	load_ui_element(main_menu)
	
func _settings() -> void:
	load_ui_element(settings)
	
func _join_server() -> void:
	load_ui_element(join_game_menu)
	
func _host_server() -> void:
	emit_signal("host_server")
	
func _join_match(connection_string: String) -> void:
	emit_signal("join_match", connection_string)
	
func load_ui_element(ui: CanvasLayer) -> void:
	if (current_ui_reference):
		remove_ui_element(current_ui_reference.get_ref())
	
	current_ui_reference = weakref(ui)
	self.add_child(ui)
	
func remove_ui_element(ui: CanvasLayer) -> void:
	previous_ui_element_reference = weakref(ui)
	self.remove_child(ui)
	
func ui_go_back():
	var temp = previous_ui_element_reference.get_ref()
	remove_ui_element(current_ui_reference.get_ref())
	load_ui_element(temp)
