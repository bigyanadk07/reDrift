extends CharacterBody2D



func damage(attack:Attack):
	health-=attack.attack_damage
	
	if health <=0:
		queue_free()
		
	taking_damage=true
	
	velocity=(global_position-attack.attack_position).normalized()*attack.knockback_force

var MAX_HEALTH:=10.0
var health
var taking_damage:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	health= MAX_HEALTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

