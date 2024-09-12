extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"

var paused = false

func _process(delta):
	change_scene()
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

func _on_transitionto_dungeon_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


#func _on_transitionto_dungeon_body_exited(body):
#	if body.has_method("player"):
#		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/mini_dungeon.tscn")
			global.finish_changescenes()
			
