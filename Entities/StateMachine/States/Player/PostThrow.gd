extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	do_animations.rpc()
	clear_aim_line()
	
@rpc("call_local")
func do_animations() -> void:
	player.anim_state_machine.travel("Throw")
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Throw"):
		assigned_state_machine.transfer_to("None", { Reload = true })

func clear_aim_line() -> void:
	player.aim_line.clear_points()
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
