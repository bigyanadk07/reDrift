extends Control

@onready var label = $Label

func _ready():
	EventController.connect("coins_collected", on_event_coin_collected)


func on_event_coin_collected(value: int) -> void:
	label.text = str(value)
