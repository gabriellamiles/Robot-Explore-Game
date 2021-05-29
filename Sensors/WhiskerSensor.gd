extends "BaseSensor.gd"

onready var bodies = []
onready var register = false
onready var globals = get_node("/root/Globals")
export onready var touching = [0, 0, 0, 0, 0, 0]

signal whisk_sense_new

func _ready():
	type = "whiskers"

func _process(delta):
	print(touching)

func _on_Area_body_entered(body):
	bodies.append(body)
	
	if not register and bodies.size() == 2: 
		register = true
		bodies.clear()
		return
	
	if register:
		emit_signal("whisk_sense_new")

func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)

func render_view():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				return c.get_active_material(0).get_texture(0)
	else:
		var image = Image.new()
		image.create(360,360,false,Image.FORMAT_RGB8)
		image.fill(Color(1, 1, 1, 1))
		var itex = ImageTexture.new()
		itex.create_from_image(image)
		return itex
		
func render_label():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				var body_name = bodies[0].name
				if body_name in globals.materials:
					return globals.materials[body_name]
				else:
					return "Unknown texture"
	else:
		return ""
	



func _on_LL_body_entered():
	touching[0] = 1


func _on_LL_body_exited():
	touching[0] = 0


func _on_LM_body_entered():
	touching[1] = 1


func _on_LM_body_exited():
	touching[1] = 0
	

func _on_LR_body_entered():
	touching[2] = 1


func _on_LR_body_exited():
	touching[2] = 0


func _on_RL_body_entered():
	touching[3] = 1
	

func _on_RL_body_exited():
	touching[3] = 0


func _on_RM_body_entered():
	touching[4] = 1


func _on_RM_body_exited():
	touching[4] = 0


func _on_RR_body_entered():
	touching[5] = 1


func _on_RR_body_exited():
	touching[5] = 0
