## The actual Global containing all of the game's core information.
extends Node

#region Declarations
var delta_t : float = 1.0 ## The amount of time between ticks.
var player_inventory = Inventory.new()
var gold : int = 0 
#endregion

#region Built-Ins
func _ready() -> void:
	player_inventory = Inventory.new()
	player_inventory.add_to_group(&"Inventory")
	run_game_loop()
#endregion

#region Publics
func run_game_loop() -> void:
	await delay(delta_t)
	GameGlobalEvents.game_tick.emit()
	run_game_loop()
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout

func Sum(arr):
	var tot = 0
	for n in arr:
		tot+=n
	return tot

## get all children recursively
func get_all_descendants(node: Node, result := []):
	for child in node.get_children():
		result.append(child)
		get_all_descendants(child, result)
	return result
#endregion
