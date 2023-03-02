extends Node2D
class_name Explosion

# Instances
@onready var explosion_audio: AudioStreamPlayer2D = $ExplosionAudio

func _ready() -> void:
	randomize()
	explosion_audio.pitch_scale = randf_range(0.7, 2.0)
	explosion_audio.play()

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if (anim_name == "Explosion"):
		get_parent().queue_free()
