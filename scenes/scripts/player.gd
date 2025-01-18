extends CharacterBody2D

const speed = 5000
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

@onready var anim_tree = get_node("AnimationTree")
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$regen_timer.start()
func _physics_process(delta):
	update_health()
	player_movement(delta)
	enemy_attack()
	
	# Check for game over
	if player_alive and health <= 0:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		self.queue_free()


func player_movement(delta):
	if Input.is_action_just_pressed("attack"):
		anim_tree.get("parameters/playback").travel("attack")
		global.player_current_attack = true
		attack_ip = true
		$deal_attack_timer.start()
		
		# Handle attacking enemies
		var attack_area = $AttackArea
		var enemies = attack_area.get_overlapping_bodies()
		var attack = Attack.new()
		for enemy in enemies:
			if enemy.has_method("damage"):
				enemy.damage(attack)
	
	if attack_ip == false:
		var input_vector = Vector2(
			Input.get_action_raw_strength("move_right")-Input.get_action_raw_strength("move_left"),
			Input.get_action_raw_strength("move_down")-Input.get_action_raw_strength("move_up"))
		
		self.velocity = input_vector.normalized() * delta * speed
		
		if input_vector == Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("idle")
		else:
			anim_tree.get("parameters/playback").travel("walk")
			anim_tree.set("parameters/idle/blend_position", input_vector.normalized())
			anim_tree.set("parameters/walk/blend_position", input_vector.normalized())
			anim_tree.set("parameters/attack/blend_position", input_vector.normalized())
		
		move_and_slide()

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100 and health > 0:
		health = health + 20
