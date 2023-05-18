extends BotState

# Configuration
var bomb_delay_throw_time: float = 0.2

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	bot.throw_power = clampf(bot.throw_power - 0.5, 0.0, bot.MAX_THROW_POWER)
	
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	bot.bomb_throw_timer.start(randf_range(bomb_delay_throw_time, bot.max_delay_between_throws))
	if(!bot.bomb_throw_timer.timeout.is_connected(_randomly_throw_bomb)):
		bot.bomb_throw_timer.timeout.connect(_randomly_throw_bomb)
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	if(!bot.bomb_throw_timer.is_stopped()):
		bot.bomb_throw_timer.stop()
	
func _randomly_throw_bomb():
	throw()

func do_animations() -> void:
	bot.anim_tree.set("parameters/Movement/ChargeThrowSeek/seek_request", 0.0)
	bot.anim_tree.set("parameters/Movement/MovementThrowBlend/blend_amount", 1.0)

func throw():
	do_animations()
	
	GlobalSignalManager.signal_throw_bomb(bot.bomb_throw_location.global_position, GlobalGameInformation.get_current_player().current_player.global_position, bot.throw_power, true)
	bot.throw_power = bot.MAX_THROW_POWER
	
	assigned_state_machine.transfer_to("PostThrow")

