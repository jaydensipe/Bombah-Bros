extends Node2D
class_name Explosion

# Instances
@onready var explosion_audio: AudioStreamPlayer2D = $ExplosionAudio

func _ready() -> void:
	GlobalAudioManager.play_sound_random_pitch(explosion_audio, 0.7, 2.0)

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if (anim_name == "Explosion"):
		get_parent().queue_free()
