extends Node2D

var attack_damage:=10.0
var knockback_force:=100.0

func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		var attack= Attack.new()
		attack.attack_damage=attack_damage
		attack.attack_position=global_position
		attack.knockback_force=knockback_force
		body.damage(attack)


var timer: Timer
var attack_time:=0.6
var attacking=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
