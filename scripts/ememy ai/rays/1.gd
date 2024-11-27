extends Node2D

@export var raycast : RayCast2D

func _ready():
	# Ensure the RayCast2D is enabled to start checking
	raycast.enabled = true

func _process(delta):
	if raycast.is_colliding():
		var body = raycast.get_collider()
		
		if body:
			# Send the detected body to the parent node
			var parent_node = get_parent()
			parent_node.handle_body_detected(body)
