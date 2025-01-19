extends Control
@onready var player = $"../player"




func _on_main_menu_button_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
	

func _on_exit_button_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
