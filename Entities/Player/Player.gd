extends CharacterBody2D
class_name Player

# Player configuration
var health: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var throw_power: float = MAX_THROW_POWER
var spawn_position: Vector2 = Vector2.ZERO
@export var speed: int = 150
@export var jump_height: int = -300
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var acceleration: float = 0.25
@export_range(0.0, 1.0) var air_acceleration: float = 0.05
const MAX_THROW_POWER = 150.0

# Instances
@onready var anim_tree = $Animation/AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/playback")
@onready var state_machine: StateMachine = $StateMachine
@onready var body = $Body
@onready var head = $Body/Head
@onready var bomb_throw_location = $Body/BombSpawnPoint
@onready var walk_particles = $VFX/WalkParticles
@onready var aim_line = $VFX/AimLine

# Signals
signal taken_damage(damage_dealt)
	
func _ready() -> void:
	position = spawn_position
	
func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	
func _physics_process(delta) -> void:
	if (not is_multiplayer_authority()): return
	
	move_player(delta)
	
func set_spawn_position(pos: Vector2):
	spawn_position = pos
	
func respawn():
	position = Vector2.ZERO
	health = 0
	
func move_aim_controller(delta) -> void:
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	var movement = direction * delta
	if (movement):  
		get_viewport().warp_mouse(get_global_mouse_position()+movement) 
	
func move_player(delta) -> void:
	# Apply gravity
	velocity.y += gravity * delta
	
	# Moving
	flip_body()
	move_and_slide()

@rpc("any_peer", "call_local")
func take_damage(damage_dealt: float, damage_pos: Vector2) -> void:
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
		
func display_aim_line(delta) -> void:
	aim_line.show()
	update_trajectory(delta)
		
func clear_aim_line() -> void:
	aim_line.clear_points()

func update_trajectory(delta) -> void:
	aim_line.clear_points()
	
	var max_points = 250
	var pos = bomb_throw_location.position
	var arc_height = get_local_mouse_position().y - bomb_throw_location.position.y - throw_power
	
	arc_height = min(arc_height, -32)
	var local_vel = PhysicsUtil.calculate_arc_velocity(pos, get_local_mouse_position(), arc_height)
	for i in max_points:
		aim_line.add_point(pos)
		local_vel.y += gravity * delta
		pos += local_vel * delta
