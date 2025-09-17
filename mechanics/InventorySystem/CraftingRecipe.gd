extends Resource

class_name CraftingRecipe

@export var Name: StringName
@export var unlocked: bool = true
@export var item: GameItem
@export var ingredients: Array[InventorySlot]
