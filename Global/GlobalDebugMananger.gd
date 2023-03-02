extends Window

class DebugItem:
	var object: Object
	var property: String
	var label: Label
	
	func _init(obj, prop, lab):
		self.object = obj
		self.property = prop
		self.label = lab
		
	func update_label():
		label.text = "%s: %s" % [property, str(object.get_indexed(property))]
		
# Configuration
var DEBUG_MODE: bool = false

# Instances
var debug_items: Array = []
@onready var container = $ScrollContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	popup_centered()
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("OpenDebug")):
		DEBUG_MODE = !DEBUG_MODE
		debug_menu()
		
	for item in debug_items:
		item.update_label()

func debug_menu():
	if (DEBUG_MODE): 
		self.show()
	else: 
		self.hide()
	
func add_debug_item(object: Object, property, root: bool = false):
	var label = Label.new()
	
	if root:
		label.self_modulate = Color.RED
	
	container.add_child(label)
	debug_items.append(DebugItem.new(object, property, label))
	
func _on_close_requested() -> void:
	self.hide()
