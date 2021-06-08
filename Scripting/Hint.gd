extends Spatial

export(String) var first_hint_dialog_key
export(bool) var use_next_hint =  false

export var enabled = true
export var oneshot = false
export var disable_timer = false

var current_hint_key = ""
onready var hint_timer = $HintTimer

var robot_in_zone = false

signal hint_dialog_finished

#Hints show dialog while the parent objective is enabled
#Each piece of hint dialog has two additional fields in JSON
# wait_time - float - how long to wait until the dialog is displayed 
#next_hint - array of str - an array of next possible hint options
#							allows hints to get processively more helpful
#							OR alternatively allows loops of hints to be formed
#							OR allows a large pool of possible hints to be selected from

func check_dialog_finished(dialog_key):
	if dialog_key == current_hint_key:
		emit_signal("hint_dialog_finished")

func get_hint_data(hint_dialog_key):

	if not Globals.dialog_JSON_data.has(hint_dialog_key):
		assert(true , "Error %s is not in JSON file" % hint_dialog_key)
		if Globals.dialog_JSON_data.has(first_hint_dialog_key):
			return first_hint_dialog_key
		else:
			return "hint_key_not_found"
	var data = Globals.dialog_JSON_data[hint_dialog_key]
	if not data.has("wait_time"):
		print("WARNING - hint_key %s has no wait_time field" % hint_dialog_key)
	if data.has("one_shot"):
		oneshot = data["one_shot"]
	if not oneshot and not data.has("next_hint"):
		print("WARNING - hint_key %s has no next_hint field" % hint_dialog_key)
	return data

func get_hint_wait_period(hint_dialog_key):
	return get_hint_data(hint_dialog_key)["wait_time"]
	
func get_hint_next_keys(hint_dialog_key):
	return get_hint_data(hint_dialog_key)["next_hint"]
	
func choose_next_hint(hint_dialog_key):
	var keys = get_hint_next_keys(hint_dialog_key)
	keys.erase(current_hint_key)#stop hints displaying twice
	if len(keys) > 0:
		current_hint_key = keys[randi() % keys.size()]
	else:
		print("WARNING - %s has invalid next_hint field" % current_hint_key)
func set_hint_timer(hint_dialog_key):
	if not disable_timer:
		hint_timer.wait_time = get_hint_wait_period(hint_dialog_key)
		hint_timer.start()

func _ready():
	visible = visible and Globals.show_triggers
	if Globals.dialog_JSON_data == null:
		yield(Globals,"dialog_loaded")
	if use_next_hint:
		current_hint_key = choose_next_hint(first_hint_dialog_key)
	else:
		current_hint_key = first_hint_dialog_key
	
	set_hint_timer(current_hint_key)
	
	Globals.connect("dialog_finished",self,"check_dialog_finished")
	
func show_hint():
	if enabled and robot_in_zone:
		
		Globals.queue_dialog(current_hint_key)
		yield(self,"hint_dialog_finished")
		if not oneshot:
			choose_next_hint(current_hint_key)
			set_hint_timer(current_hint_key)
		else:
			enabled = false
	else:
		set_hint_timer(current_hint_key)

func _on_Area_body_entered(body):
	if body.get_name() == ("Robot"):
		robot_in_zone = true
		if not disable_timer:
			hint_timer.connect("timeout",self,"show_hint")
			hint_timer.start()

func _on_Area_body_exited(body):
	if body.get_name() == ("Robot"):
		robot_in_zone = false
		if not disable_timer:
			hint_timer.disconnect("timeout",self,"show_hint")
			hint_timer.stop()
