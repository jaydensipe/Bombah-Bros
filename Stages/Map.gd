@tool
extends TileMap
class_name Map

# Configuration
var bot_nav_mesh: Array[Marker2D] = []
@export var map_name: StringName = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGameInformation.current_map_name = map_name
	if (GlobalGameInformation.SINGLEPLAYER_SESSION):
		generate_ai_navmesh()

func generate_ai_navmesh() -> void:
	for tile in get_used_cells(0):
		var cell_pos = Vector2(tile.x, tile.y - 1)
		if is_above_tile_air(cell_pos):
			var marker: Marker2D = Marker2D.new()
			marker.global_position = cell_pos
			bot_nav_mesh.append(marker)
			
	GlobalGameInformation.current_map_nav_mesh = bot_nav_mesh
	
func is_above_tile_air(cell_position: Vector2) -> bool:
	if get_cell_source_id(0, Vector2(cell_position.x, cell_position.y - 1)) == -1:
		return true
	else:
		return false
