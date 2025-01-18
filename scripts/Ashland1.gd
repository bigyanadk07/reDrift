extends Node2D
@onready var pause_menu = $CanvasLayer.get_node("Pause Menu")
@onready var player: CharacterBody2D = $player

var players = preload("res://scenes/player.tscn")
var MonsterScene = preload("res://scenes/skeleme.tscn")
var MonsterScenes = preload("res://scenes/slime.tscn")
var paused = false
var next_scene = ""
var monster_positions = []
const MIN_DISTANCE_BETWEEN_MONSTERS = 50
const MIN_PLAYER_DISTANCE = 70
const SECONDARY_CHECK_DISTANCE_MODIFIER = 0.5

func _ready() -> void:
	global.current_scene = "ashland1"
	if pause_menu:
		pause_menu.hide()
	
	if global.past_scene == "ashland2":
		playerpos(Vector2(610, 162))
	else:
		playerpos(Vector2(14, 346))
	
	randomize()
	for i in range(2):
		spawn_monster_skele()
		spawn_monster_slime()

func _process(_delta):
	if Input.is_action_just_pressed('Resume'):
		pauseMenu()
	
	# Only handle scene transitions when not paused
	if !paused and next_scene != "":
		handle_scene_transition()

func playerpos(pos):
	var instant = players.instantiate()
	instant.position = pos
	add_child(instant)

func pauseMenu():
	if !pause_menu:  # Skip if pause menu doesn't exist
		return
		
	paused = !paused
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1

func handle_scene_transition():
	if global.transition_scene and next_scene != "":
		global.transition_scene = false
		if global.current_scene == "ashland1":
			global.past_scene = global.current_scene
			get_tree().change_scene_to_file(next_scene)

func _on_transition_area_body_entered(body):
	if body.has_method("player"):
		next_scene = "res://scenes/WOrld/Ashland2.tscn"
		global.transition_scene = true

func _on_transition_to_ml_4_body_entered(body):
	if body.has_method("player"):
		next_scene = "res://scenes/WOrld/mystic_land4.tscn"
		global.transition_scene = true

func is_position_valid(position: Vector2, relaxed: bool = false) -> bool:
	var min_distance_between_monsters = MIN_DISTANCE_BETWEEN_MONSTERS
	var min_player_distance = MIN_PLAYER_DISTANCE
	
	if relaxed:
		min_distance_between_monsters *= SECONDARY_CHECK_DISTANCE_MODIFIER
		min_player_distance *= SECONDARY_CHECK_DISTANCE_MODIFIER

	for monster_pos in monster_positions:
		if position.distance_to(monster_pos) < min_distance_between_monsters:
			return false

	if player and position.distance_to(player.global_position) < min_player_distance:
		return false

	return true

func spawn_monster_skele():
	for i in range(2):
		var spawn_position = Vector2(randf_range(20, 600), randf_range(75, 245))
		if is_position_valid(spawn_position):
			add_monster(spawn_position)
			return

func spawn_monster_slime():
	for i in range(2):
		var spawn_position = Vector2(randf_range(20, 600), randf_range(75, 245))
		if is_position_valid(spawn_position):
			add_monster1(spawn_position)
			return

func add_monster(position: Vector2):
	var monster = MonsterScene.instantiate()
	monster.position = position
	add_child(monster)
	monster_positions.append(position)

func add_monster1(position: Vector2):
	var monster = MonsterScenes.instantiate()
	monster.position = position
	add_child(monster)
	monster_positions.append(position)
