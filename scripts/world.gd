extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"

var paused = false

func _ready() -> void:
	global.past_scene=""

func _process(delta):
	change_scene_tomysticland()
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

func change_scene_tomysticland():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land...")
		global.transition_scene = false
		if global.current_scene == "world":  # Only proceed if we are in 'world'
			print("Changing scene from world to mystic_land")
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land.tscn")
			global.finish_changescenes()  # Move to 'mystic_land'
		else:
			print("Not in world, scene won't change.")

			
