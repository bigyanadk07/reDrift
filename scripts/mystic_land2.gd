extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player
const players = preload("res://scenes/player.tscn")
var paused = false
var transition_to

func _ready() -> void:
	global.current_scene="mystic_land2"
	if global.past_scene=="mystic_land3":
		playerpos( Vector2(607, 70)) 
	elif global.past_scene=="lv-2":
		playerpos( Vector2(275, 348)) 
	else:
		playerpos(Vector2(17,21))

func _process(_delta):
	match transition_to:
		1:
			change_scene_to_back()
		2:
			change_scene_to_Dungeon()
		3:
			change_scene_tomysticland3()
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
	
func _on_transition_to_ml_3_body_entered(body):
	if body.has_method("player"):
		transition_to= 3
		global.transition_scene = true
		

func change_scene_tomysticland3():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land3...")
		global.transition_scene = false
		if global.current_scene == "mystic_land2": 
			print("Changing scene from mystic_land2 to mystic_land3")
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land3.tscn")
		else:
			print("Not in mystic_land2, scene won't change.")
			
			

func change_scene_to_Dungeon():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land3...")
		global.transition_scene = false
		if global.current_scene == "mystic_land2": 
			print("Changing scene from mystic_land2 to lv-2")
			global.past_scene=global.current_scene
			global.camera_limitr=int(1 << 31) - 1
			global.camera_limitb=int(1 << 31) - 1
			get_tree().change_scene_to_file("res://scenes/level-2/lv-2.tscn")
		else:
			print("Not in mystic_land2, scene won't change.")

func change_scene_to_back():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land2...")
		global.transition_scene = false
		if global.current_scene == "mystic_land2": 
			print("Changing scene from mystic_land3 to mysticland2")
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land.tscn")
		else:
			print("Not in mystic_land3, scene won't change.")


func _on_transition_to_lv_2_body_entered(body):
	print("body entered")
	if body.has_method("player"):
		transition_to =2
		global.transition_scene = true


func _on_transition_to_ml_1_body_entered(body) -> void:
	if body.has_method("player"):
		transition_to=1
		global.transition_scene = true
