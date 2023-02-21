extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if player.is_on_floor():
		assigned_state_machine.transfer_to("Idle")
		return
		
	do_animations.rpc()
	
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		player.velocity.x = lerp(player.velocity.x, dir * player.speed, player.air_acceleration)

@rpc("call_local")		
func do_animations() -> void:
	player.anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 1.0)	

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if (_msg.has("Jump")):
		player.velocity.y = player.jump_height

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
