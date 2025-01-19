extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player
var players= preload("res://scenes/UI/player.tscn")
var paused = false
var back = false

func _ready() -> void:
	global.current_scene = "mystic_land4"
	if global.past_scene=="ashland1":
		playerpos(Vector2(610, 303))
	else:
		playerpos(Vector2(22,32))

func _process(delta):
	if back:
		change_scene_tomysticland3()
	else:
		change_scene_toashlandland1()
	if Input.is_action_just_pressed('Resume'):
		pauseMenu()

func playerpos(pos):
	var instant = players.instantiate()
	instant.position= pos
	add_child(instant)
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale=1
	else:
		pause_menu.show()
		Engine.time_scale=0
	paused=!paused
	
	
func change_scene_toashlandland1():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land4":
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/Ashland1.tscn")


func change_scene_tomysticland3():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land4":
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land3.tscn")



func _on_trasnport_to_al_1_body_entered(body):
	back = false
	if body.has_method("player"):
		global.transition_scene = true


func _on_trasnport_to_ml_3_body_entered(body) -> void:
	back = true
	if body.has_method("player"):
		global.transition_scene = true
