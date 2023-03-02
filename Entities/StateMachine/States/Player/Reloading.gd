extends PlayerState

# Virtual function. Corresponds to the `_process()` callback.
func _update_process(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _update_physics_process(_delta: float) -> void:
	if (Input.is_action_pressed("Hold_Attack") and player.ammo_count > 0 and player.can_throw):
		if (!player.reload_timer.is_stopped()):
			player.reload_timer.stop()
			
		assigned_state_machine.transfer_to("Throwing")
		
func _start_reloading():
	if (player.ammo_count >= 6):
		player.reload_timer.stop()
		assigned_state_machine.transfer_to("None")
		return
		
	player.ammo_count += 1
#	player.player_sound.pitch_scale = (player.ammo_count / 3.0)
		
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.reload_timer.start()
	if (!player.reload_timer.timeout.is_connected(_start_reloading)):
		player.reload_timer.timeout.connect(_start_reloading)
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

