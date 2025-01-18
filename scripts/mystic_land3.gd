extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player
const players = preload("res://scenes/player.tscn")
var paused = false
var back = false
var should_transition = false

func _ready() -> void:
	global.current_scene = "mystic_land3"
	if global.past_scene == "mystic_land4":
		playerpos(Vector2(610, 131))
	else:
		playerpos(Vector2(18, 302))

func _process(delta):
	if should_transition:
		if back:
			change_scene_tomysticland2()
		else:
			change_scene_tomysticland4()
			
	if Input.is_action_just_pressed('Resume'):
		pauseMenu()

func playerpos(pos):
	var instant = players.instantiate()
	instant.position = pos
	add_child(instant)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func change_scene_tomysticland4():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land3":
			global.past_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land4.tscn")

func change_scene_tomysticland2():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land3":
			global.past_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land2.tscn")

func _on_transition_to_ml_4_body_entered(body):
	if body.has_method("player"):
		back = false
		global.transition_scene = true
		should_transition = true

func _on_transition_to_ml_2_body_entered(body) -> void:
	if body.has_method("player"):
		back = true
		global.transition_scene = true
		should_transition = true
