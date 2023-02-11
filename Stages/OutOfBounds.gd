extends Area2D
class_name OutOfBounds

func _on_body_entered(body):
	body.queue_free()
