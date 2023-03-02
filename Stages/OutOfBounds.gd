extends Area2D
class_name OutOfBounds

func _on_body_entered(body):
	if (body is Player):
		respawn.rpc_id(body.get_multiplayer_authority(), body)
		return
	
	body.queue_free()

# TEMPORARY: FIX LATER
@rpc("call_local")
func respawn(player: Player):
	player.respawn()
