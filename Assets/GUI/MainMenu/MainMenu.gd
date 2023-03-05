extends Control
class_name MainMenu

# Instances
@onready var title_text: Label = $TitleContainer/MarginContainer/TitleText

# Signals
signal host_pressed
signal join_pressed
signal settings_pressed
signal play_with_bot_pressed

func _on_host_button_pressed():
	emit_signal("host_pressed")

func _on_join_button_pressed():
	emit_signal("join_pressed")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	emit_signal("settings_pressed")

func _on_play_with_a_bot_button_pressed() -> void:
	emit_signal("play_with_bot_pressed")
