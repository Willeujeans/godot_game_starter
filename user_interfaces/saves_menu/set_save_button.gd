extends HBoxContainer

var save_key: String = ""

func set_save_key(key: String):
	save_key = key

func _ready():
	$SetSaveButton.text = "save "
	$SetSaveButton.text += save_key
	$SetSaveButton.text += " | time: "


func _on_set_save_button_pressed():
	SaveDataManager.set_current_save(save_key)


func _on_delete_save_button_pressed():
	SaveDataManager.delete_n_save(save_key)
	queue_free()
