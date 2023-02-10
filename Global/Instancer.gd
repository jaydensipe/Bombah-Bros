extends Node2D
class_name Instancer

# Instances
@onready var bomb = preload("res://Entities/Bomb/Bomb.tscn")

func _ready():
	GlobalSignals.connect(GlobalSignals.THROW_BOMB, _instance_bomb)
	
func _instance_bomb(instance_pos: Vector2, throw_pos: Vector2):
	bomb_throw_instance.rpc(instance_pos, throw_pos)
	
@rpc("any_peer", "call_local")
func bomb_throw_instance(instance_pos: Vector2, throw_pos: Vector2):
	var b: Bomb = bomb.instantiate()
	
	add_child(b, true)
	b.position = instance_pos
	b.angular_velocity = b.starting_velocity
	b.apply_impulse(throw_pos * b.toss_speed)
