extends Window

class DebugItem:
	var object: Object
	var property: String
	var label: Label
	
	func _init(object, property, label):
		self.object = object
		self.property = property
		self.label = label
		
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
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("OpenDebug")):
		DEBUG_MODE = !DEBUG_MODE
		debug_menu()
		
	for item in debug_items:
		item.update_label()

func debug_menu():
	if (DEBUG_MODE): self.show()
	else: self.hide()
	
func add_debug_item(object: Object, property):
	var label = Label.new()
	
	container.add_child(label)
	debug_items.append(DebugItem.new(object, property, label))
	
func _on_close_requested() -> void:
	self.hide()
