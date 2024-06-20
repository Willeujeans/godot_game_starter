@tool
extends Node

const SAVE_PATH: String = "user://saves/"
var current_save_path: String
var current_storage: Storage

func _ready():
	if !Engine.is_editor_hint():
		check_for_save_folder()
		check_for_saves()
		set_current_save(0)


# getters
func get_data(key):
	if current_storage.get_data(key):
		return current_storage.get_data(key)


func get_files_in_folder(path: String)->Array:
	var files = []
	var directory = DirAccess.open(path)
	if directory:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			files.append(path + file_name)
			file_name = directory.get_next()
	else:
		print("save_data_manager | ERROR: could not access path [" + path +"]")
	return files


# setters
func set_current_save(number: int):
	print("save_data_manager | setting current save [" + str(number) + "]")
	current_save_path = SAVE_PATH + "save" + str(number) + ".tres"


func set_current_storage(new_storage: Storage):
	current_storage = new_storage


func check_for_save_folder():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(SAVE_PATH):
		print("save_data_manager | checking for save folder [false]")
		print("save_data_manager | creating save folder [" + SAVE_PATH + "]")
		dir.make_dir(SAVE_PATH)
	else:
		print("save_data_manager | checking for save folder [true]")


func check_for_saves():
	var list_of_saves: Array = get_files_in_folder(SAVE_PATH)
	if list_of_saves.is_empty():
		print("save_data_manager | checking for save files [false]")
		create_new_save()
	else:
		print("save_data_manager | checking for save files [true]")
		set_current_save(0)
		set_current_storage(ResourceLoader.load(current_save_path))


func create_new_save():
	var save_number: int = get_files_in_folder(SAVE_PATH).size()
	print("save_data_manager | creating new save [" + str(save_number) + "]")	
	set_current_save(save_number)
	var new_storage = Storage.new()
	ResourceSaver.save(new_storage, current_save_path)
	set_current_storage(new_storage)
	add_to_save("save_number", save_number)
	print("save_data_manager | created save file.")	

func add_to_save(key: String, value):
	current_storage.add_data(key, value)


func write_save_to_disc():
	ResourceSaver.save(current_storage, current_save_path)


func save_all_nodes():
	for node in get_tree().get_nodes_in_group("save_node"):
		if node.save_active:
			current_storage.add_data(node.get_key(), node.get_saved_variables())


func load_all_nodes():
	for node in get_tree().get_nodes_in_group("save_node"):
		node.load_saved_variables()


func save_current_game():
	print("save_data_manager | saving game...")
	save_all_nodes()
	write_save_to_disc()
	print("save_data_manager | saved game.")
	


func load_current_save():
	print("save_data_manager | loading game [" + current_save_path + "]")
	current_storage = ResourceLoader.load(current_save_path)
	load_all_nodes()
	print("save_data_manager | loaded game.")


func delete_save_node_data(key: String):
	if Engine.is_editor_hint():
		print("save_data_manager | deleting data from <"+key+">")
		current_storage.erase(key)
		print("save_data_manager | deleted data.")
