extends PlayerState

# Configuration
var bomb_delay_throw_time: float = 0.2

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(delta: float) -> void:
	display_aim_line(delta)
	update_trajectory(delta)

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if (Input.is_action_just_released("Hold_Attack")):
		GlobalSignalManager.signal_throw_bomb(player.bomb_throw_location.global_position, player.get_global_mouse_position(), player.throw_power)			
		throw()

		assigned_state_machine.transfer_to("PostThrow", {Reload = true})
	
	player.throw_power = clampf(player.throw_power - 2.5, 0.0, player.MAX_THROW_POWER)
	
@rpc("call_local")
func do_animations() -> void:
	player.anim_tree.set("parameters/Movement/ChargeThrowSeek/seek_request", 0.0)
	player.anim_tree.set("parameters/Movement/MovementThrowBlend/blend_amount", 1.0)

func throw():
	if (!player.can_throw): return
	
	player.ammo_count -= 1
	player.can_throw = false
	player.throw_power = player.MAX_THROW_POWER
	
	await get_tree().create_timer(bomb_delay_throw_time).timeout
	
	player.can_throw = true

func display_aim_line(delta) -> void:
	player.aim_line.show()
	update_trajectory(delta)

func update_trajectory(delta) -> void:
	player.aim_line.clear_points()
	
	var max_points = 250
	var pos = player.bomb_throw_location.position
	var arc_height = player.get_local_mouse_position().y - player.bomb_throw_location.position.y - player.throw_power
	
	arc_height = min(arc_height, -32)
	var local_vel = PhysicsUtil.calculate_arc_velocity(pos, player.get_local_mouse_position(), arc_height)
	for i in max_points:
		player.aim_line.add_point(pos)
		local_vel.y += player.gravity * delta
		pos += local_vel * delta
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	do_animations.rpc()	
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
