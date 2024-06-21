extends VBoxContainer
@export var set_save_button_scene: PackedScene

func _ready():
	create_save_buttons()


func create_save_buttons():
	if !SaveDataManager.list_of_saves.is_empty():
		for each in SaveDataManager.list_of_saves:
			print(each)
			var set_save_button = set_save_button_scene.instantiate()
			var key = ResourceLoader.load(each).get_data("save_key")
			set_save_button.set_save_key(key)
			add_child(set_save_button)


func _on_button_pressed():
	var set_save_button = set_save_button_scene.instantiate()
	set_save_button.set_save_key(SaveDataManager.create_new_save())
	add_child(set_save_button)


func _on_delete_all_saves_pressed():
	SaveDataManager.delete_all_saves()
