extends BotState

# Configuration
var last_velocity: float = 0.0
var dir: Vector2 = Vector2.ZERO

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if bot.can_bounce:
		bounce()
		
	bot.acceleration = bot.air_acceleration
		
func bounce() -> void:
	if bot.velocity.x != 0:
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
