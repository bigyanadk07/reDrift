extends CharacterBody2D

var attack_damage:=10.0
var knockback_force:=100.0

func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		var attack= Attack.new()
		attack.attack_damage=attack_damage
		attack.attack_position=global_position
		attack.knockback_force=knockback_force
		body.damage(attack)
		
@onready var anim_tree= get_node("AnimationTree")

var timer: Timer
var attack_time:=0.55
var attacking:bool=false
var dying:bool=false
var health:int= 100
var speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	hit(100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		anim_tree.get("parameters/playback").travel("attack")
		attacking = true
		$Timer.start(attack_time)
		
	
	if (attacking == false) and (dying==false):
		var input_vector = Vector2(
			Input.get_action_raw_strength("move_right")-Input.get_action_raw_strength("move_left"),
			Input.get_action_raw_strength("move_down")-Input.get_action_raw_strength("move_up"))
		self.velocity= input_vector*speed
		if input_vector==Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("idle")
		else:
			anim_tree.get("parameters/playback").travel("walk")
			anim_tree.set("parameters/idle/blend_position",input_vector)
			anim_tree.set("parameters/walk/blend_position",input_vector)
			anim_tree.set("parameters/attack/blend_position",input_vector)
			anim_tree.set("parameters/death/blend_position",input_vector)
			
		move_and_slide()

	


func _on_timer_timeout():
	attacking= false
func hit(damage):
	health-=damage
	if health<=0:
		dying=true
		anim_tree.get("parameters/playback").travel("death")
		await anim_tree.animation_finished
		self.queue_free()
 
