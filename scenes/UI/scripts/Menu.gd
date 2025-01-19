extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/WOrld/world.tscn")
	$ButtonClickSound.play()
	
func _on_multiplayer_pressed():
	$ButtonClickSound.play()

func _on_options_pressed():
	$ButtonClickSound.play()
	get_tree().change_scene_to_file("res://scenes/UI/option_menu.tscn")
	
func _on_exit_pressed():
	$ButtonClickSound.play()
	get_tree().quit()
	
func _on_how_to_pressed():
	$ButtonClickSound.play()
	get_tree().change_scene_to_file("res://scenes/UI/Howto.tscn")


func _on_about_pressed():
	$ButtonClickSound.play()
	get_tree().change_scene_to_file("res://scenes/UI/About.tscn")
