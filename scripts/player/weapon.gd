extends CharacterBody2D

# Pathfinding parameters
@export var grid_size: int = 32    # Size of grid cells for pathfinding
@export var chase_speed: float = 100.0 # Speed when chasing player
@export var detect_range: float = 300.0 # Range to start chasing player

# Attack and health parameters
var attack_damage: float = 10.0
var knockback_force: float = 100.0
var health: int = 100

# State management
var attacking: bool = false
var dying: bool = false
var is_chasing: bool = false

# Pathfinding components
var astar = AStar2D.new()
var path: Array = []
var current_path_index: int = 0

# Node references
@onready var player = get_node("/root/Main/Player")  # Adjust path as needed
@onready var tilemap = get_node("/root/Main/Obstacles")  # TileMap with obstacles
@onready var anim_tree = get_node("AnimationTree")
@onready var attack_timer = $Timer

func _ready():
	setup_astar_grid()
	# Connect the animation finished signal
	anim_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func _on_animation_tree_animation_finished():
	# Handle any cleanup or state changes after an animation completes
	if dying:
		queue_free()

func setup_astar_grid():
	# Clear any existing points
	astar.clear()
	
	# Get the tilemap's used cells (obstacles)
	var walkable_cells = get_walkable_cells()
	
	# Add points to the AStar grid
	for cell in walkable_cells:
		var point_index = get_point_index(cell)
		astar.add_point(point_index, cell * grid_size)
	
	# Connect adjacent points
	for cell in walkable_cells:
		var neighbors = get_walkable_neighbors(cell, walkable_cells)
		for neighbor in neighbors:
			var cell_index = get_point_index(cell)
			var neighbor_index = get_point_index(neighbor)
			astar.connect_points(cell_index, neighbor_index)

func get_walkable_cells() -> Array:
	# Determine walkable cells by excluding obstacle cells
	var walkable_cells: Array = []
	var world_size = get_viewport_rect().size
	
	# Create a grid of potential walkable cells
	for x in range(0, int(world_size.x / grid_size)):
		for y in range(0, int(world_size.y / grid_size)):
			var cell = Vector2(x, y)
			if not is_cell_blocked(cell):
				walkable_cells.append(cell)
	
	return walkable_cells

func is_cell_blocked(cell: Vector2) -> bool:
	# Check if a cell is blocked by an obstacle in the tilemap
	var world_pos = cell * grid_size
	var tile_pos = tilemap.world_to_map(world_pos)
	return tilemap.get_cellv(tile_pos) != -1  # -1 means no tile

func get_walkable_neighbors(cell: Vector2, walkable_cells: Array) -> Array:
	# Find adjacent walkable cells
	var neighbors: Array = []
	var directions = [
		Vector2.UP, Vector2.DOWN, 
		Vector2.LEFT, Vector2.RIGHT,
		Vector2.UP + Vector2.LEFT,
		Vector2.UP + Vector2.RIGHT,
		Vector2.DOWN + Vector2.LEFT,
		Vector2.DOWN + Vector2.RIGHT
	]
	
	for dir in directions:
		var neighbor = cell + dir
		if neighbor in walkable_cells:
			neighbors.append(neighbor)
	
	return neighbors

func get_point_index(cell: Vector2) -> int:
	# Convert cell coordinates to a unique point index
	return int(cell.x + cell.y * (get_viewport_rect().size.x / grid_size))

func find_path_to_player():
	# Find the current cell of the enemy and player
	var enemy_cell = world_to_grid(global_position)
	var player_cell = world_to_grid(player.global_position)
	
	# Get point indices for start and end
	var start_index = get_point_index(enemy_cell)
	var end_index = get_point_index(player_cell)
	
	# Clear previous path
	path.clear()
	current_path_index = 0
	
	# Check if path exists
	if astar.has_point(start_index) and astar.has_point(end_index):
		# Get the path using AStar
		var astar_path = astar.get_point_path(start_index, end_index)
		
		# Convert AStar path to grid coordinates
		for point in astar_path:
			path.append(point)

func world_to_grid(world_pos: Vector2) -> Vector2:
	# Convert world position to grid cell
	return (world_pos / grid_size).floor()

func _physics_process(_delta):
	# Update AStar grid periodically
	setup_astar_grid()
	
	# Check distance to player for chasing
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Attack logic
	if Input.is_action_just_pressed("att") and not attacking and not dying:
		anim_tree.get("parameters/playback").travel("attack")
		attacking = true
		attack_timer.start(0.55)
	
	# Pathfinding and movement logic
	if not attacking and not dying:
		if distance_to_player <= detect_range:
			# Chase player
			is_chasing = true
			
			# Recalculate path if empty or reached current path
			if path.empty() or path.size() <= current_path_index:
				find_path_to_player()
			
			# Move along the path
			if not path.empty() and current_path_index < path.size():
				var target = path[current_path_index]
				var direction = (target - global_position).normalized()
				
				# Update animation blend positions
				anim_tree.set("parameters/idle/blend_position", direction)
				anim_tree.set("parameters/walk/blend_position", direction)
				anim_tree.set("parameters/attack/blend_position", direction)
				
				# Travel animation
				anim_tree.get("parameters/playback").travel("walk")
				
				# Move towards the next path point
				velocity = direction * chase_speed
				move_and_slide()
				
				# Check if close enough to next point
				if global_position.distance_to(target) < grid_size / 2:
					current_path_index += 1
		else:
			# Idle when player is far
			is_chasing = false
			anim_tree.get("parameters/playback").travel("idle")
			velocity = Vector2.ZERO

func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.attack_position = global_position
		attack.knockback_force = knockback_force
		body.damage(attack)

func _on_timer_timeout():
	attacking = false

func hit(damage: float):
	health -= damage
	if health <= 0:
		dying = true
		anim_tree.get("parameters/playback").travel("death")
