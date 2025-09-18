## Holds all the item data that the player currently has.
extends Node

#region Declarations
signal update_inventory

@export var slots : Array[InventorySlot] 
@export var defaultSize: int = 10
#endregion

#region Helpers
##return the number of slots in inventory
func InvSize():
	return slots.size()

##expand inventory by n slots; 
func AddSlots(_n: int = 1) -> void:
	for x in range(_n):
		var newSlot = InventorySlot.new()
		slots.append(newSlot)
	update_inventory.emit()

##add n GameItem to inventory
func AddItem(new_item: GameItem, n: int) -> bool:
	## make sure there are slots; this need fixing and put someplace else
	if InvSize() == 0: 
		AddSlots(defaultSize)
	##add to slot that already contains item
	for slot in slots:
		if slot.item == new_item:
			slot.amount += n
			update_inventory.emit()
			return true
	## if you didn't find it; put into existing slot that's empty
	for slot in slots:		
		if slot.amount == 0:
			slot.item = new_item
			slot.amount = n
			update_inventory.emit()
			return true
	##for dynamic inventories uncomment the lines below
	##if you can't find one, create one
	#var new_slot = InventorySlot.new()
	#new_slot.item = new_item
	#new_slot.amount = n
	#slots.append(new_slot)
	#signal_update_inventory.emit()
	##if you didn't find a usable slot return false
	return false
func RemoveItem(item_to_remove: GameItem, n:int) -> bool:
	for slot in slots:
		if slot.item == item_to_remove:
			if slot.amount>=n:
				slot.amount -= n
				#if its now empty; clear it
				if slot.amount == 0:
					slot.item = null
				#for dynamic inventories uncomment the lines below
				#	slots.erase(slot)
				update_inventory.emit()
				return true
	return false
#endregion

#region Checks
func HasItem(item, n) -> bool:
	for slot in slots:
		if slot.item == item:
			if slot.amount >= n:
				return true
	return false

func ItemAmount(item) -> int:
	for slot in slots:
		if slot.item == item:
			return slot.amount
	return 0

func HasEmptySlot() -> bool:
	var has = false
	for slot in slots:
		if slot.amount == 0:
			return true
	return false
#endregion

#region Debug
func PukeConent():
	print ("=================")
	for slot in slots:
		if slot.item:
			print (slot.item.name)
			print (slot.amount)
			print ("-------------")
	print ("=================")
#endregion
