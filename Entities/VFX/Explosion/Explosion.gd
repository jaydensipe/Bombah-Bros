extends Node2D
class_name Explosion

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Explosion"):
		get_parent().queue_free()
