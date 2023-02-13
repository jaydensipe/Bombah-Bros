extends RigidBody2D
class_name Player

# Player configuration
var health: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed: int = 150
@export var jump_height: int = -300
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0 , 1.0) var acceleration: float = 0.25
@export var player_state: PLAYER_STATES = PLAYER_STATES.IDLE

enum PLAYER_STATES {IDLE, IN_AIR, ON_GROUND, THROWING}

# Instances
@onready var anim_tree = $AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var body = $Body
@onready var head = $Body/Head
@onready var floor_detector = $FloorDetector
@onready var bomb_throw_location = $Body/BombSpawnPoint
@onready var walk_particles = $WalkParticles

# Signals
signal taken_damage(damage_dealt)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta) -> void:
	if (not is_multiplayer_authority()): return
	
	hold_throw()
	
func _integrate_forces(state):
	if (not is_multiplayer_authority()): return
	
	move_player(state)
	
func move_player(_state) -> void:
	# Floor detection
	if !floor_detector.is_colliding():
		set_player_state.rpc(PLAYER_STATES.IN_AIR)
	else: 
		set_player_state.rpc(PLAYER_STATES.ON_GROUND)
	
	flip_body()
	
	# Moving
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		set_axis_velocity(Vector2(lerp(linear_velocity.x, dir * speed, acceleration), 0))
	else:
		set_axis_velocity(Vector2(lerp(linear_velocity.x, 0.0, friction), 0))
		
		if (player_state == PLAYER_STATES.ON_GROUND):
			set_player_state.rpc(PLAYER_STATES.IDLE)
		
	# Jumping
	if Input.is_action_just_pressed("Jump") and (player_state == PLAYER_STATES.ON_GROUND or player_state == PLAYER_STATES.IDLE):
		set_player_state.rpc(PLAYER_STATES.IN_AIR)
		apply_central_impulse(Vector2.UP * jump_height);

@rpc("any_peer", "call_local")
func take_damage(damage_dealt: float, damage_pos: Vector2) -> void:
	health += damage_dealt
	apply_central_impulse(damage_pos * (-1 * health))

func hold_throw() -> void:
	if (Input.is_action_just_released("Hold_Attack")):
		GlobalSignals.signal_throw_bomb(bomb_throw_location.global_position, get_local_mouse_position())
		
	if (Input.is_action_pressed("Hold_Attack")):
		set_player_state.rpc(PLAYER_STATES.THROWING)
		
func flip_body() -> void:
	head.look_at(get_global_mouse_position())
	
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		body.scale.x = body.scale.y * -1
		walk_particles.process_material.direction = Vector3(20, -3, 0)
	else:
		body.scale.x = body.scale.y * 1
		walk_particles.process_material.direction = Vector3(-20, -3, 0)
	
@rpc("call_local")
func set_player_state(new_state):	
	match new_state:
		PLAYER_STATES.IDLE: 
			walk_particles.set_deferred("emitting", false)	
			
			anim_state_machine.travel("Idle")
		PLAYER_STATES.IN_AIR: 
			walk_particles.set_deferred("emitting", false)	
			
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)
		PLAYER_STATES.ON_GROUND: 
			walk_particles.set_deferred("emitting", true)	
			
			anim_state_machine.travel("RunningAndSpinning")
			anim_tree.set("parameters/RunningAndSpinning/RunTimeScale/scale", linear_velocity.x * 0.06)
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)				
		PLAYER_STATES.THROWING: 
			anim_state_machine.travel("RunningAndSpinning")	
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 1.0)	
		_:
			pass
			
	player_state = new_state
	
