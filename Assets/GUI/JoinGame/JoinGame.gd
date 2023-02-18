extends CanvasLayer

# Signals
signal join_pressed

# Instances
@onready var address_entry: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/AddressEntry

func _on_join_button_pressed() -> void:
	emit_signal("join_pressed", address_entry.text)
