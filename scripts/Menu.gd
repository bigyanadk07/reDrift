extends Control

func _on_play_pressed():
	$ButtonClickSound.play()
	get_tree().change_scene_to_file("res://scenes/WOrld/world.tscn")
	
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
	get_tree().change_scene_to_file("res://scenes/Howto.tscn")
