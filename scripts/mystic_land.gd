extends Node2D

func _process(delta):
	change_scene_todungeon()
	
func _on_transition_to_dungeon_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		
func _on_transition_to_dungeon_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene_todungeon():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "mystic_land":
			get_tree().change_scene_to_file("res://scenes/mystic_land2.tscn")
			global.finish_changescenes1()


