extends Node
class_name StateMachine

# Thanks https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/ and https://youtu.be/BQwNiU5v9as
# Configuration
@export var initial_state: State
@onready var state: State = initial_state

# Signals
signal transitioned(state_name)

func _ready() -> void:
	await owner.ready
	
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.assigned_state_machine = self
	state.enter()

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _process(delta: float) -> void:
	if (not is_multiplayer_authority()): return
	state._update_process(delta)

func _physics_process(delta: float) -> void:
	if (not is_multiplayer_authority()): return
	
	state._update_physics_process(delta)

# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transfer_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
