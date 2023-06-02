extends VBoxContainer
class_name MapSelection

# Instances
@onready var previous_map_button: Button = $ButtonContainer/PreviousMapButton
@onready var next_map_button: Button = $ButtonContainer/NextMapButton


func disable_controls() -> void:
	previous_map_button.disabled = true
	next_map_button.disabled = true
