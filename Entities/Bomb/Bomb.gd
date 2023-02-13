extends RigidBody2D
class_name Bomb

@export var spin_velocity: float = 20.0
@export var toss_speed: float = 10.0
@export var bomb_damage: float = 35.0
@onready var bomb_sprite = $Sprite2D
@onready var explosion_radius: Area2D = $ExplosionRadius
@onready var explosion_vfx = preload("res://Entities/VFX/Explosion/Explosion.tscn")

@rpc("any_peer")
func explode() -> void:
	if (not is_multiplayer_authority()): return
	
	var players_affected: Array = explosion_radius.get_overlapping_bodies()
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for player in players_affected:
		var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(self.global_position, player.global_position, self.collision_mask))
		if (result && result.collider.is_in_group("Player")):
			player.take_damage.rpc_id(player.get_multiplayer_authority(), bomb_damage, \
				player.global_transform.origin.direction_to(self.global_transform.origin).normalized())
	
func bomb_effects() -> void:
	bomb_sprite.hide()
	set_deferred("freeze", true)
	set_deferred("rotation", 0)
	
	var vfx: Node2D = explosion_vfx.instantiate()
	add_child(vfx)
	
	GlobalSignals.signal_instance_particles(self.global_position, "dirt")

func _on_body_entered(body):	
	bomb_effects()
	explode.rpc()
