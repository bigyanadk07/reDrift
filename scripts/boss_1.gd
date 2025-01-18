extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var astar = AStar2D.new()  # Pathfinding object
var path = []              # Holds the calculated path
var current_path_index = 0 # Tracks progress along the path
var speed = 100            # Movement speed
var player = null          # Reference to the player
var player_chase = false   # Should the boss chase the player?

func _ready():
	_setup_astar_grid()
	animated_sprite.play("idle")

func _setup_astar_grid():
	# Add points to the AStar2D graph (adjust positions to match your scene)
	astar.add_point(1, Vector2(100, 100))
	astar.add_point(2, Vector2(200, 100))
	astar.add_point(3, Vector2(200, 200))
	astar.add_point(4, Vector2(100, 200))

	# Connect the points (ensure they form a navigable graph)
	astar.connect_points(1, 2)
	astar.connect_points(2, 3)
	astar.connect_points(3, 4)
	astar.connect_points(4, 1)

func _physics_process(delta):
	if player_chase and player:
		_follow_player(delta)
	else:
		animated_sprite.play("idle")

func _follow_player(delta):
	# If no path exists, calculate it
	if path.empty():
		_calculate_path_to_player()

	# If there's a valid path, move toward the next point
	if path.size() > 0:
		var next_position = path[current_path_index]
		var direction = (next_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Check if we’ve reached the next position
		if global_position.distance_to(next_position) < 5:
			current_path_index += 1
			if current_path_index >= path.size():
				path.clear()  # Path is complete
				animated_sprite.play("idle")
				return

		# Update the animation
		if velocity.length() > 0:
			animated_sprite.play("walk")
			animated_sprite.flip_h = velocity.x < 0
		else:
			animated_sprite.play("idle")

func _calculate_path_to_player():
	if not player:
		return
	var boss_position = global_position
	var player_position = player.global_position

	# Find the nearest points to the boss and player
	var boss_point = astar.get_closest_point(boss_position)
	var player_point = astar.get_closest_point(player_position)

	# Calculate the shortest path
	if boss_point != -1 and player_point != -1:
		path = astar.get_point_path(boss_point, player_point)
		current_path_index = 0

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
		path.clear()
		animated_sprite.play("idle")
