extends TileMap
class_name Map

# Configuration
@export var map_name: StringName = ""
@onready var nav_point = preload("res://Entities/AI/Nav/NavPoint.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGameInformation.get_current_game_information().current_map = self
	
	# Generates nav mesh if singleplayer mode
	if (GlobalGameInformation.SINGLEPLAYER_SESSION):
		generate_ai_navmesh()

func generate_ai_navmesh() -> void:
	GlobalGameInformation.get_current_game_information().current_map_nav_mesh.clear()
	
	for tile in get_used_cells(0):
		var cell_pos = Vector2(tile.x, tile.y)
		# If a tile has air above it, add it as a nav point
		if is_above_tile_air(cell_pos):
			var marker: NavPoint = nav_point.instantiate()
			
			# If a tile has air above it and one or both sides contain air
			if (is_jump_tile(cell_pos)): 
				marker.is_jump_point = true
				
			marker.position = map_to_local(cell_pos)
			
			GlobalGameInformation.get_current_game_information().current_map_nav_mesh.append(marker)
			add_child(marker)
			
func is_above_tile_air(cell_position: Vector2) -> bool:
	if get_cell_source_id(0, Vector2(cell_position.x, cell_position.y - 1)) == -1:
		return true
	else:
		return false
	
func is_jump_tile(cell_position: Vector2) -> bool:
	if get_cell_source_id(0, Vector2(cell_position.x - 1, cell_position.y)) == -1 || get_cell_source_id(0, Vector2(cell_position.x + 1, cell_position.y)) == -1:
		return true
	else:
		return false
	
