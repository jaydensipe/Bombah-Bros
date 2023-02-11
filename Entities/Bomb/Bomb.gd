extends RigidBody2D
class_name Bomb

@export var starting_velocity: float = 20.0
@export var toss_speed: float = 10.0
@export var bomb_damage: float = 35.0
@onready var bomb_sprite = $Sprite2D
@onready var explosion_radius: Area2D = $ExplosionRadius
@onready var explosion_vfx = preload("res://Entities/VFX/Explosion/Explosion.tscn")

@rpc("any_peer")
func explode():
	if (not is_multiplayer_authority()): return
	
	var players_affected: Array = explosion_radius.get_overlapping_bodies()
	for player in players_affected:
		player.set_deferred("lock_rotation", false)
		player.take_damage.rpc_id(player.get_multiplayer_authority(), bomb_damage, \
			player.global_transform.origin.direction_to(self.global_transform.origin).normalized())
	
func bomb_effects():
	bomb_sprite.hide()
	set_deferred("freeze", true)
	set_deferred("rotation", 0)
	
	var vfx: Node2D = explosion_vfx.instantiate()
	add_child(vfx)

func _on_body_entered(body):	
	bomb_effects()
	explode.rpc()
