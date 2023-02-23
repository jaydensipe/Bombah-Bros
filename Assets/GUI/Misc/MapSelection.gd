extends VBoxContainer

# Instances
@onready var button_container: HBoxContainer = $ButtonContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!is_multiplayer_authority()):
		button_container.hide()
