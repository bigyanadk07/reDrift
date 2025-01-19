extends Node2D
@onready var player: CharacterBody2D = $player
@onready var pause_menu = $"CanvasLayer/Pause Menu"
var paused = false
const players = preload("res://scenes/player.tscn")
var MonsterScene = preload("res://scenes/skeleme.tscn")
var MonsterScenes = preload("res://scenes/slime.tscn")
var transition_to
var monster_positions = []  # List to store existing monster positions
const MIN_DISTANCE_BETWEEN_MONSTERS = 50  # Minimum distance between monsters
const MIN_PLAYER_DISTANCE = 70  # Minimum distance from the player
const SECONDARY_CHECK_DISTANCE_MODIFIER = 0.5  # Reduce minimum distances for secondary check

func _ready() -> void:
	global.camera_limitb=int(1 << 31) - 1
	global.camera_limitr=int(1 << 31) - 1
	global.current_scene="lv-2"
	if global.past_scene=="lv-2.1":
		playerpos( Vector2(418, 422))
	elif global.past_scene=="lv-2_2":
		playerpos(Vector2(2607,471))
	else:
		playerpos(Vector2(146,127))
	randomize()
	for i in range(4):  # Spawn 10 monsters
		spawn_monster_skele()
		spawn_monster_slime()

func _process(_delta):
	match transition_to:
		1:
			change_scene_to_back()
		2:
			change_scene_to_Dungeon2()
		3:
			change_scene_to_Dungeon_1()
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
	

func change_scene_to_Dungeon_1():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "lv-2": 
			print("Changing scene from lv_2 to lv_2.1")
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/level-2/lv-2.1.tscn")
		else:
			print("Not in lv2, scene won't change.")
			
			

func change_scene_to_Dungeon2():
	if global.transition_scene == true:
		global.transition_scene = false
		if global.current_scene == "lv-2": 
			print("Changing scene from lv_2 to lv-2_1")
			global.past_scene=global.current_scene
			preload("res://scenes/level-2/lv_2_2.tscn")
			get_tree().change_scene_to_file("res://scenes/level-2/lv_2_2.tscn")
		else:
			print("Not in lv2, scene won't change.")

func change_scene_to_back():
	if global.transition_scene == true:
		print("Starting scene transition to mystic_land4...")
		global.transition_scene = false
		if global.current_scene == "lv-2": 
			global.camera_limitr=622
			global.camera_limitb=350
			global.past_scene=global.current_scene
			get_tree().change_scene_to_file("res://scenes/WOrld/mystic_land2.tscn")
		else:
			print("Not in lv2, scene won't change.")


func _on_transition_back_body_entered(body):
	print("body entered")
	if body.has_method("player"):
		transition_to =1
		global.transition_scene = true


func _on_transition_lv_2_1_body_entered(body) -> void:
	if body.has_method("player"):
		transition_to=2
		global.transition_scene = true
		


func _on_transition_to_lv_2_2_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		transition_to= 3
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
		var spawn_position = Vector2(randf_range(450,2547),randf_range(490,682))
		
		# Check if the spawn position is valid (navigation region + other conditions)
		if is_position_valid(spawn_position):
			print("Spawn position found (primary):", spawn_position)
			add_monster(spawn_position)
			return

	print("Failed to spawn monster after 100 tries.")

func spawn_monster_slime():
	for i in range(2):  # Try 100 times to find a valid spawn position
		# Get the navigation region's bounds (for random positioning within it)
		 # Get the axis-aligned bounding box of the navigation region
		# Generate a random position within the bounds
		var spawn_position = Vector2(randf_range(450,2547),randf_range(490,682))
		
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
