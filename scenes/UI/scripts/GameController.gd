extends Node

var total_coins: int = 0

func coin_collected(value: int):
	total_coins += value
	EventController.emit_signal("Coin Collected:", total_coins)
