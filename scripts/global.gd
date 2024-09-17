extends Node

var player_current_attack = false
var health = 100
var current_scene = "world"  # Keep track of which scene is currently active
var transition_scene = false 

var player: Node2D


func finish_changescenes():
	print("Global change scene called, going from world to mystic_land")
	current_scene = "mystic_land"  # Update the current scene here

func finish_changescenes1():
	print("Global change scene called, going from mystic_land to mystic_land2")
	current_scene = "mystic_land2"  # Update the current scene here

func finish_changescenes2():
	print("Global change scene called, going from mystic_land2 to mystic_land3")
	current_scene = "mystic_land3"  # Update the current scene here
