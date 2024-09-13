extends StaticBody2D

func _process(delta):
	if $player.position.ysd > position.y:  # Player is in front of the rock
		$player.z_index = 1
		$Rock.z_index = 0
	else:  # Player is behind the rock
		$player.z_index = 0
		$Rock.z_index = 1
