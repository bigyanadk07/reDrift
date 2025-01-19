extends Node2D

func _process(delta):
	pass

func _ready():
	if global.player:
		var player_position_x = global.player.position.x
		var player_position_y = global.player.position.y
		print(player_position_x)
		print(player_position_y)
	


func _on_map_1_to_2_body_entered(body):
	pass
 
