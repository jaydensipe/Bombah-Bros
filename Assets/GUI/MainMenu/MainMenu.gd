extends CanvasLayer

# Signals
signal host_pressed
signal join_pressed

func _on_host_button_pressed():
	emit_signal("host_pressed")

func _on_join_button_pressed():
	emit_signal("join_pressed")
