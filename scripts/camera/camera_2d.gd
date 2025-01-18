extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_right = global.camera_limitr
	limit_bottom = global.camera_limitb

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
