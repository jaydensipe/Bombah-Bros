extends Control

@onready var p1_health: Label = $PanelContainer/P1Container/P1Health
@onready var p2_health: Label = $PanelContainer/P2Container/P2Health

func _ready() -> void:
	GlobalSignalManager.taken_damage.connect(_handle_player_damage)

func _handle_player_damage(player_damaged: Character, _damage_taken: float) -> void:
	if (player_damaged.multiplayer.is_server()):
		health_ui_update.rpc(true, player_damaged.health)
	else:
		health_ui_update.rpc(false,  player_damaged.health)
		
	
@rpc("any_peer", "call_local")
func health_ui_update(player_one: bool, health: float):
	var text = "%s%%" % str(health).pad_decimals(1)
	var ba = int(255 * pow(2.71828, (0.001 * -1) * health))
	if player_one:
		p1_health.text = text
		p1_health.modulate = Color8(255, ba, ba, 255)
	else:
		p2_health.text = text
		p2_health.modulate = Color8(255, ba, ba, 255)
		
		
