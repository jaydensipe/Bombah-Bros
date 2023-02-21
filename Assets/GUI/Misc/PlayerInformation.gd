extends VBoxContainer

# Configuration
@export var host_label: bool

# Instances
@onready var username_label: Label = $Username

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (host_label):
		username_label.text = GlobalGameInformation.username

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_username_text(text: String):
	username_label.text = text
