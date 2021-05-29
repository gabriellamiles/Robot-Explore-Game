extends Control

# Declare member variables here. Examples:
onready var hud1 = $MarginContainer/Panel/MarginContainer/GridContainer/Panel/MarginContainer/HUD1
onready var hud2 = $MarginContainer/Panel/MarginContainer/GridContainer/Panel2/MarginContainer/HUD2
onready var hud3 = $MarginContainer/Panel/MarginContainer/GridContainer/Panel3/MarginContainer/HUD3
onready var label_hud3 = $MarginContainer/Panel/MarginContainer/GridContainer/Panel3/MarginContainer/HUD3/Texture_info
onready var hud3_texture = $MarginContainer/Panel/MarginContainer/GridContainer/Panel3/MarginContainer/HUD3/AspectRatioContainer/Texture_display
onready var hud4 = $MarginContainer/Panel/MarginContainer/GridContainer/Panel4/MarginContainer/HUD4

onready var hud_to_id = [hud1, hud2, hud3,hud4]

var sensor_to_class = null
var sensor_descriptions = null

onready var whisker_anim = $MarginContainer/Panel/MarginContainer/GridContainer/Panel3/MarginContainer/HUD3/AspectRatioContainer/Texture_display/Whisker_animation

func _ready():
	var globals = get_node('/root/Globals')
	globals.show_joystick()
	
	if not globals.debug_mode:
		$MarginContainer/Panel/DebugTools.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sensor_to_class != null:
		for i in range(min(len(sensor_to_class), len(hud_to_id))):
			var sclass = sensor_to_class[i]
			
			var hud = hud_to_id[i]
				
			var texture = sclass.render_view()
			if texture != null:
				
				if i == 2: # whisker
					var text = sclass.render_label()
					if text =="":
						label_hud3.visible = false
					else:
						label_hud3.visible = true
						if whisker_anim.animation == "reveal":
							text = "New tactile data..."
						else:
							text = "Material = " + text
						
					_render_label_to_hud(text, label_hud3)
					hud3_texture.texture = texture
				else:
					_render_texture_to_hud(texture, hud)
			if sensor_descriptions != null:
				var sdesc = sensor_descriptions[i]
				hud.set_text(sdesc)

func set_sensor_classes(mapping):
	sensor_to_class = mapping
	
func set_sensor_descriptions(descrp):
	sensor_descriptions = descrp

func _render_texture_to_hud(texture, hud):
	var image = texture.get_data()
	var width = hud.rect_size[0]
	var height = hud.rect_size[1]
	image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	
	hud.set_render_target(itex)
	
func _render_label_to_hud(text, label):
	label.set_text(text)

func _on_toggle_background_button(button):
	var bg = $MarginContainer/Panel/Background
	bg.visible = button

func _on_ToggleHuds_toggled(button_pressed):
	$MarginContainer/Panel/MarginContainer.visible = button_pressed



func _on_WhiskerSensor_whisk_sense_new():
	whisker_anim.rotation_degrees = randi()%4*90
	whisker_anim.flip_v  = bool(randi()%2)
	whisker_anim.flip_h  = bool(randi()%2)
	whisker_anim.play("reveal")
	
func _on_Whisker_animation_animation_finished():
	whisker_anim.play("idle")

