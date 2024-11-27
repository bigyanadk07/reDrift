extends CharacterBody2D

@onready var raycast_node = $Node  #Raycast decleration
@export var player: CharacterBody2D

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
var arrsub=[]

# For storing the danger level
var danger_array: Array = []

func _ready():
	health = MAX_HEALTH
	current_state = mobState.IDLE

func _process(delta):
	danger_array = raycast_node.danger  # Get the danger array

func _physics_process(delta):
	if is_instance_valid(player):
		var direction = (player.global_position - self.global_position).normalized()
		match current_state:
			mobState.IDLE:
				anim_tree.get("parameters/playback").travel("idle")
				velocity = Vector2(0, 0)
				anim_tree.set("parameters/idle/blend_position", direction)

			mobState.CHASING:
				arr1.clear()
				for i in arr:
					arr1.append(round((i.dot(direction)) * 100) / 100)
				var arrsub=subtract_arrays(arr1, danger_array)
				var index =get_index_of_max(arrsub)
				anim_tree.get("parameters/playback").travel("walk")
				var steering= (arr[index]-direction).normalized()
				velocity = direction + steering*1.2 # Combine direction and steering
				velocity = velocity.normalized() * speed * delta
				anim_tree.set("parameters/walk/blend_position", direction)

			mobState.ATTACKING:
				anim_tree.get("parameters/playback").travel("attack")
				velocity = Vector2(0, 0) 
				anim_tree.set("parameters/attack/blend_position", direction)

			mobState.DEATH:
				velocity = Vector2(0, 0)
				anim_tree.set("parameters/death/blend_position", direction)

		move_and_slide()  # Include velocity when moving

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

func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		queue_free()

func get_index_of_max(array: Array) -> int:
	if array.size() == 0:
		return -1  # Return -1 if the array is empty
	
	var max_index = 0
	var max_value = array[0]

	for i in range(1, array.size()):
		if array[i] > max_value:
			max_value = array[i]
			max_index = i
	
	return max_index

func subtract_arrays(array_a: Array, array_b: Array) -> Array:
	var result = []
	for i in range(array_a.size()):
		result.append(array_a[i] - array_b[i])

	return result
