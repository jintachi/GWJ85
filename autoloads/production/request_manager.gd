## Handles all things delivery
extends Node

signal update_current_request

var current_request : Request :
	set(value):
		current_request = value
		update_current_request.emit()
var current_count : int = 0

func _ready() -> void:
	current_request = _generate_request()

func deliver_item(item: GameItem, count: int = 1) -> void:
	if not Inventory.HasItem(item):
		return
	
	Inventory.RemoveItem(item, count)
	
	if not current_request:
		_sell_item(item)
		return
	
	if item == current_request.requested_item:
		current_count += count
		update_current_request.emit()
	else:
		_sell_item(item)
	
	if current_count >= current_request.requested_count:
		GameGlobal.level += 1
		current_count = 0
		current_request = _generate_request()

func _generate_request() -> Request:
	var new_request = Request.new()
	new_request.requested_item = CraftManager.grab_random_item()
	new_request.requested_count = GameGlobal.level * 5
	return new_request

func _sell_item(item: GameItem) -> void:
	GameGlobalEvents.gold_updated.emit(item.value)
