extends Node2D

# Instances
@onready var main_menu_music: AudioStreamPlayer = $Music/MainMenuMusic

func _ready() -> void:
	GlobalSignalManager.main_menu_load_change.connect(_update_main_menu_music)

func _update_main_menu_music(closing) -> void:
	if closing:
		main_menu_music.stop()
		return
	
	main_menu_music.play()
