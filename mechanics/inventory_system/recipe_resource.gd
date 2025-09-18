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
	
