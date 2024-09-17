extends Node2D

func _process(delta):
	change_scene_tomysticland3()
	
func _on_transition_to_below_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
	
func change_scene_tomysticland3():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land3":
			get_tree().change_scene_to_file("res://scenes/mystic_land2.tscn")
			global.finish_changescenes2()







