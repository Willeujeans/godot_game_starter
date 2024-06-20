extends Control

@export var options_menu_scene: PackedScene

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		unpause()


func unpause():
	get_tree().paused = false
	queue_free()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	call_deferred("add_child", options_menu_scene.instantiate())
