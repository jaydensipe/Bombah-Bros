extends Character
class_name Player

# Instances
@onready var aim_line: Line2D = $VFX/AimLine
@onready var anim_tree: AnimationTree = $Animation/AnimationTree
@onready var state_machine: StateMachine = $StateMachine
@onready var action_state_machine: StateMachine = $ActionStateMachine
@onready var body: Sprite2D = $Body
@onready var head: Sprite2D = $Body/Head
@onready var bomb_throw_location: Marker2D = $Body/BombSpawnPoint
@onready var walk_particles: GPUParticles2D = $VFX/WalkParticles
@onready var reload_timer: Timer = $Timers/ReloadTimer
@onready var wait_for_reload_timer: Timer = $Timers/WaitForReloadTimer
@onready var walk_audio: AudioStreamPlayer2D = $VFX/WalkAudio

	
func _ready() -> void:
	debug_options()
	
func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	GlobalGameInformation.current_player = self
	
func _physics_process(delta) -> void:
	if (!is_multiplayer_authority()): return
	
	move_player(delta)
	controller_aim(delta)
	
func controller_aim(delta) -> void:
	if (!GlobalGameInformation.CONTROLLER_ENABLED): return
	
	var direction : Vector2
	var movement : Vector2
	
	direction.x = Input.get_axis("Controller_RS_Left", "Controller_RS_Right")
	direction.y = Input.get_axis("Controller_RS_Up", "Controller_RS_Down")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	movement = 500.0 * direction * delta
	
	if (movement):
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + movement)
	
func move_player(delta) -> void:
	# Apply gravity
	velocity.y += gravity * delta
	
	# Moving
	flip_body()
	move_and_slide()

	
func flip_body() -> void:
	head.look_at(get_global_mouse_position())
	
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		body.scale.x = -1
		walk_particles.process_material.direction = Vector3(20, -3, 0)
	else:
		body.scale.x = 1
		walk_particles.process_material.direction = Vector3(-20, -3, 0)
		
func debug_options():
	if (!is_multiplayer_authority()): return
	
	GlobalDebugMananger.add_debug_item(self, "name", true)
	GlobalDebugMananger.add_debug_item(self, "health")
	GlobalDebugMananger.add_debug_item(self, "position")
	GlobalDebugMananger.add_debug_item(self, "velocity")
	GlobalDebugMananger.add_debug_item(self, "ammo_count")
	GlobalDebugMananger.add_debug_item(self, "lives")
	GlobalDebugMananger.add_debug_item(state_machine, "state")
	GlobalDebugMananger.add_debug_item(action_state_machine, "state")
