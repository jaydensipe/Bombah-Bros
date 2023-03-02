extends PlayerState

# Configuration
var last_velocity: float = 0.0

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if player.is_on_floor():
		assigned_state_machine.transfer_to("Idle")
		return
	
	if player.can_bounce:
		bounce()
	
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		player.velocity.x = lerp(player.velocity.x, dir * player.speed, player.air_acceleration)
		
func bounce() -> void:
	if player.velocity.x !=0:
		last_velocity = player.velocity.x
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		if collision.get_collider() is TileMap and not player.is_on_floor():
			player.velocity.x = collision.get_normal().x * abs(last_velocity) * 0.6

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if (_msg.has("Jump")):
		player.velocity.y = player.jump_height

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
