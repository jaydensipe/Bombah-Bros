extends Control
class_name Settings

# Instances
@onready var username_line_edit: LineEdit = $PanelContainer/TabContainer/Multiplayer/ScrollContainer/MarginContainer/GridContainer/UsernameLineEdit
@onready var avatar_line_edit: LineEdit = $PanelContainer/TabContainer/Multiplayer/ScrollContainer/MarginContainer/GridContainer/AvatarLineEdit
@onready var tab_container: TabContainer = $PanelContainer/TabContainer

func _ready() -> void:
	if GlobalGameInformation.OFFLINE_MODE:
		tab_container.set_tab_disabled(3, true)
		return
		
	username_line_edit.text = GlobalGameInformation.current_player_information.username
	avatar_line_edit.text = GlobalGameInformation.current_player_information.avatar_url

func _on_save_button_pressed() -> void:
	if (GlobalGameInformation.OFFLINE_MODE):
		pass
	else:
		await NakamaIntegration.client.update_account_async(NakamaIntegration.session, username_line_edit.text, username_line_edit.text, avatar_line_edit.text)
		GlobalGameInformation.current_player_information.username = username_line_edit.text
		GlobalGameInformation.current_player_information.avatar_url = avatar_line_edit.text
	
	GlobalSignalManager.signal_game_menu_back()	
