extends Control

@onready var world = $".."


func _on_resume_pressed():
	world.pauseMenu()



func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
