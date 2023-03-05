extends BotState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	bot.navigation_agent.target_position = GlobalGameInformation.current_player.global_position

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if (bot.navigation_agent.is_target_reached()): 
		assigned_state_machine.transfer_to("Idle")
	
	do_animations()
	
	var dir = bot.global_position.direction_to(bot.navigation_agent.get_next_path_position())
	if dir.x != 0:
		bot.velocity.x = lerp(bot.velocity.x, dir.x * 150.0, bot.acceleration)
		
	if bot.forward_wall_detector.is_colliding() || bot.backward_wall_detector.is_colliding() :
		assigned_state_machine.transfer_to("Air", {Jump = true})
		
func do_animations() -> void:
	if (bot.velocity.x > 70.0 or bot.velocity.x < -70):
		bot.walk_particles.set_deferred("emitting", true)	
				
	bot.anim_tree.set("parameters/Movement/IdleRunBlend/blend_amount", 1.0)
	bot.anim_tree.set("parameters/Movement/RunningTimeScale/scale", bot.velocity.x * 0.06)
	
func cleanup_animations() -> void:
	bot.walk_particles.set_deferred("emitting", false)
	
func play_walk_sound() -> void:
	if (bot.is_on_floor()):
		bot.walk_audio.play()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	bot.navigation_agent.target_position = GlobalGameInformation.current_player.global_position

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	cleanup_animations()

