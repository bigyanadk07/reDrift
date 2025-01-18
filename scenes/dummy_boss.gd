extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

var movement_speed = 50.0
@export var target: Node2D = null

@onready var navigation_agent_2d = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")
	call_deferred("seeker_setup")
	pass # Replace with function body.

func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_instance_valid(target):
		animated_sprite.play("walk")  # Play walking animation if target is valid.
		navigation_agent_2d.target_position = target.global_position
	else:
		animated_sprite.play("idle")  # Play idle animation if no target.

	if navigation_agent_2d.is_navigation_finished():
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	# Move the character and flip sprite horizontally based on movement direction.
	velocity = new_velocity
	move_and_slide()

	animated_sprite.flip_h = velocity.x < 0  # Flip sprite based on velocity direction.

	pass
