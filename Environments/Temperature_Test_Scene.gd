extends Spatial

var texture = ImageTexture.new()
var tex_render = Image.new()
onready var overlay = $PanelContainer/Overlay


# Test scene for temperature sensor. An overhead view and position of the robot within the heatmap are displayed
func _ready():
	$Robot_with_sensors/Robot/TempLeft.calibrate_from_body($Temp_calibration_heatmap)
	$Robot_with_sensors/Robot/TempRight.calibrate_from_body($Temp_calibration_heatmap)
	tex_render.load("res://Assets/heatmap.png")
	tex_render.convert(Image.FORMAT_RGB8)
	texture.create_from_image(tex_render)

func _process(_delta):
	var tex_pos = $Robot_with_sensors/Robot/TempLeft.get_current_texture_pos()
	var tex_pos_r = $Robot_with_sensors/Robot/TempLeft.get_current_texture_pos()
	
	
	tex_render.lock()
	tex_render.set_pixel(tex_pos.x,tex_pos.y,Color(1,0,0,1))
	tex_render.set_pixel(tex_pos_r.x,tex_pos_r.y,Color(0,0,1,1))
	tex_render.unlock()
	
	texture.set_data(tex_render)
	
	overlay.texture = texture
	
