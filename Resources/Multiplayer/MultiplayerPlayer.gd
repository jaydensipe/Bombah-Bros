extends Resource
class_name MultiplayerPlayer

# Player Information
var current_player: Player = null
var username: String = ""
var avatar_url: String = ""
var avatar_image: ImageTexture = ImageTexture.create_from_image(load("res://icon.svg").get_image())
var user_id: String = ""
