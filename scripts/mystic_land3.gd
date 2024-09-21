extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"

var paused = false

func _process(delta):
	change_scene_tomysticland4()
	if Input.is_action_just_pressed('Resume'):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale=1
	else:
		pause_menu.show()
		Engine.time_scale=0
	paused=!paused

func change_scene_tomysticland4():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land3":
			get_tree().change_scene_to_file("res://scenes/mystic_land4.tscn")
			global.finish_changescenes3()

func _on_transition_to_ml_4_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
