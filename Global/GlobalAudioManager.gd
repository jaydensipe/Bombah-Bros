extends Node2D

# Instances
@onready var main_menu_music: AudioStreamPlayer = $Music/MainMenuMusic

func _ready() -> void:
	GlobalSignalManager.main_menu_load_change.connect(_update_main_menu_music)

func play_sound_random_pitch(sound_to_play: AudioStreamPlayer2D, pitch_lower: float, pitch_upper: float) -> void:
	randomize()
	sound_to_play.pitch_scale = randf_range(pitch_lower, pitch_upper)
	sound_to_play.play()
	
func _update_main_menu_music(closing) -> void:
	if closing:
		main_menu_music.stop()
	else:
		main_menu_music.play()
