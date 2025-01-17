extends CharacterBody2D

@onready var raycast_node = $Node  # Raycast declaration
@onready var player: CharacterBody2D = $"../player"
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D  # NavigationAgent2D declaration

enum mobState {
	IDLE,
	CHASING,
	ATTACKING,
	DEATH
}

@onready var anim_tree = get_node("AnimationTree")
var current_state
var health
var MAX_HEALTH := 10.0
var speed = 3000
var arr = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
var arr1 = []
var arrsub = []
var danger_array: Array = []
var can_attack = true

func _ready():
	health = MAX_HEALTH
	current_state = mobState.IDLE
	navigation_agent.max_speed = speed
	# Create attack cooldown timer
	var timer = Timer.new()
	timer.name = "attack_cooldown"
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_attack_cooldown_timeout)

func _process(_delta):
	danger_array = raycast_node.danger

func _physics_process(delta):
	if is_instance_valid(player):
		var direction = (player.global_position - self.global_position).normalized()
		match current_state:
			mobState.IDLE:
				anim_tree.get("parameters/playback").travel("idle")
				velocity = Vector2(0, 0)
				anim_tree.set("parameters/idle/blend_position", direction)
			
			mobState.CHASING:
				navigation_agent.set_target_position(player.global_position)
				if navigation_agent.is_target_reached():
					current_state = mobState.ATTACKING
				else:
					arr1.clear()
					for i in arr:
						arr1.append(round((i.dot(direction)) * 100) / 100)
					var arrsub = subtract_arrays(arr1, danger_array)
					var index = get_index_of_max(arrsub)
					anim_tree.get("parameters/playback").travel("walk")
					var next_path_point = navigation_agent.get_next_path_position()
					direction = (next_path_point - global_position).normalized()
					var steering = ((arr[index]-direction)*2).normalized()
					var dir = direction + steering
					velocity = dir.normalized() * speed * delta
					anim_tree.set("parameters/walk/blend_position", direction.normalized())
			
			mobState.ATTACKING:
				anim_tree.get("parameters/playback").travel("attack")
				velocity = Vector2(0, 0)
				anim_tree.set("parameters/attack/blend_position", direction)
				if can_attack:
					attack_player()
					can_attack = false
					$attack_cooldown.start()
			
			mobState.DEATH:
				velocity = Vector2(0, 0)
				anim_tree.set("parameters/death/blend_position", direction)
				
		move_and_slide()

func attack_player():
	if is_instance_valid(player):
		player.health -= 10

func damage(attack: Attack):
	health -= attack.attack_damage
	# Visual feedback
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		current_state = mobState.DEATH
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_area_detection_body_entered(body):
	if body.is_in_group("player"):
		current_state = mobState.CHASING

func _on_area_detection_body_exited(body):
	if body.is_in_group("player"):
		current_state = mobState.IDLE

func _on_attackarea_body_entered(body):
	if body.is_in_group("player"):
		current_state = mobState.ATTACKING

func _on_attackarea_body_exited(body):
	if body.is_in_group("player"):
		current_state = mobState.CHASING

func get_index_of_max(array: Array) -> int:
	if array.size() == 0:
		return -1
	
	var max_index = 0
	var max_value = array[0]
	for i in range(1, array.size()):
		if array[i] > max_value:
			max_value = array[i]
			max_index = i
	
	return max_index

func subtract_arrays(array_a: Array, array_b: Array) -> Array:
	var result = []
	var max_size = max(array_a.size(), array_b.size())
	while array_a.size() < max_size:
		array_a.append(0)
	while array_b.size() < max_size:
		array_b.append(0)
	for i in range(max_size):
		result.append(array_a[i] - array_b[i])
	return result

func enemy():
	pass  # Used for method detection
