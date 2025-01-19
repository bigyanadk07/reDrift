
# Function to spawn random entities in a grid-based environment
func spawn_random_entity(grid, entity_prefab, spawn_count):
	for i in range(spawn_count):
		# Randomly choose a position within the grid bounds
		var random_x = rand_range(0, grid.width - 1)
		var random_y = rand_range(0, grid.height - 1)
		
		# Check if the chosen position is walkable
		if grid.is_walkable(random_x, random_y):
			# Spawn the entity at the random position
			spawn_entity(entity_prefab, random_x, random_y)

# Function to spawn the entity at a specific position
func spawn_entity(entity_prefab, x, y):
	var entity = entity_prefab.instance()
	entity.position = Vector2(x, y)
	get_parent().add_child(entity)
