extends CanvasLayer

# Signals
signal host_pressed
signal join_pressed

# Instances
@onready var address_entry: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/AddressEntry

func _on_host_button_pressed():
	emit_signal("host_pressed")

func _on_join_button_pressed():
	emit_signal("join_pressed")
