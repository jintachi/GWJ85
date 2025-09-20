## Represents a singular tile that references a CellMap and all of its important
## parameters.
class_name CellTile extends Cell

#region Declaration
var produced : Array[ItemPacket] = []
var processed : Array[RecipePacket] = []
var delivered : Array[ItemPacket] = []
var map : Array[Cell] = []
#endregion

#region Helpers
func add_produce(packet: ItemPacket) -> void:
	for current_packet in produced:
		if current_packet.item == packet.item:
			current_packet.count += packet.count
			return
	
	produced.append(packet)

func add_recipe(packet: RecipePacket) -> void:
	for current_packet in processed:
		if current_packet.recipe == packet.recipe:
			current_packet.count += packet.count
			return

func process_tick() -> void:
	for packet in produced:
		Inventory.AddItem(packet.item, packet.count)
	
	for packet in processed:
		var item = CraftManager.request_craft(packet.recipe)
		if not item:
			continue
		Inventory.AddItem(item, 1)
	# TODO: Quest System Hook
	for packet in delivered:
		pass
#endregion
