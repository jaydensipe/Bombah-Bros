extends CharacterBody2D
class_name Player

# Player configuration
@export var speed: int = 150
@export var jump_height: int = -300
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0 , 1.0) var acceleration: float = 0.25
@export var state = PLAYER_STATES.ON_GROUND
@export var vel = self.velocity
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PLAYER_STATES {IDLE, IN_AIR, ON_GROUND, THROWING}

# Instances
@onready var anim_tree = $AnimationTree
@onready var bomb_instance = preload("res://Entities/Bomb/Bomb.tscn")
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var body = $Body
@onready var head = $Body/Head

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _physics_process(delta) -> void:
	if (not is_multiplayer_authority()): return
	
	move_player(delta)
	hold_throw()
	head.look_at(get_global_mouse_position())
	
func move_player(delta) -> void:
	if !is_on_floor():
		set_player_state.rpc(PLAYER_STATES.IN_AIR)
	else: 
		set_player_state.rpc(PLAYER_STATES.ON_GROUND)
		
	velocity.y += gravity * delta
	vel.x = velocity.x
	
	flip_body()
	
	# Moving
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
		if (state == PLAYER_STATES.ON_GROUND):
			set_player_state.rpc(PLAYER_STATES.IDLE)
		
	move_and_slide()
	
	# Jumping
	if Input.is_action_just_pressed("Jump") and (state == PLAYER_STATES.ON_GROUND or state == PLAYER_STATES.IDLE):
		set_player_state.rpc(PLAYER_STATES.IN_AIR)
		velocity.y = jump_height	

func hold_throw() -> void:
	if (Input.is_action_just_released("Hold_Attack")):
		bomb_instance.instantiate()
		
	
	if (Input.is_action_pressed("Hold_Attack")):
		set_player_state.rpc(PLAYER_STATES.THROWING)
		
func flip_body() -> void:
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		body.scale.x = body.scale.y * -1
	else:
		body.scale.x = body.scale.y * 1
	
@rpc("call_local")
func set_player_state(new_state):	
	match new_state:
		PLAYER_STATES.IDLE: 
			anim_state_machine.travel("Idle")
		PLAYER_STATES.IN_AIR: 
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)
		PLAYER_STATES.ON_GROUND: 
			anim_state_machine.travel("RunningAndSpinning")
			anim_tree.set("parameters/RunningAndSpinning/RunTimeScale/scale", vel.x * 0.04)
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)				
		PLAYER_STATES.THROWING: 
			anim_state_machine.travel("RunningAndSpinning")	
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 1.0)	
		_:
			pass
			
	state = new_state
	
