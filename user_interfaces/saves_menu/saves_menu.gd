extends VBoxContainer
@export var set_save_button_scene: PackedScene
@export var next_scene: PackedScene

func _ready():
	create_save_buttons()


func create_save_buttons():
	if !SaveManager.list_of_saves.is_empty():
		for each in SaveManager.list_of_saves:
			var set_save_button = set_save_button_scene.instantiate()
			var key = ResourceLoader.load(each).get_data("save_key")
			set_save_button.set_save_key(key)
			set_save_button.connect("save_was_set", func(): move_to_next_scene())
			add_child(set_save_button)


func _on_button_pressed():
	var set_save_button = set_save_button_scene.instantiate()
	set_save_button.set_save_key(SaveManager.create_new_save())
	add_child(set_save_button)


func _on_delete_all_saves_pressed():
	SaveManager.delete_all_saves()


func move_to_next_scene():
	print("NEXT SCENE")
	get_tree().get_first_node_in_group("scene_manager").change_scene(next_scene.instantiate())
