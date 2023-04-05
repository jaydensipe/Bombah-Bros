extends Node2D

class DebugItem:
	var object: Object
	var property: String
	var label: Label
	
	func _init(obj, prop, lab) -> void:
		self.object = obj
		self.property = prop
		self.label = lab
		
	func update_label() -> void:
		label.text = "%s: %s" % [property, str(object.get_indexed(property))]
		
# Configuration
var SHOW_DEBUG_MENU: bool = false
var SHOW_DEBUG_VIEWABLES: bool = false

# Instances
var debug_items: Array = []
@onready var container = $DebugWindow/ScrollContainer/MarginContainer/VBoxContainer
@onready var debug_window: Window = $DebugWindow
@onready var theme: Theme = load("res://Assets/GUI/Fonts/BombahBrosTheme.tres")

func _ready() -> void:
	debug_window.popup_centered()
	debug_window.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("OpenDebug")):
		SHOW_DEBUG_MENU = !SHOW_DEBUG_MENU
		debug_menu()
		
	if (Input.is_action_just_pressed("OpenDebugViewables")):
		SHOW_DEBUG_VIEWABLES = !SHOW_DEBUG_VIEWABLES
		queue_redraw()
		
	for item in debug_items:
		item.update_label()
		
	if SHOW_DEBUG_VIEWABLES:
		queue_redraw()
		
func _draw() -> void:
	if (SHOW_DEBUG_VIEWABLES):
		draw_debug_objects()
		
func display_error_dialog(text: String) -> void:
	var error_window: NativeAcceptDialog = NativeAcceptDialog.new()
	
	error_window.title = "Error!"
	error_window.dialog_icon = 2
	error_window.dialog_text = text
	
	add_child(error_window)
	error_window.show()
		
func draw_debug_objects() -> void:
	for marker in GlobalGameInformation.current_map_nav_mesh:
		draw_circle(marker.global_position, 5.0, marker.color_to_display)

func debug_menu() -> void:
	if (SHOW_DEBUG_MENU): 
		debug_window.show()
	else: 
		debug_window.hide()
	
func add_debug_item(object: Object, property, root: bool = false) -> void:
	var label = Label.new()
	
	if root:
		label.self_modulate = Color.RED
	
	container.add_child(label)
	debug_items.append(DebugItem.new(object, property, label))
	
func _on_debug_window_close_requested() -> void:
	debug_window.hide()
