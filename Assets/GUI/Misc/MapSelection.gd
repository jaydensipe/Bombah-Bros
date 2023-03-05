extends VBoxContainer
class_name MapSelection

# Instances
@onready var button_container: HBoxContainer = $ButtonContainer

func _ready() -> void:
	if (!multiplayer.is_server()):
		button_container.hide()
