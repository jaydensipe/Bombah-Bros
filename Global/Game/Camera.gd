extends Node2D
class_name Camera

# Configuration
var shake_amount: float = 0.0
var default_offset: Vector2 = Vector2.ZERO
var shake_limit: float = 1000.00

# Instances
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	GlobalSignalManager.screen_shake.connect(_shake)
	default_offset = camera.offset
	
	set_process(false)
	
func _process(delta: float) -> void:
	camera.offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(shake_amount, -shake_amount)) * delta + default_offset
	
func _shake(new_shake: float, shake_time: float) -> void:
	get_tree().create_timer(shake_time).timeout.connect(_end_shake)
	shake_amount += new_shake
	if (shake_amount > shake_limit):
		shake_amount = shake_limit
	
	set_process(true)
	
func _end_shake() -> void:
	shake_amount = 0
	var tween = create_tween()
	
	if (tween.is_valid()):
		tween.tween_property(camera, "offset", default_offset, 0.1)
