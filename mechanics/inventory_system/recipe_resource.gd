extends Resource

class_name GameRecipe

@export var Name: StringName
@export var unlocked: bool = true
@export var item: GameItem
@export var ingredients: Array[InventorySlot]


## check if ingredients are in inventory
func _canMake() -> bool:
	for i in ingredients:
		if GameGlobal.myInventory.HasItem(i.item, i.amount) == false:
			return false
	return true
	
func _make() -> bool:
	if _canMake() == false: return false
	else:
		for i in ingredients:
			GameGlobal.myInventory.RemoveItem(i.item, i.amount)
		GameGlobal.myInventory.AddItem(item, 1)
	return true
	
