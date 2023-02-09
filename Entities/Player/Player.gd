extends CharacterBody2D
class_name Player

# Player configuration
@export var speed: int = 150
@export var jump_height: int = -300
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0 , 1.0) var acceleration: float = 0.25
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_throwing: bool = false
var state = PLAYER_STATES.ON_GROUND : 
	set = set_player_state

enum PLAYER_STATES {IDLE, IN_AIR, ON_GROUND, THROWING}

# Instances
@onready var anim_tree = $AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var head = $Body/Head

func _physics_process(delta) -> void:
	move_player(delta)
	hold_throw(delta)
	head.look_at(get_global_mouse_position())
	
func move_player(delta) -> void:
	if !is_on_floor():
		state = PLAYER_STATES.IN_AIR
	else: 
		state = PLAYER_STATES.ON_GROUND
		
	velocity.y += gravity * delta
	
	# Moving
	var dir = Input.get_axis("Left", "Right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		
		flip_body(dir)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
		anim_state_machine.travel("Idle")
		
	move_and_slide()
	
	# Jumping
	if Input.is_action_just_pressed("Jump") and state == PLAYER_STATES.ON_GROUND:
		state = PLAYER_STATES.IN_AIR
		velocity.y = jump_height	
		
func hold_throw(delta) -> void:
	if (Input.is_action_pressed("Hold_Attack")):
		state = PLAYER_STATES.THROWING
		
func flip_body(dir) -> void:
	transform.x.x = dir
	head.rotation -= PI

func set_player_state(new_state):
	match new_state:
		PLAYER_STATES.IDLE: 
			anim_state_machine.travel("Idle")
		PLAYER_STATES.IN_AIR: 
			pass
		PLAYER_STATES.ON_GROUND: 
			anim_state_machine.travel("RunningAndSpinning")
			anim_tree.set("parameters/RunningAndSpinning/RunTimeScale/scale", velocity.x * 0.035)
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 0.0)
		PLAYER_STATES.THROWING: 
			anim_state_machine.travel("RunningAndSpinning")	
			anim_tree.set("parameters/RunningAndSpinning/RunSpinBlend/blend_amount", 1.0)		
		_:
			pass
			
	state = new_state
			
	
