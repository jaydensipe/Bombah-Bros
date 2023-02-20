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
	
	session = await client.authenticate_device_async(id)
	if session.is_exception():
		printerr("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
	
	socket = Nakama.create_socket_from(client)
	
	var connected: NakamaAsyncResult = await socket.connect_async(session)
	if connected.is_exception():
		printerr("An error occurred: %s" % connected)
		return
	print("Socket connected.")
	
	return NakamaMultiplayerBridge.new(socket)
	
	
