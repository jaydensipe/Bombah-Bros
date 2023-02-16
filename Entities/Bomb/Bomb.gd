extends CharacterBody2D
class_name Bomb

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_exploded: bool = false
@export var spin_velocity: float = 20.0
@export var bomb_damage: float = 35.0

@onready var bomb_sprite: Sprite2D = $Sprite2D
@onready var explosion_radius: Area2D = $ExplosionRadius
@onready var explosion_vfx = preload("res://Entities/VFX/Explosion/Explosion.tscn")

func _ready():
	enable_collision_when_thrown.rpc()

@rpc("any_peer", "call_local")	
func enable_collision_when_thrown():
	await get_tree().create_timer(0.1).timeout
	set_collision_mask_value(2, true)

func _physics_process(delta):
	move(delta)

func move(delta) -> void:
	if (has_exploded): return
	
	bomb_sprite.rotate(spin_velocity * delta)
	velocity.y += gravity * delta 
	var collision = move_and_collide(velocity * delta)
	if (collision):
		has_exploded = true
		bomb_effects(collision.get_collider())
		explode.rpc()	
	
@rpc("any_peer")
func explode() -> void:
	if (not is_multiplayer_authority()): return
	
	var players_affected: Array = explosion_radius.get_overlapping_bodies()
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for player in players_affected:
		var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(self.global_position, player.global_position, self.collision_mask))
		if (result && result.collider.is_in_group("Player")):
			var distance: float = player.global_position.distance_to(self.global_position)
			player.take_damage.rpc_id(player.get_multiplayer_authority(), bomb_damage * PhysicsUtil.inverse_square_law(distance) * 100.0, \
				player.global_position.direction_to(self.global_position).normalized())
	
func bomb_effects(body) -> void:
	if (body is TileMap):
		var hit_cell = body.local_to_map(global_position)
		var cell_data = body.get_cell_tile_data(0, hit_cell)
		if (cell_data != null):
			var terrain_type = cell_data.get_custom_data("terrain_tile_type")
			GlobalSignals.signal_instance_particles(self.global_position, terrain_type)
		else:
			GlobalSignals.signal_instance_particles(self.global_position, "dirt")
	
	bomb_sprite.hide()
	
	var vfx: Node2D = explosion_vfx.instantiate()
	add_child(vfx)
	
