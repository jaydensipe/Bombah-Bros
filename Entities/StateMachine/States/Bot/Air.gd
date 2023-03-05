extends BotState

# Configuration
var last_velocity: float = 0.0

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	bot.navigation_agent.target_position = GlobalGameInformation.current_player.global_position

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if (bot.navigation_agent.is_navigation_finished()): return
	
	if bot.is_on_floor():
		assigned_state_machine.transfer_to("Idle")
		return
	
	if bot.can_bounce:
		bounce()
	
	var dir = bot.global_position.direction_to(bot.navigation_agent.get_next_path_position())
	if dir.x != 0:
		bot.velocity.x = lerp(bot.velocity.x, dir.x * 150.0, bot.air_acceleration)
		
func bounce() -> void:
	if bot.velocity.x !=0:
		last_velocity = bot.velocity.x
	for i in range(bot.get_slide_collision_count()):
		var collision = bot.get_slide_collision(i)
		if collision.get_collider() is TileMap and not bot.is_on_floor():
			bot.velocity.x = collision.get_normal().x * abs(last_velocity) * 0.6

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if (_msg.has("Jump")):
		bot.velocity.y = bot.jump_height

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
