extends CharacterBody2D

const speed = 100

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var attack_ip = false
@onready var anim_tree = get_node("AnimationTree")

var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$regen_timer.start()
	global.player = self



func _physics_process(delta):
	update_health()
	player_movement(delta)
	enemy_attack()
	#attack()
	
	if global.health <= 0:
		player_alive = false
		global.health = 0
		self.queue_free()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		


func player_movement(delta):
	if Input.is_action_just_pressed("attack"):
		anim_tree.get("parameters/playback").travel("attack")
		global.player_current_attack = true
		attack_ip = true
		$deal_attack_timer.start()
		
	
	if attack_ip == false:
		var input_vector = Vector2(
			Input.get_action_raw_strength("move_right")-Input.get_action_raw_strength("move_left"),
			Input.get_action_raw_strength("move_down")-Input.get_action_raw_strength("move_up")).normalized()
		self.velocity= input_vector*speed
		if input_vector==Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("idle")
		else:
			anim_tree.get("parameters/playback").travel("walk")
			anim_tree.set("parameters/idle/blend_position",input_vector)
			anim_tree.set("parameters/walk/blend_position",input_vector)
			anim_tree.set("parameters/attack/blend_position",input_vector)
			
		move_and_slide()
		
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
			
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")
				

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
		global.health = global.health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(global.health)
	

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false


func update_health():
	var healthbar = $HealthBar
	healthbar.value = global.health
	if global.health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if global.health < 100 and global.health > 0:
		global.health = global.health + 20
