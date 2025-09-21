extends Resource

class_name GameRecipe

@export var Name: StringName
@export var unlocked: bool = true
@export var item: GameItem
@export var ingredients: Array[ItemPacket]
@export var processor_id : int = 0
