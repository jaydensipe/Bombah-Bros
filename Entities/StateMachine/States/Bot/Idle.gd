extends BotState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if !bot.is_on_floor():
		assigned_state_machine.transfer_to("Air")
		return
		
	do_animations()

	bot.velocity.x = lerp(bot.velocity.x, 0.0, bot.friction)
	bot.can_bounce = false
	
	if !bot.player_area_detector.overlaps_body(GlobalGameInformation.current_player):
		assigned_state_machine.transfer_to("Run")

	if bot.forward_wall_detector.is_colliding() || bot.backward_wall_detector.is_colliding():
		assigned_state_machine.transfer_to("Air", {Jump = true})

func do_animations() -> void:
	bot.anim_tree.set("parameters/Movement/IdleRunBlend/blend_amount", 0.0)
	
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
