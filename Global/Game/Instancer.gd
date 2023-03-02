extends Node2D
class_name Instancer

# Instances
@onready var bomb: PackedScene = preload("res://Entities/Bomb/Bomb.tscn")
@onready var explosion_dirt: PackedScene = load("res://Entities/VFX/Explosion/Particles/Dirt/Explosions_DirtParticles.tscn")
@onready var explosion_wood: PackedScene = load("res://Entities/VFX/Explosion/Particles/Wood/Explosions_WoodParticles.tscn")

func _ready() -> void:
	GlobalSignalManager.throw_bomb.connect(_instance_bomb)
	GlobalSignalManager.instance_particles.connect(_instance_particles)
	
func _instance_bomb(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float) -> void:
	spawn_bomb_instance.rpc(instance_pos, throw_pos, throw_strength)
	
@rpc("any_peer", "call_local")
func spawn_bomb_instance(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float) -> void:
	var b: Bomb = bomb.instantiate()
	
	add_child(b, true)
	b.position = instance_pos
	
	var arc_height = throw_pos.y - instance_pos.y - throw_strength
	arc_height = min(arc_height, -32)
	b.velocity = PhysicsUtil.calculate_arc_velocity(instance_pos, throw_pos, arc_height)
	
func _instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	var explosion_particles: GPUParticles2D
	
	match terrain_type:
		EnumUtil.TerrainTypes.Dirt: explosion_particles = explosion_dirt.instantiate()
		EnumUtil.TerrainTypes.Wood: explosion_particles = explosion_wood.instantiate()
		_: 
			explosion_particles = explosion_dirt.instantiate()
			push_error("Error instancing explosion particles.")
	
	add_child(explosion_particles, true)
	explosion_particles.position = instance_pos
	explosion_particles.set_deferred("emitting", true)
