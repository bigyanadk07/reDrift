extends Node

var player_current_attack = false
var health = 100
var current_scene = "world"  # Keep track of which scene is currently active
var transition_scene = false 
var past_scene 

var player: Node2D

var camera_limitr = 622
var camera_limitb = 350
