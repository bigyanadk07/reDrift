extends CharacterBody2D

@export var player:CharacterBody2D
enum mobState{
	IDLE,
	CHASING,
	ATTACKING,
	DEATH
}
@onready var anim_tree= get_node("AnimationTree")
var current_state
func damage(attack:Attack):
	health-=attack.attack_damage
	
	if health <=0:
		queue_free()
		
	taking_damage=true
	
	velocity=(global_position-attack.attack_position).normalized()*attack.knockback_force

var MAX_HEALTH:=10.0
var health
var taking_damage:=false
var speed= 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	health= MAX_HEALTH
	current_state=mobState["IDLE"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_instance_valid(player):
		var direction=(player.global_position-self.global_position).normalized()
		match current_state:
			mobState["IDLE"]:
				anim_tree.get("parameters/playback").travel("idle")
				velocity= Vector2(0,0)
				anim_tree.set("parameters/idle/blend_position",direction)
			mobState["CHASING"]:
				anim_tree.get("parameters/playback").travel("walk")
				velocity=direction*delta*speed
				anim_tree.set("parameters/walk/blend_position",direction)
			mobState["ATTACKING"]:
				anim_tree.get("parameters/playback").travel("attack")
				velocity= Vector2(0,0)
				anim_tree.set("parameters/attack/blend_position",direction)
			mobState["DEATH"]:
				velocity= Vector2(0,0)
				anim_tree.set("parameters/death/blend_position",direction)
			
	move_and_slide()

func _on_area_detection_body_entered(body):
	if body.is_in_group("player"):
		current_state= mobState["CHASING"]# Replace with function body.


func _on_area_detection_body_exited(body):
	if body.is_in_group("player"):
		current_state= mobState["IDLE"]# Replace with function body.
		



func _on_attackarea_body_entered(body):
	if body.is_in_group("player"):
		current_state=mobState["ATTACKING"]


func _on_attackarea_body_exited(body):
	if body.is_in_group("player"):
		current_state=mobState["CHASING"]


