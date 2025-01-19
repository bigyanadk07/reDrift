extends CharacterBody2D

const speed = 5000
var enemy_inattack_range = false
var attack_cooldown = true  # Prevent attack spamming
var health = 100
var player_alive = true
var attack_ip = false

@onready var anim_tree = get_node("AnimationTree")  # AnimationTree for player animations
@onready var hit_sound_player = $HitSoundPlayer  # Sound effect when hitting an enemy
@onready var health_bar = $HealthBar  # ProgressBar for health display

func _ready():
	anim_tree.get("parameters/playback").travel("idle")
	$regen_timer.start()

func _physics_process(delta):
	update_health()
	player_movement(delta)

	if health <= 0:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")
		queue_free()

func player_movement(delta):
	if Input.is_action_just_pressed("attack") and attack_cooldown:
		anim_tree.get("parameters/playback").travel("attack")
		attack_cooldown = false
		$deal_attack_timer.start()

		# Handle attacking enemies
		var attack_area = $AttackArea
		var enemies = attack_area.get_overlapping_bodies()
		for enemy in enemies:
			if enemy.has_method("damage"):
				enemy.damage(10)  # Deal 10 damage to the enemy
				hit_sound_player.play()

	if not attack_ip:
		var input_vector = Vector2(
			Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"),
			Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
		)
		self.velocity = input_vector.normalized() * delta * speed

		if input_vector == Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("idle")
		else:
			anim_tree.get("parameters/playback").travel("walk")
			anim_tree.set("parameters/idle/blend_position", input_vector.normalized())
			anim_tree.set("parameters/walk/blend_position", input_vector.normalized())
			anim_tree.set("parameters/attack/blend_position", input_vector.normalized())

		move_and_slide()

func damage(attack_damage: int):
	health -= attack_damage
	update_health()
	if health <= 0:
		player_alive = false
		get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")
		queue_free()

func update_health():
	if health_bar:
		health_bar.value = health
		health_bar.visible = health < 100  # Optional: Hide if health is full

func _on_attack_cooldown_timeout():
	attack_cooldown = true

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	attack_ip = false

func _on_regen_timer_timeout():
	if health < 100 and health > 0:
		health += 20
	update_health()
