extends Node2D
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var player: CharacterBody2D = $player

var players =preload("res://scenes/player.tscn")
var MonsterScene = preload("res://scenes/skeleme.tscn")
var MonsterScenes = preload("res://scenes/slime.tscn")
var paused = false
var back = false
var monster_positions = []  # List to store existing monster positions
const MIN_DISTANCE_BETWEEN_MONSTERS = 50  # Minimum distance between monsters
const MIN_PLAYER_DISTANCE = 70  # Minimum distance from the player
const SECONDARY_CHECK_DISTANCE_MODIFIER = 0.5  # Reduce minimum distances for secondary check

func _ready() -> void:
	global.current_scene = "ashland1"
	if global.past_scene=="ashland2":
		playerpos(Vector2(610, 162))
	else:
		playerpos(Vector2(14,346))
		
	randomize()
	for i in range(2):  # Spawn 10 monsters
		spawn_monster_skele()
		spawn_monster_slime()

func _process(delta):
	if back:
		change_scene_toML4()
	else:
		change_scene_toashland2()
	if Input.is_action_just_pressed('Resume'):
		pauseMenu()

func playerpos(pos):
	var instant = players.instantiate()
	instant.position= pos
	add_child(instant)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale=1
	else:
		pause_menu.show()
		Engine.time_scale=0
	paused=!paused
	
	
func change_scene_toashland2():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "ashland1":
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/Ashland2.tscn")
			
func change_scene_toML4():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "ashland1":
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land4.tscn")


func _on_transition_area_body_entered(body):
	back = false
	if body.has_method("player"):
		global.transition_scene = true


func _on_transition_to_ml_4_body_entered(body) -> void:
	back = true
	if body.has_method("player"):
		global.transition_scene = true


func is_position_valid(position: Vector2, relaxed: bool = false) -> bool:
	var min_distance_between_monsters = MIN_DISTANCE_BETWEEN_MONSTERS
	var min_player_distance = MIN_PLAYER_DISTANCE
	
	if relaxed:
		min_distance_between_monsters *= SECONDARY_CHECK_DISTANCE_MODIFIER
		min_player_distance *= SECONDARY_CHECK_DISTANCE_MODIFIER

	# Check if the position is within the navigation bounds
	# Check if the position is far enough from other monsters
	for monster_pos in monster_positions:
		if position.distance_to(monster_pos) < min_distance_between_monsters:
			print("Position too close to another monster:", position)
			return false

	# Ensure the player is valid before checking distance
	if player and position.distance_to(player.global_position) < min_player_distance:
		print("Position too close to the player:", position)
		return false
		

	return true

func spawn_monster_skele():
	# Primary check: spawn monster inside the NavigationRegion2D and validate other conditions
	for i in range(2):  # Try 100 times to find a valid spawn position
		# Get the navigation region's bounds (for random positioning within it)
		 # Get the axis-aligned bounding box of the navigation region
		# Generate a random position within the bounds
		var spawn_position = Vector2(randf_range(20,600),randf_range(75,245))
		
		# Check if the spawn position is valid (navigation region + other conditions)
		if is_position_valid(spawn_position):
			print("Spawn position found (primary):", spawn_position)
			add_monster(spawn_position)
			return

	print("Failed to spawn monster after 100 tries.")

func spawn_monster_slime():
	# Primary check: spawn monster inside the NavigationRegion2D and validate other conditions
	for i in range(2):  # Try 100 times to find a valid spawn position
		# Get the navigation region's bounds (for random positioning within it)
		 # Get the axis-aligned bounding box of the navigation region
		# Generate a random position within the bounds
		var spawn_position = Vector2(randf_range(20,600),randf_range(75,245))
		
		# Check if the spawn position is valid (navigation region + other conditions)
		if is_position_valid(spawn_position):
			print("Spawn position found (primary):", spawn_position)
			add_monster1(spawn_position)
			return

	print("Failed to spawn monster after 100 tries.")


func add_monster(position: Vector2):
	var monster = MonsterScene.instantiate()
	monster.position = position
	add_child(monster)
	monster_positions.append(position)  # Save the monster's position
	print("Monster spawned at:", position)

func add_monster1(position: Vector2):
	var monster = MonsterScenes.instantiate()
	monster.position = position
	add_child(monster)
	monster_positions.append(position)  # Save the monster's position
	print("Monster spawned at:", position)
