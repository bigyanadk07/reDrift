extends CharacterBody2D

@onready var anim_sprite = $AnimatedSprite2D  # Adjust this if your animation node differs
@onready var player: CharacterBody2D = null  # Player will be assigned dynamically
@onready var attack_area = $AttackArea  # Area2D for detecting attack range

enum BossState {
	IDLE,
	CHASING,
	ATTACKING,
	DEATH
}

var current_state = BossState.IDLE
var speed = 100.0
var health = 50
var MAX_HEALTH = 50
var can_attack = true

func _ready():
	anim_sprite.play("idle")
	health = MAX_HEALTH
	# Add attack cooldown timer
	var timer = Timer.new()
	timer.name = "attack_cooldown"
	timer.wait_time = 2.0  # Adjust attack cooldown
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_attack_cooldown_timeout)

func _physics_process(delta):
	if current_state == BossState.IDLE:
		anim_sprite.play("idle")
	
	elif current_state == BossState.CHASING and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		anim_sprite.play("walk")
	
	elif current_state == BossState.ATTACKING and can_attack:
		attack_player()
		can_attack = false
		$attack_cooldown.start()
	
	elif current_state == BossState.DEATH:
		velocity = Vector2(0, 0)
		anim_sprite.play("death")

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		current_state = BossState.CHASING

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		current_state = BossState.IDLE

func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		current_state = BossState.ATTACKING

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		current_state = BossState.CHASING if is_instance_valid(player) else BossState.IDLE

func attack_player():
	if is_instance_valid(player):
		player.health -= 15  # Adjust damage as needed
		anim_sprite.play("attack")

func _on_attack_cooldown_timeout():
	can_attack = true

func damage(attack_damage: int):
	health -= attack_damage
	if health <= 0:
		current_state = BossState.DEATH
		queue_free()  # Remove the boss from the game
