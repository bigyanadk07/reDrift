extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player

var paused = false
var back = false

func _ready() -> void:
	if global.past_scene=="mystic_land4":
		player.position = Vector2(610, 131)

func _process(delta):
	if back:
		change_scene_tomysticland2()
	else:
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
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land4.tscn")
			global.finish_changescenes3()
			
func change_scene_tomysticland2():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land3":
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land2.tscn")
			global.finish_changescenes1()


func _on_transition_to_ml_4_body_entered(body):
	back= false
	if body.has_method("player"):
		global.transition_scene = true


func _on_transition_to_ml_3_body_entered(body: Node2D) -> void:
	back = true
	if body.has_method("player"):
		global.transition_scene = true
