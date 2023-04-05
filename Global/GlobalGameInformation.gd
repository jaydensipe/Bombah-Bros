extends Node

# Configuration
var CONTROLLER_ENABLED: bool = false
var SINGLEPLAYER_SESSION: bool = false

# Current game information
var current_player: Player = null
var current_game_id: String = ""
var username: String = ""
var avatar_url: String = ""
var avatar_image: ImageTexture
var user_id: String = ""

# Current map information
var current_map_name: String = ""
var current_map_nav_mesh: Array[Marker2D] = []

func _ready() -> void:
	check_for_controller()
	
func check_for_controller() -> void:
	if (Input.get_connected_joypads().size() == 0): return
	
	CONTROLLER_ENABLED = true

func request_avatar(avatar_url: String) -> ImageTexture:
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	
	add_child(http_request)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var err = http_request.request(avatar_url)
	if err != OK:
		push_error("An error occurred in the HTTP request.")
		
	var body_image = await http_request.request_completed
	var body = body_image[3]
	
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	
	if error != OK:
		error = image.load_jpg_from_buffer(body)
		
	if error != OK:
		error = image.load_webp_from_buffer(body)
		
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.new()
	
	avatar_image = texture.create_from_image(image)
	avatar_image.set_size_override(Vector2i(128, 128))
	
	return avatar_image
	
