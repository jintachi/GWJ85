extends PanelContainer

#region Declarations
@export var inv_container : GridContainer

var game_node : Node

#endregion

#region Built-Ins
func _ready() -> void:
	
	await get_tree().process_frame
	
	game_node = get_tree().get_first_node_in_group(&"game")
	
	GameGlobalEvents.update_inventory.connect(_on_inventory_updated)
	
#endregion

#region Signal Callbacks
func _on_inventory_updated() -> void:
	for c in inv_container.get_children():
		c.queue_free()
	
	var inventory = Inventory.slots
	for slot in inventory :
		if slot.item != null :
			var item_tile = InventoryTile.new()
			item_tile._setup_item(slot.item, slot.amount)
			inv_container.add_child(item_tile)
		
	pass
#endregion
