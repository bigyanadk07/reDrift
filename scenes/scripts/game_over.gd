extends Control
@onready var player = $"../player"




func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	

func _on_exit_button_pressed():
	get_tree().quit()
