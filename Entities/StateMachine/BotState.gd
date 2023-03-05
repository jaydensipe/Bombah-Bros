extends State
class_name BotState

var bot: Bot

func _ready() -> void:
	await owner.ready
	
	bot = owner as Bot
	assert(bot != null)
