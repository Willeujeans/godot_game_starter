extends VBoxContainer
@export var bus_name: String = "Master"
@onready var bus_id: int = AudioServer.get_bus_index(bus_name)

func _ready():
	$Label.set_text(bus_name)


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(bus_id, value < 0.05)
