extends Node

var player_current_attack = false
var health = 100
var current_scene = "world"  # Keep track of which scene is currently active
var transition_scene = false 
var past_scene 

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

func finish_changescenes3():
	print("Global change scene called, going from mystic_land3 to mystic_land4")
	current_scene = "mystic_land4"  # Update the current scene here
	
func finish_changescenes4():
	print("Global change scene called, going from mystic_land4 to ashland1")
	current_scene = "ashland1"  # Update the current scene here

func finish_changescenes5():
	print("Global change scene called, going from mystic_land4 to ashland1")
	current_scene = "lv-2" 
	
func finish_changescenes6():
	print("Global change scene called, going from mystic_land4 to ashland1")
	current_scene = "lv-2.1" 
	
func finish_changescenes7():
	print("Global change scene called, going from mystic_land4 to ashland1")
	current_scene = "ashland1" 
	
func finish_changescenes8():
	print("Global change scene called, going from mystic_land4 to ashland1")
	current_scene = "ashland1" 
