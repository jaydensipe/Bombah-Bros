extends BotState

# Configuration
var bomb_delay_throw_time: float = 0.2

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	bot.throw_power = clampf(bot.throw_power - 2.5, 0.0, bot.MAX_THROW_POWER)
	
func do_animations() -> void:
	bot.anim_tree.set("parameters/Movement/ChargeThrowSeek/seek_request", 0.0)
	bot.anim_tree.set("parameters/Movement/MovementThrowBlend/blend_amount", 1.0)

func throw():
	if (!bot.can_throw): return
	
	bot.ammo_count -= 1
	bot.can_throw = false
	bot.throw_power = bot.MAX_THROW_POWER
	
	await get_tree().create_timer(bomb_delay_throw_time).timeout
	
	bot.can_throw = true
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	do_animations()
	throw()
	
	GlobalSignalManager.signal_throw_bomb(bot.bomb_throw_location.global_position, GlobalGameInformation.current_player.global_position, bot.throw_power, true)
	assigned_state_machine.transfer_to("PostThrow", {Reload = true})
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
