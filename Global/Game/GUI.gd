extends CanvasLayer
class_name GUI

# Configuration
var previous_ui_references: Array[WeakRef] = []
var current_ui_reference: WeakRef

# Instances
var main_menu = preload("res://Assets/GUI/MainMenu/MainMenu.tscn").instantiate()
var loading_menu = load("res://Assets/GUI/Loading/Loading.tscn").instantiate()
var join_game_menu = load("res://Assets/GUI/JoinGame/JoinGame.tscn").instantiate()
var initalize_game_menu = load("res://Assets/GUI/InitializeGame/InitializeGame.tscn").instantiate()
var settings = load("res://Assets/GUI/Settings/Settings.tscn").instantiate()

# Signals
signal disconnect

func _ready() -> void:
	init_signal_connections()
	
func init_signal_connections() -> void:
	GlobalSignalManager.game_menu_back.connect(ui_go_back)

func load_connecting_menu() -> void:
	load_ui_element(loading_menu)
	
func load_main_menu() -> void:
	GlobalSignalManager.signal_main_menu_load_change(false)
	
	main_menu.join_pressed.connect(_join_server)
	main_menu.settings_pressed.connect(_settings)
	
	load_ui_element(main_menu)
	
func _settings() -> void:
	load_ui_element(settings)
	
func _join_server() -> void:
	load_ui_element(join_game_menu)
	
func load_ui_element(ui: Control, go_back: bool = false) -> void:
	if current_ui_reference:
		remove_ui_element(current_ui_reference.get_ref(), go_back)
		
	current_ui_reference = weakref(ui)
	self.add_child(ui)
	
func remove_ui_element(ui: Control, go_back: bool = false) -> void:
	if !go_back:
		previous_ui_references.append(weakref(ui))
		
	self.remove_child(ui)
	
func ui_go_back(triggers_disconnect: bool = false):
	if (triggers_disconnect):
		emit_signal("disconnect")
		
	var temp = previous_ui_references.pop_back().get_ref()
	load_ui_element(temp, true)
