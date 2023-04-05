extends Marker2D
class_name NavPoint

# Configuration
var color_to_display: Color = Color.GREEN
@export var attempting_to_travel: bool = false : set = _set_attempting_to_travel
@export var is_jump_point: bool = false : set = _set_jump_point
@export var default_color: Color 
@export var jump_color: Color 
@export var selected_color: Color 
@onready var collision_shape: CollisionShape2D = $JumpPoint/CollisionShape2D

func _ready() -> void:
	if is_jump_point:
		collision_shape.disabled = false
		
func _set_attempting_to_travel(value) -> void:
	if (value):
		color_to_display = selected_color
	else:
		if (is_jump_point):
			color_to_display = jump_color
		else:
			color_to_display = default_color

func _set_jump_point(value) -> void:
	is_jump_point = value
	color_to_display = jump_color
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bot and is_jump_point:
		body.set_state("StateMachine", "Air", {Jump = true})
