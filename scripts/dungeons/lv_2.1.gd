extends Node2D
@onready var player: CharacterBody2D = $player
@onready var pause_menu = $"CanvasLayer/Pause Menu"
var paused = false
const players = preload("res://scenes/player.tscn")
var transition_to


func _ready() -> void:
	global.current_scene="lv-2.1"
	playerpos(Vector2(800,164))


func _process(_delta):
	if transition_to:
		change_scene_to_back()
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
	


func change_scene_to_back():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land4...")
		global.transition_scene = false
		if global.current_scene == "lv-2.1": 
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/level-2/lv-2.tscn")
		else:
			print("Not in lv2.1, scene won't change.")


func _on_transition_back_body_entered(body):
	print("body entered")
	if body.has_method("player"):
		transition_to =1
		global.transition_scene = true
