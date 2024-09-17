extends Control
@onready var player = $"../player"


func _on_play_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_multiplayer_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout


func _on_options_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/option_menu.tscn")
	


func _on_exit_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
	


func _on_how_to_pressed():
	$ButtonClickSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/Howto.tscn")
