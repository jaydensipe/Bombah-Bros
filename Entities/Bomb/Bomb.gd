extends RigidBody2D
class_name Bomb

@export var starting_velocity: float = 20.0
@export var toss_speed: float = 10.0

func explode():
	queue_free()
	
func explode_effects():
	pass

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	explode()
	explode_effects()
