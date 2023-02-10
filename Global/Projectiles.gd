extends Node2D
class_name Projectiles

# Instances
@onready var bomb = preload("res://Entities/Bomb/Bomb.tscn")
	
func _instance_bomb(player: Player):
	var b: Bomb = bomb.instantiate()
	
	add_child(b, true)
	b.position = player.get_node("Body/BombSpawnPoint").global_position
	b.angular_velocity = b.starting_velocity
	b.apply_impulse(get_global_mouse_position() * b.toss_speed)
