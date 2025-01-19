# A* Pathfinding Algorithm in GDScript

# Function to perform A* pathfinding algorithm
func AStar(start_node, end_node, grid):
	# Create open and closed sets
	var open_set = [start_node]
	var closed_set = []
	
	# Initialize g, h, and f scores for each node
	start_node.g = 0
	start_node.h = calculate_heuristic(start_node, end_node)
	start_node.f = start_node.g + start_node.h
	
	# Loop through the openSet until it's empty
	while open_set.size() > 0:
		# Get the node with the lowest f score
		var current_node = get_lowest_f_score_node(open_set)
		
		# If the current node is the end_node, we found the path
		if current_node == end_node:
			return reconstruct_path(current_node)
		
		# Move current_node from open_set to closed_set
		open_set.erase(current_node)
		closed_set.append(current_node)
		
		# Check the neighbors of current_node
		for neighbor in get_neighbors(current_node, grid):
			# If the neighbor is in the closed_set, skip it
			if neighbor in closed_set:
				continue
				
			# Calculate the tentative g score for the neighbor
			var tentative_g_score = current_node.g + calculate_distance(current_node, neighbor)
			
			# If the neighbor is not in the open_set or the new g score is better
			if not open_set.has(neighbor) or tentative_g_score < neighbor.g:
				# Update the neighbor's scores and set its parent
				neighbor.g = tentative_g_score
				neighbor.h = calculate_heuristic(neighbor, end_node)
				neighbor.f = neighbor.g + neighbor.h
				neighbor.parent = current_node
				
				# Add the neighbor to open_set if it's not already there
				if not open_set.has(neighbor):
					open_set.append(neighbor)
	
	# If there's no path found
	return []

# Function to calculate the heuristic (estimated distance to the end node)
func calculate_heuristic(node, end_node):
	return abs(node.position.x - end_node.position.x) + abs(node.position.y - end_node.position.y)  # Using Manhattan distance as heuristic

# Function to calculate the actual distance between two nodes
func calculate_distance(node1, node2):
	return abs(node1.position.x - node2.position.x) + abs(node1.position.y - node2.position.y)

# Function to get the neighbors of a node
func get_neighbors(node, grid):
	var neighbors = []
	# Get the neighboring nodes (up, down, left, right)
	for dx in [-1, 1]:
		if grid.is_walkable(node.position.x + dx, node.position.y):
			neighbors.append(grid.get_node(node.position.x + dx, node.position.y))
	for dy in [-1, 1]:
		if grid.is_walkable(node.position.x, node.position.y + dy):
			neighbors.append(grid.get_node(node.position.x, node.position.y + dy))
	return neighbors

# Function to get the node in the open set with the lowest f score
func get_lowest_f_score_node(open_set):
	var lowest = open_set[0]
	for node in open_set:
		if node.f < lowest.f:
			lowest = node
	return lowest

# Function to reconstruct the path from the end node to the start node
func reconstruct_path(node):
	var path = []
	while node != null:
		path.insert(0, node)
		node = node.parent
	return path
