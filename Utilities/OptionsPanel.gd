extends MarginContainer

signal options_updated

onready var globals = get_node('/root/Globals')
onready var font = load("res://Assets/Fonts/NormalTextFont.tres")
func _on_FontSlider_value_changed(value):
	
	font.size = int(value)

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _ready():
	$GridContainer/VolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$GridContainer/FontSlider.value = font.size
	$GridContainer/Debug_tools.pressed = globals.debug_mode

func _on_Debug_tools_toggled(button_pressed):
	globals.debug_mode = button_pressed
	

func _on_OptionsPanel_visibility_changed():
	emit_signal("options_updated")