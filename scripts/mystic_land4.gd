extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player
var players = preload("res://scenes/player.tscn")
var paused = false
var next_scene = ""

func _ready() -> void:
	global.current_scene = "mystic_land4"
	pause_menu.hide()  # Ensure menu starts hidden
	print("Pause menu initialized and hidden")  # Debug print
	if global.past_scene == "ashland1":
		playerpos(Vector2(610, 303))
	else:
		playerpos(Vector2(22, 32))

func _process(delta):
	if Input.is_action_just_pressed('Resume'):
		print("Resume key pressed")  # Debug print
		pauseMenu()
	
	if !paused and next_scene != "":
		handle_scene_transition()

func playerpos(pos):
	var instant = players.instantiate()
	instant.position = pos
	add_child(instant)

func pauseMenu():
	print("pauseMenu function called")  # Debug print
	print("Current paused state:", paused)  # Debug print
	paused = !paused
	print("New paused state:", paused)  # Debug print
	
	if paused:
		print("Attempting to show pause menu")  # Debug print
		pause_menu.show()
		Engine.time_scale = 0
	else:
		print("Attempting to hide pause menu")  # Debug print
		pause_menu.hide()
		Engine.time_scale = 1
	
	print("Time scale set to:", Engine.time_scale)  # Debug print

func handle_scene_transition():
	if global.transition_scene and next_scene != "":
		global.transition_scene = false
		if global.current_scene == "mystic_land4":
			global.past_scene = global.current_scene
			get_tree().change_scene_to_file(next_scene)

func _on_trasnport_to_al_1_body_entered(body):
	if body.has_method("player"):
		next_scene = "res://scenes/WOrld/Ashland1.tscn"
		global.transition_scene = true

func _on_trasnport_to_ml_3_body_entered(body) -> void:
	if body.has_method("player"):
		next_scene = "res://scenes/WOrld/mystic_land3.tscn"
		global.transition_scene = true
