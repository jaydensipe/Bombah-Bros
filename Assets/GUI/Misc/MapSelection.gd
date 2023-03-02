extends VBoxContainer
class_name MapSelection

# Instances
@onready var button_container: HBoxContainer = $ButtonContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!multiplayer.is_server()):
		button_container.hide()
