extends Node2D

# Declare an array to hold references to the RayCasts
@onready var raycasts: Array = [$"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8"]
@export var danger: Array = []

const DANGER_HIGH = 9
const DANGER_MEDIUM = 4

func _ready():
	danger.resize(raycasts.size())
	for i in range(danger.size()):
		danger[i] = 0  # Set default danger values
	add_exceptions_for_group("player") 

func add_exceptions_for_group(player: String):
	var players = get_tree().get_nodes_in_group(player)
	for player1 in players:
		if is_instance_valid(player1) and player1 is CollisionObject2D:
				# Add exception to each raycast
			for raycast in raycasts:
				raycast.add_exception(player1)

func _process(delta):
	# Reset the danger array every frame
	for i in range(danger.size()):
		danger[i] = 0

	for i in range(raycasts.size()):
		var raycast = raycasts[i]
		raycast.force_raycast_update()  # Update raycast

		if raycast.is_colliding():
			danger[i] = DANGER_HIGH  # Set danger to high if collision detected
			set_surrounding_danger(i)

func set_surrounding_danger(index: int):
	# Set danger for surrounding raycasts without going out of bounds
	if index > 0:
		danger[index - 1] = DANGER_MEDIUM  # Previous raycast
	else:
		danger[danger.size() - 1] = DANGER_MEDIUM  # Wrap to the last raycast

	if index < danger.size() - 1:
		danger[index + 1] = DANGER_MEDIUM  # Next raycast
	else:
		danger[0] = DANGER_MEDIUM  # Wrap to the first raycast
