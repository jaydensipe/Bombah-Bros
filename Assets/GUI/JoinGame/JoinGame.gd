extends CanvasLayer

# Signals
signal join_pressed
signal back_pressed

# Instances
@onready var address_entry: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/EntryContainer/AddressEntry

func _on_join_button_pressed() -> void:
	emit_signal("join_pressed", address_entry.text)

func _on_back_button_pressed() -> void:
	GlobalUiManager.signal_game_menu_back()