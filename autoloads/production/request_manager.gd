## Handles all things delivery
extends Node

var current_request : Request
var current_count : int = 0

func deliver_item(item: GameItem) -> void:
	if not current_request:
		_sell_item(item)
		return
	
	if item == current_request.requested_item:
		current_count += 1
	else:
		_sell_item(item)

func _sell_item(item: GameItem) -> void:
	GameGlobalEvents.gold_updated.emit(item.value)
