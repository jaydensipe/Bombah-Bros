extends Node

# Nakama configuration
var client: NakamaClient
var socket: NakamaSocket
var session: NakamaSession

func _ready() -> void:
	client = Nakama.create_client("01132476322718204193", "nakamabbrosdev.games", 7350, "https")

func initialize_nakama():
	# Unique ID for each player
	var id = OS.get_unique_id()
	
	# Create Nakama Session
	session = await client.authenticate_device_async(id)
	if session.is_exception():
		printerr("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
	
	# Create Nakama Socket
	socket = Nakama.create_socket_from(client)
	
	var connected: NakamaAsyncResult = await socket.connect_async(session)
	if connected.is_exception():
		printerr("An error occurred: %s" % connected)
		return
	print("Socket connected.")
	
	init_user()
	
	return NakamaMultiplayerBridge.new(socket)
	
func init_user():
	var account = await client.get_account_async(session)
	GlobalGameInformation.username = account.user.username
	GlobalGameInformation.avatar_url = account.user.avatar_url
	GlobalGameInformation.user_id = account.user.id
	
	
