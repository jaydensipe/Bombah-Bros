extends Node

# Configuration
var CONTROLLER_ENABLED: bool = false

# Current game information
var current_game_id: String = ""
var username: String = ""
var avatar_url: String = ""
var user_id: String = ""

func _ready() -> void:
	if (Input.get_connected_joypads().size() == 0): return
	
	CONTROLLER_ENABLED = true
