extends Control
@onready var world: Node2D = $"../.."

#func _ready():
	#$AnimationPlayer.play("RESET")
   
#func resume():
	#get_tree().paused= false
	#$AnimationPlayer.play_backwards("Pause_menu")
#func pause():
	#$AnimationPlayer.play("Pause_menu")
	
#func testEsc():
	#if Input.is_action_just_pressed('Resume')and !get_tree().paused:
		#pause()
	#elif Input.is_action_just_pressed("Resume")and get_tree().paused:
		#resume()
		#
#func _on_exit_pressed():
	#get_tree().change_scene_to_file("res://scenes/menu.tscn")
#
#
#func _on_resume_pressed():
	#resume()
#
#
#
func _on_restart_pressed():
	get_tree().reload_current_scene()
	world.pauseMenu()
	#
#func _process(delta):
	#testEsc()
	
func _on_resume_pressed():
	world.pauseMenu()

func _on_exit_pressed():
	get_tree().quit()
