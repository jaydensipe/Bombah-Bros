extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if !player.is_on_floor():
		assigned_state_machine.transfer_to("Air")
		return
		
	do_animations.rpc()

	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
	
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		assigned_state_machine.transfer_to("Run")
	
	if Input.is_action_just_pressed("Jump"):
		assigned_state_machine.transfer_to("Air", {Jump = true})

@rpc("call_local")
func do_animations() -> void:
	player.anim_state_machine.travel("Idle")	
	
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
