extends Node

# Configuration
var CONTROLLER_ENABLED: bool = false
var SINGLEPLAYER_SESSION: bool = false

# Current game information
var current_player: Player = null
var current_game_id: String = ""
var username: String = ""
var avatar_url: String = ""
var user_id: String = ""

# Current map information
var current_map_name: String = ""
var current_map_nav_mesh: Array[Marker2D] = []

func _ready() -> void:
	check_for_controller()
	
func check_for_controller() -> void:
	if (Input.get_connected_joypads().size() == 0): return
	
	CONTROLLER_ENABLED = true
	
# Bot information
func pick_random_nav_mesh_point() -> Vector2: 
	return GlobalGameInformation.current_map_nav_mesh.pick_random().global_position
