extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_multiplayer_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/option_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_how_to_pressed():
	get_tree().change_scene_to_file("res://scenes/Howto.tscn")
