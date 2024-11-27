extends Node2D

var fsm: Statemachine

func enter():
	print("Hello from State 1!")
	# Exit 2 seconds later
	await get_tree().create_timer(2.0).timeout
	exit("State2")


func exit(next_state):
	fsm.change_to(next_state)


func _unhandled_key_input(event):
	if event.pressed:
		print("From State1")
