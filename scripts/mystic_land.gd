extends Node2D
@onready var player: CharacterBody2D = $player
@onready var pause_menu = $"CanvasLayer/Pause Menu"

var paused = false

func _ready() -> void:
	if global.past_scene=="mystic_land2":
		player.position = Vector2(608, 262)  # Change to desired position
		
func _process(delta):
	change_scene_tomysticland2()
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
	
func _on_transition_to_dungeon_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		
func change_scene_tomysticland2():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land2...")
		global.transition_scene = false
		if global.current_scene == "mystic_land":  # Only proceed if we are in 'mystic_land'
			print("Changing scene from mystic_land to mystic_land2")
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land2.tscn")
			global.past_scene=global.current_scene
			global.finish_changescenes1()  # Move to 'mystic_land2'
		else:
			print("Not in mystic_land, scene won't change.")
