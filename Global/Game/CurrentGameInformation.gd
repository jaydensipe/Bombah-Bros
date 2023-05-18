extends Resource
class_name CurrentGameInformation

# Map Information
var current_map: Map
var current_map_nav_mesh: Array[Marker2D] = []

# Current Opponent information
var current_opponent: MultiplayerPlayer

func get_current_opponent() -> MultiplayerPlayer:
	if (current_opponent == null):
		current_opponent = MultiplayerPlayer.new()
		
	return current_opponent

func reset_opponent() -> void:
	current_opponent = null

# Game Information
var current_game_id: String = ""
