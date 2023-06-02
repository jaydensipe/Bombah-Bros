extends CharacterBody2D
class_name Character

# Character Configuration
var lives: int = 3
var health: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_THROW_POWER: float = 150.0
var throw_power: float = MAX_THROW_POWER
var can_throw: bool = true
var can_bounce: bool = false
@export var speed: int = 150
@export var jump_height: int = -300
@export var ammo_count: int = 6
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var acceleration: float = 0.25
@export_range(0.0, 1.0) var air_acceleration: float = 0.05

func _ready() -> void:
	if (!is_multiplayer_authority()): material.set_shader_parameter("line_color", Color.RED)

# Respawns
@rpc("any_peer")
func respawn() -> void:
	GlobalSignalManager.signal_player_died(self)
	
	lives -= 1
	
	if (lives <= 0):
		GlobalSignalManager.signal_player_died(self, true)
			
	# Reset position and health
	position = Vector2.ZERO
	health = 0
	
# Set spawn position for character
@rpc("call_local", "any_peer")
func set_spawn_position(pos: Vector2) -> void:
	global_position = pos
	
# Take damage
@rpc("any_peer", "call_local")
func take_damage(damage_dealt: float, damage_pos: Vector2) -> void:
	GlobalSignalManager.signal_taken_damage(self, damage_dealt)	
	
	can_bounce = true
	health += damage_dealt
	velocity += damage_pos * (-1 * health)
	
	
	

	
