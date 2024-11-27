extends Node2D

@onready var pause_menu = $"CanvasLayer/Pause Menu"

var paused = false

func _ready():
	global.current_scene == "lv-2"
	
func _process(delta):
	handle_scene_transition()
	if Input.is_action_just_pressed('Resume'):
		toggle_pause_menu()

func toggle_pause_menu():
	paused = !paused
	pause_menu.visible = not paused
	
	if paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1

func _on_transition_to_below_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func handle_scene_transition():
	if global.transition_scene:
		print("Starting scene transition to mystic_land3...")
		global.transition_scene = false

		if global.current_scene == "lv-2":
			print("Changing scene from mystic_land2 to mystic_land3")
			get_tree().change_scene_to_file("res://scenes/mystic_land3.tscn")
			global.finish_changescenes2()
		else:
			print("Not in mystic_land2, scene won't change.")
