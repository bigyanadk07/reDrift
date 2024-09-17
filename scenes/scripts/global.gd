extends Node

var player_current_attack = false
var health = 100
var current_scene = "world"
var transition_scene = false 

func finish_changescenes():
	print("Global change scene called while going from world to mysticland")
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "mystic_land"
		else: 
			current_scene = "world"

func finish_changescenes1():
	print("Global change scene called while going from mysticland to mysticland2")
	if transition_scene == true:
		transition_scene = false
		if current_scene == "mystic_land":
			current_scene = "mystic_land2"
		else: 
			current_scene = "mystic_land"
			
func finish_changescenes2():
	print("Global change scene called while going from mysticland2 to mysticland3")
	if transition_scene == true:
		transition_scene = false
		if current_scene == "mystic_land2":
			current_scene = "mystic_land3"
		else: 
			current_scene = "mystic_land2"

