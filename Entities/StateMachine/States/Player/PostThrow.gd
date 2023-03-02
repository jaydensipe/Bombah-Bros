extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	clear_aim_line()
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	do_animations.rpc(anim_name)
	
@rpc("call_local", "any_peer")
func do_animations(anim_name: StringName = "") -> void:
	if (anim_name == "Throw"):
		player.anim_tree.set("parameters/Movement/MovementThrowBlend/blend_amount", 0.0)
		assigned_state_machine.transfer_to("None", { Reload = true })
	elif (anim_name == "FirstThrow"):
		player.anim_tree.set("parameters/Movement/ThrowOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func clear_aim_line() -> void:
	player.aim_line.clear_points()
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	do_animations.rpc("FirstThrow")
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
