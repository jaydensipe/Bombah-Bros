extends VBoxContainer
class_name PlayerInformation

# Configuration
@export var host_label: bool

# Instances
@onready var username_label: Label = $Username

func set_username_text(text: String, host: bool = false):
	username_label.text = text
	
	if host:
		username_label.text = username_label.text + "👑"
		username_label.modulate = Color.GOLD
