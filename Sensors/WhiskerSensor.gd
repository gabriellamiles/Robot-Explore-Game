extends "BaseSensor.gd"

onready var bodies = []
onready var register = false
onready var globals = get_node("/root/Globals")

func _ready():
	type = "whiskers"

func _process(delta):
	pass

func _on_Area_body_entered(body):
	bodies.append(body)
	if not register and bodies.size() == 2:
		register = true
		bodies.clear()

func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)

func render_view():
	if bodies.size() > 0:
		for c in bodies[0].get_children():
			if c.get_class() == "MeshInstance":
				return c.get_active_material(0).get_texture(0)
