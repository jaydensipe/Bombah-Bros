extends CharacterBody2D
class_name Character

# Character Configuration
var health: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var throw_power: float = MAX_THROW_POWER
var can_throw: bool = true
var can_bounce: bool = false
const MAX_THROW_POWER = 150.0
@export var speed: int = 150
@export var jump_height: int = -300
@export var ammo_count: int = 6
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var acceleration: float = 0.25
@export_range(0.0, 1.0) var air_acceleration: float = 0.05
