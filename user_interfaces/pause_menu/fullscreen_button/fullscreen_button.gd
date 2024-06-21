extends Button
@export var fullscreen_icon: Texture2D
@export var unfullscreen_icon: Texture2D

func _ready():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		set_button_icon(unfullscreen_icon)
	else:
		set_button_icon(fullscreen_icon)


func _on_pressed():
	swap_fullscreen_mode()


func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		set_button_icon(fullscreen_icon)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		set_button_icon(unfullscreen_icon)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
