extends Control

@onready var p2_health: Label = $P2Health
@onready var p1_health: Label = $P1Health
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var p1_lives: TextureRect = $P1Lives
@onready var p2_lives: TextureRect = $P2Lives
@onready var p1_win_text: Label = $P1WinText
@onready var p2_win_text: Label = $P2WinText

func _ready() -> void:
	GlobalSignalManager.taken_damage.connect(_handle_player_damage)
	GlobalSignalManager.player_died.connect(_handle_player_respawn)

func _handle_player_damage(player_damaged: Character, _damage_taken: float) -> void:
	if (player_damaged.multiplayer.is_server() and !player_damaged.is_bot):
		health_ui_update.rpc(true, player_damaged.health)
	else:
		health_ui_update.rpc(false,  player_damaged.health)

func _handle_player_respawn(player_killed: Character, end: bool):
	if (player_killed.multiplayer.is_server() and !player_killed.is_bot):
		if end:
			display_winner(true)
			
		health_ui_update.rpc(true, 0, true)
	else:
		if end:
			display_winner(false)
			
		health_ui_update.rpc(false, 0, true)
	
func display_winner(player_one_died: bool) -> void:
	if player_one_died:
		p2_win_text.show()
		create_tween().tween_property(p2_win_text, "theme_override_font_sizes/font_size", 64, 0.5).set_trans(Tween.TRANS_BOUNCE)
	else:
		p1_win_text.show()
		create_tween().tween_property(p1_win_text, "theme_override_font_sizes/font_size", 64, 0.5).set_trans(Tween.TRANS_BOUNCE)
		
		
@rpc("any_peer", "call_local")
func health_ui_update(player_one: bool, health: float, death: bool = false):
	var text = "%s%%" % str(health).pad_decimals(1)
	var ba = int(255 * pow(2.71828, (0.001 * -1) * health))
	
	if player_one:
		if death:
			p1_lives.size -= Vector2(9, 0)
			
		animation_player.play("P1Damage")
		
		p1_health.text = text
		p1_health.modulate = Color8(255, ba, ba, 255)
	else:
		if death:
			p2_lives.size -= Vector2(9, 0)
			
		animation_player.play("P2Damage")
		
		p2_health.text = text
		p2_health.modulate = Color8(255, ba, ba, 255)
		
		
