extends Node2D
class_name Instancer

# Instances
@onready var bomb = preload("res://Entities/Bomb/Bomb.tscn")
@onready var explosion_dirt = load("res://Entities/VFX/Explosion/Particles/Dirt/Explosions_Dirt.tscn")

func _ready():
	GlobalSignals.connect(GlobalSignals.THROW_BOMB, _instance_bomb)
	GlobalSignals.connect(GlobalSignals.INSTANCE_PARTICLES, _instance_particles)
	
func _instance_bomb(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float) -> void:
	spawn_bomb_instance.rpc(instance_pos, throw_pos, throw_strength)
	
@rpc("any_peer", "call_local")
func spawn_bomb_instance(instance_pos: Vector2, throw_pos: Vector2, throw_strength: float):
	var b: Bomb = bomb.instantiate()
	
	add_child(b, true)
	b.position = instance_pos
	
	var arc_height = throw_pos.y - instance_pos.y - throw_strength
	arc_height = min(arc_height, -32)
	b.velocity = PhysicsUtil.calculate_arc_velocity(instance_pos, throw_pos, arc_height)
	
func _instance_particles(instance_pos: Vector2, terrain_type: String) -> void:
	var e_d: GPUParticles2D
	
	match terrain_type:
		"dirt": e_d = explosion_dirt.instantiate()
		_: printerr("Error instancing explosion particles")
	
	add_child(e_d, true)
	e_d.position = instance_pos
	e_d.set_deferred("emitting", true)
