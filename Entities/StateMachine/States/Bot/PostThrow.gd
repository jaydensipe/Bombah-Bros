extends BotState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	do_animations(anim_name)
	
func do_animations(anim_name: StringName = "") -> void:
	if (anim_name == "Throw"):
		assigned_state_machine.transfer_to("Throwing")
	elif (anim_name == "FirstThrow"):
		bot.anim_tree.set("parameters/Movement/ThrowOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	do_animations("FirstThrow")
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
