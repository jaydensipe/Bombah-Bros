extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	do_animations.rpc(player.state_machine.state.name)
	
	if (Input.is_action_just_released("Hold_Attack")):
		GlobalSignalManager.signal_throw_bomb(player.bomb_throw_location.global_position, player.get_global_mouse_position(), player.throw_power)
		player.throw_power = player.MAX_THROW_POWER
		assigned_state_machine.transfer_to("None")
		
	player.display_aim_line(_delta)
	
	player.throw_power = clampf(player.throw_power - 2.0, 0.0, player.MAX_THROW_POWER)
	
@rpc("call_local")
func do_animations(state_name: String) -> void:
	if (state_name == "Run" || state_name == "Air"):
		player.anim_state_machine.travel("RunningAndSpinning")	
		player.anim_tree.set("parameters/RunningAndSpinning/SpinTimeScale/scale", (player.MAX_THROW_POWER + 1 - player.throw_power) * 0.1)
		player.anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 1.0)
	else:
		player.anim_state_machine.travel("RunningAndSpinning")	
		player.anim_tree.set("parameters/RunningAndSpinning/SpinTimeScale/scale", (player.MAX_THROW_POWER + 1 - player.throw_power) * 0.1)
		player.anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
