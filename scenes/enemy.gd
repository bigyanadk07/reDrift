extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if player_chase: 
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("move ")
		


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
