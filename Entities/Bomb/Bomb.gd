extends CharacterBody2D
class_name Bomb

# Configuration
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_exploded: bool = false
@export var spin_velocity: float = 20.0
@export var bomb_damage: float = 75.0
@export var screen_shake_amount: float = 250.0

# Instances
@onready var bomb_sprite: Sprite2D = $Sprite2D
@onready var explosion_radius: Area2D = $ExplosionRadius
@onready var explosion_vfx: PackedScene = preload("res://Entities/VFX/Explosion/Explosion.tscn")

func _ready() -> void:
	enable_collision_when_thrown()

func enable_collision_when_thrown():
	await get_tree().create_timer(0.1).timeout
	set_collision_mask_value(EnumUtil.PhysicsLayers.Player, true)

func _physics_process(delta) -> void:
	move(delta)

func move(delta) -> void:
	if (has_exploded): return
	
	# Spin and apply gravity
	bomb_sprite.rotate(spin_velocity * delta)
	velocity.y += gravity * delta 
	var collision = move_and_collide(velocity * delta)
	
	if (collision):
		has_exploded = true
		
		# If we are against a bot, handle local explosion
		if (GlobalGameInformation.SINGLEPLAYER_SESSION):
			explode()
		else:
			explode.rpc()
			
		bomb_effects(collision.get_collider(), collision.get_collider_rid())		
	
@rpc("any_peer")
func explode() -> void:
	if (!multiplayer.is_server()): return
	
	var players_affected: Array = explosion_radius.get_overlapping_bodies()
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for player in players_affected:
		# Determines if player should be hit by using a raycast
		var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(self.global_position, player.global_position, self.collision_mask))
		
		# Does damage to hit player and calculates damage falloff
		if (result && result.collider.is_in_group("Player")):
			var distance: float = player.global_position.distance_to(self.global_position)
			
			# If we are against a bot, do not send RPC
			if (GlobalGameInformation.SINGLEPLAYER_SESSION):
				player.take_damage(bomb_damage * PhysicsUtil.inverse_square_law(distance) * 100.0, \
					player.global_position.direction_to(self.global_position).normalized())
			else:
				player.take_damage.rpc_id(player.get_multiplayer_authority(), bomb_damage * PhysicsUtil.inverse_square_law(distance) * 100.0, \
					player.global_position.direction_to(self.global_position).normalized())
	
func bomb_effects(body, body_rid) -> void:
	GlobalSignalManager.signal_screen_shake(screen_shake_amount, 0.05)
	
	if (body is TileMap):
		# Determines projectile based on hit terrain type
		var tile_map: TileMap = body
		var hit_cell = tile_map.get_coords_for_body_rid(body_rid)
		var cell_data = tile_map.get_cell_tile_data(0, hit_cell)
		if (cell_data != null):
			GlobalSignalManager.signal_instance_particles(self.global_position, cell_data.get_custom_data("terrain_tile_type"))
		else:
			GlobalSignalManager.signal_instance_particles(self.global_position, EnumUtil.TerrainTypes.Dirt)
	
	bomb_sprite.hide()
	
	var vfx: Node2D = explosion_vfx.instantiate()
	add_child(vfx)
