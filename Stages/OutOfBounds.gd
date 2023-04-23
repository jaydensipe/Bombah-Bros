extends Area2D
class_name OutOfBounds

func _on_body_entered(body):
	if (body is Character):
		if (GlobalGameInformation.SINGLEPLAYER_SESSION):
			body.respawn()
		else:
			body.respawn.rpc_id(body.get_multiplayer_authority())
		return
	
	body.queue_free()
