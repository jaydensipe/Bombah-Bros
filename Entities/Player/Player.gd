extends CharacterBody2D
class_name Player

# Player configuration
var health: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var throw_power: float = MAX_THROW_POWER
var can_throw: bool = true
var can_bounce: bool = false
@export var speed: int = 150
@export var jump_height: int = -300
@export var ammo_count: int = 6
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var acceleration: float = 0.25
@export_range(0.0, 1.0) var air_acceleration: float = 0.05
const MAX_THROW_POWER = 150.0

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

# Signals
signal taken_damage(damage_dealt)
	
func _ready() -> void:
	debug_options()
	
func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	
func _physics_process(delta) -> void:
	if (!is_multiplayer_authority()): return
	
	move_player(delta)
	controller_aim(delta)

@rpc("call_local", "any_peer")
func set_spawn_position(pos: Vector2):
	global_position = pos
	
func respawn():
	position = Vector2.ZERO
	health = 0
	
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

@rpc("any_peer", "call_local")
func take_damage(damage_dealt: float, damage_pos: Vector2) -> void:
	can_bounce = true
	
	health += damage_dealt
	velocity += damage_pos * (-1 * health)
	
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
	GlobalDebugMananger.add_debug_item(self, "position")
	GlobalDebugMananger.add_debug_item(self, "velocity")
	GlobalDebugMananger.add_debug_item(self, "ammo_count")
	GlobalDebugMananger.add_debug_item(state_machine, "state")
	GlobalDebugMananger.add_debug_item(action_state_machine, "state")
