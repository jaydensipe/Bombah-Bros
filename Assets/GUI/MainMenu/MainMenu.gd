extends Control
class_name MainMenu

# Instances
@onready var title_text: Label = $TitleContainer/MarginContainer/TitleText

func _on_host_button_pressed():
	GlobalSignalManager.signal_host_game_pressed()

func _on_join_button_pressed():
	GlobalSignalManager.signal_join_pressed()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	GlobalSignalManager.signal_settings_pressed()

func _on_play_with_a_bot_button_pressed() -> void:
	GlobalSignalManager.signal_play_with_bot_pressed_pressed()
