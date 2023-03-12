extends BotState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	do_animations()
		
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
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	cleanup_animations()
