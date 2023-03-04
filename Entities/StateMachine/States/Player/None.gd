extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if (Input.is_action_pressed("Hold_Attack") and player.ammo_count > 0 and player.can_throw):
		if (!player.wait_for_reload_timer.is_stopped()):
			player.wait_for_reload_timer.stop()
			
		assigned_state_machine.transfer_to("Throwing")
		
	clear_aim_line()
		
	
func _switch_to_reload():
	assigned_state_machine.transfer_to("Reloading")
	
func clear_aim_line() -> void:
	player.aim_line.clear_points()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if (_msg.has("Reload")):
		player.wait_for_reload_timer.start()
		if(!player.wait_for_reload_timer.timeout.is_connected(_switch_to_reload)):
			player.wait_for_reload_timer.timeout.connect(_switch_to_reload)
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
