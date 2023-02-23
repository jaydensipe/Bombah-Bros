extends VBoxContainer

# Configuration
@export var host_label: bool

# Instances
@onready var username_label: Label = $Username

func _ready() -> void:
	if (host_label):
		username_label.text = GlobalGameInformation.username + "👑"
		username_label.modulate = Color.GOLD

func set_username_text(text: String):
	if (host_label):
		return
		
	username_label.text = text
